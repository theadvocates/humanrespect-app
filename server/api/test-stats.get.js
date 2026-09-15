/**
 * How everyone else's results on the short test are distributed.
 *
 * Returns `{ total, counts }` once enough people have taken this version of
 * the test for a percentage to mean something, and `{ total: 0 }` before that.
 * The page shows nothing in that case: a number from a dozen visitors, most of
 * them us, would be a made-up number with a percent sign on it.
 *
 * Cached for ten minutes, so a busy day costs one query every ten minutes.
 */
import { RESULTS, TEST_VERSION } from '../../app/utils/respectTest.js'

export const MIN_SAMPLE = 50

export default defineCachedEventHandler(async () => {
  const config = useRuntimeConfig()
  const url = config.public.supabaseUrl
  const key = config.supabaseServiceKey
  if (!url || !key) return { total: 0 }

  try {
    const res = await fetch(`${url}/rest/v1/rpc/test_result_counts`, {
      method: 'POST',
      headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ p_version: TEST_VERSION })
    })
    if (!res.ok) return { total: 0 }
    const rows = await res.json()

    const counts = Object.fromEntries(Object.keys(RESULTS).map((k) => [k, 0]))
    for (const row of rows) {
      if (row.result in counts) counts[row.result] += Number(row.visitors) || 0
    }
    const total = Object.values(counts).reduce((a, b) => a + b, 0)
    return total >= MIN_SAMPLE ? { total, counts } : { total: 0 }
  } catch (e) {
    return { total: 0 }
  }
}, { maxAge: 600, name: 'test-stats', getKey: () => `v${TEST_VERSION}` })
