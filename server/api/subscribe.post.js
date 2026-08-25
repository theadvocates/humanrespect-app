/**
 * Newsletter subscription endpoint.
 *
 * Runs server-side so the Buttondown API key is never shipped to the browser.
 * Writes to Supabase (when configured) and Buttondown; succeeds if either does.
 */
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

// Naive in-memory rate limit: enough to blunt casual abuse of a public endpoint.
const attempts = new Map()
const WINDOW_MS = 60_000
const MAX_PER_WINDOW = 5

function rateLimited(ip) {
  const now = Date.now()
  const hits = (attempts.get(ip) || []).filter((t) => now - t < WINDOW_MS)
  hits.push(now)
  attempts.set(ip, hits)
  if (attempts.size > 5000) attempts.clear()
  return hits.length > MAX_PER_WINDOW
}

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const ip = getRequestHeader(event, 'x-forwarded-for')?.split(',')[0]?.trim() || 'unknown'

  if (rateLimited(ip)) {
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
    saveToButtondown(config, { email, source, visitorId, furthestTier })
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

async function saveToButtondown(config, { email, source, visitorId, furthestTier }) {
  const apiKey = config.buttondownApiKey
  if (!apiKey) throw new Error('buttondown not configured')

  const res = await fetch('https://api.buttondown.com/v1/subscribers', {
    method: 'POST',
    headers: { Authorization: `Token ${apiKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      email_address: email,
      tags: [source],
      metadata: { visitor_id: visitorId, furthest_tier: furthestTier, source }
    })
  })

  // 409 = already subscribed.
  if (res.status === 409) return
  if (!res.ok) {
    const detail = await res.text().catch(() => '')
    throw new Error(`buttondown ${res.status}: ${detail.slice(0, 200)}`)
  }
}
