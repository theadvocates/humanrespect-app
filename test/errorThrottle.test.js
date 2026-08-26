import { describe, it, expect } from 'vitest'
import { createErrorThrottle } from '../app/utils/errorThrottle.js'

/**
 * Error throttling has two ways to fail, and both are silent: report too much
 * and a render loop buries every real fault; report too little and the thing
 * you needed to see never arrives.
 */
describe('error throttle', () => {
  it('reports a distinct error the first time', () => {
    const t = createErrorThrottle()
    expect(t.shouldReport('vue:boom')).toBe(true)
  })

  it('caps a repeated error at three within the window', () => {
    const t = createErrorThrottle()
    const results = Array.from({ length: 10 }, () => t.shouldReport('vue:same'))
    expect(results.filter(Boolean)).toHaveLength(3)
    expect(t.totalReported).toBe(3)
  })

  it('does not let one noisy error suppress a different one', () => {
    const t = createErrorThrottle()
    for (let i = 0; i < 20; i++) t.shouldReport('vue:noisy')
    // The regression this guards: a global counter rather than a per-signature
    // one would swallow the error you actually needed.
    expect(t.shouldReport('promise:rare')).toBe(true)
  })

  it('allows the same error again once its window has passed', () => {
    let clock = 0
    const t = createErrorThrottle({ windowMs: 1000, now: () => clock })

    expect(t.shouldReport('vue:x')).toBe(true)
    expect(t.shouldReport('vue:x')).toBe(true)
    expect(t.shouldReport('vue:x')).toBe(true)
    expect(t.shouldReport('vue:x')).toBe(false)

    clock += 1001
    expect(t.shouldReport('vue:x'), 'window should have expired').toBe(true)
  })

  it('stops reporting once the session ceiling is reached', () => {
    const t = createErrorThrottle({ maxTotal: 5 })
    // Distinct signatures, so only the total ceiling can stop them.
    for (let i = 0; i < 20; i++) t.shouldReport(`vue:error-${i}`)
    expect(t.totalReported).toBe(5)
    expect(t.shouldReport('vue:one-more')).toBe(false)
  })

  it('counts only reported errors toward the ceiling, not suppressed ones', () => {
    const t = createErrorThrottle({ maxTotal: 10 })
    for (let i = 0; i < 30; i++) t.shouldReport('vue:same')
    // 30 attempts, 3 reported — the other 27 must not consume the budget.
    expect(t.totalReported).toBe(3)
    expect(t.shouldReport('vue:different')).toBe(true)
  })
})
