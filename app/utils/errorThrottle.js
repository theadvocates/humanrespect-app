/**
 * Throttling for error reports.
 *
 * A render loop can throw hundreds of identical errors a second. Reporting all
 * of them buries the signal and burns quota, so each distinct error is capped
 * per window and the session has an overall ceiling.
 *
 * Extracted from the error-tracking plugin so it can be tested directly — the
 * behaviour that matters (floods suppressed, distinct errors still reported,
 * the window actually expiring) is invisible from outside a closure.
 */

export const WINDOW_MS = 60_000
export const MAX_PER_ERROR = 3
export const MAX_TOTAL = 25

export function createErrorThrottle({
  windowMs = WINDOW_MS,
  maxPerError = MAX_PER_ERROR,
  maxTotal = MAX_TOTAL,
  now = () => Date.now()
} = {}) {
  const seen = new Map()
  let total = 0

  return {
    /** True if this signature should be reported right now. */
    shouldReport(signature) {
      if (total >= maxTotal) return false

      const t = now()
      const hits = (seen.get(signature) || []).filter((ts) => t - ts < windowMs)
      hits.push(t)
      seen.set(signature, hits)

      if (hits.length > maxPerError) return false
      total += 1
      return true
    },

    get totalReported() {
      return total
    }
  }
}
