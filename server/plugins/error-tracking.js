/**
 * Server-side error capture.
 *
 * SSR and API route failures never reached anywhere useful — Nitro's default
 * output is unstructured, so a 500 in production was a line of prose in the
 * Vercel log at best.
 *
 * These are emitted as single-line JSON so Vercel's log viewer can filter and
 * search them, and so a log drain could parse them later without changes here.
 * PostHog is deliberately not called: it would mean a network round trip on
 * the error path of a request that is already failing.
 */
export default defineNitroPlugin((nitroApp) => {
  nitroApp.hooks.hook('error', (error, { event }) => {
    const status = error?.statusCode || 500

    // Client errors are expected behaviour, not faults: a mistyped email is a
    // 400 and a missing page is a 404, and logging either at volume buries the
    // failures that matter. 429 is the exception — sustained rate limiting
    // means either abuse or a misconfigured limiter, and both are worth seeing.
    if (status < 500 && status !== 429) return

    console.error(JSON.stringify({
      level: 'error',
      source: 'nitro',
      status,
      message: String(error?.message || error).slice(0, 500),
      path: event?.path,
      method: event?.method,
      // Truncated for the same reason as the client: the top frames are what
      // identify the fault.
      stack: String(error?.stack || '').split('\n').slice(0, 8).join(' | ').slice(0, 1200),
      at: new Date().toISOString()
    }))
  })
})
