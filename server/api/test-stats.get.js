/**
 * How everyone else's results on the short test are distributed.
 *
 * Returns `{ total, counts, grid }` once enough people have taken this
 * version of the test for a percentage to mean something, and `{ total: 0 }`
 * before that. `counts` is visitors by result; `grid` is visitors by the pair
 * of scores they landed on, which the map version draws as a faint crowd.
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

  const rpc = async (name) => {
    const res = await fetch(`${url}/rest/v1/rpc/${name}`, {
      method: 'POST',
      headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ p_version: TEST_VERSION })
    })
    return res.ok ? res.json() : null
  }

  try {
    const rows = await rpc('test_result_counts')
    if (!rows) return { total: 0 }

    const counts = Object.fromEntries(Object.keys(RESULTS).map((k) => [k, 0]))
    for (const row of rows) {
      if (row.result in counts) counts[row.result] += Number(row.visitors) || 0
    }
    const total = Object.values(counts).reduce((a, b) => a + b, 0)
    if (total < MIN_SAMPLE) return { total: 0 }

    // The grid is an addition; if its function is missing the headline
    // numbers still go out and the map simply has no crowd.
    const cells = (await rpc('test_score_counts').catch(() => null)) || []
    const onScale = (n) => Number.isInteger(n) && n >= 0 && n <= 100
    const grid = cells
      .map((c) => ({ directly: Number(c.directly), others: Number(c.others), visitors: Number(c.visitors) || 0 }))
      .filter((c) => onScale(c.directly) && onScale(c.others) && c.visitors > 0)
    return { total, counts, grid }
  } catch (e) {
    return { total: 0 }
  }
}, { maxAge: 600, name: 'test-stats', getKey: () => `v${TEST_VERSION}` })
