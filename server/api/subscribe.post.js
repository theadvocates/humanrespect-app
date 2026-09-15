/**
 * Newsletter subscription endpoint.
 *
 * Runs server-side so the Resend API key is never shipped to the browser.
 * Writes to Supabase (when configured) and to a Resend audience; succeeds if
 * either does.
 */
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const MAX_PER_WINDOW = 5
const WINDOW_SECS = 60

/**
 * Rate limiting lives in Postgres, not in module memory: each serverless
 * instance has its own memory and instances are recycled, so an in-process
 * counter is per-instance and effectively unenforced. The database is the
 * shared state every instance already has.
 *
 * Fails open — a limiter outage should not take signups down with it.
 */
async function rateLimited(config, ip) {
  const url = config.public.supabaseUrl
  const key = config.supabaseServiceKey
  if (!url || !key) return false

  try {
    const res = await fetch(`${url}/rest/v1/rpc/check_rate_limit`, {
      method: 'POST',
      headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        p_bucket: 'subscribe',
        p_identifier: ip,
        p_max: MAX_PER_WINDOW,
        p_window_secs: WINDOW_SECS
      })
    })
    if (!res.ok) return false
    return (await res.json()) === false
  } catch {
    return false
  }
}

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const ip = getRequestHeader(event, 'x-forwarded-for')?.split(',')[0]?.trim() || 'unknown'

  if (await rateLimited(config, ip)) {
    throw createError({ statusCode: 429, statusMessage: 'Too many requests. Try again shortly.' })
  }

  const body = await readBody(event)
  const email = String(body?.email || '').toLowerCase().trim()
  const source = String(body?.source || 'unknown').slice(0, 64)
  const visitorId = body?.visitorId ? String(body.visitorId).slice(0, 64) : null
  const furthestTier = body?.furthestTier ? String(body.furthestTier).slice(0, 32) : null

  if (!EMAIL_RE.test(email) || email.length > 254) {
    throw createError({ statusCode: 400, statusMessage: 'Please enter a valid email address.' })
  }

  const results = await Promise.allSettled([
    saveToSupabase(config, { email, source, visitorId }),
    saveToResend(config, { email, source, visitorId, furthestTier })
  ])

  const anySucceeded = results.some((r) => r.status === 'fulfilled')
  if (!anySucceeded) {
    console.error('[subscribe] all providers failed', results.map((r) => r.reason?.message))
    throw createError({ statusCode: 502, statusMessage: 'Something went wrong. Please try again.' })
  }

  return { ok: true }
})

async function saveToSupabase(config, { email, source, visitorId }) {
  const url = config.public.supabaseUrl
  const key = config.supabaseServiceKey || config.public.supabaseAnonKey
  if (!url || !key) throw new Error('supabase not configured')

  const res = await fetch(`${url}/rest/v1/newsletter_subscribers`, {
    method: 'POST',
    headers: {
      apikey: key,
      Authorization: `Bearer ${key}`,
      'Content-Type': 'application/json',
      Prefer: 'resolution=ignore-duplicates'
    },
    body: JSON.stringify({
      email,
      source,
      visitor_id: visitorId,
      subscribed_at: new Date().toISOString()
    })
  })

  if (!res.ok) {
    const detail = await res.text().catch(() => '')
    // 23505 = unique violation; the address is already on the list.
    if (detail.includes('23505')) return
    throw new Error(`supabase ${res.status}: ${detail.slice(0, 200)}`)
  }
}

// Adds the address to the Resend audience that broadcasts go out to. Resend
// has no per-contact tags, so where the signup came from is kept in Supabase.
async function saveToResend(config, { email }) {
  const apiKey = config.resendApiKey
  const audienceId = config.resendAudienceId
  if (!apiKey || !audienceId) throw new Error('resend not configured')

  const res = await fetch(`https://api.resend.com/audiences/${audienceId}/contacts`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, unsubscribed: false })
  })

  // Resend treats a repeat address as an update, so a duplicate is not an error.
  if (!res.ok) {
    const detail = await res.text().catch(() => '')
    throw new Error(`resend ${res.status}: ${detail.slice(0, 200)}`)
  }
}
