import { describe, it, expect } from 'vitest'
import { EXPERIENCES, TIERS, TIER_ORDER, byTier, totalMinutes } from '../app/utils/experiences.js'
import { pageMeta } from '../app/utils/seo.js'

/**
 * The curriculum used to be duplicated across four files and they drifted:
 * your-journey.vue showed exp02's description under exp03 and vice versa, so
 * "What Flourishing Actually Means" was advertised as "pick your strongest
 * objection". It shipped, and nothing caught it.
 *
 * These are the checks that would have.
 */
describe('experience catalogue', () => {
  it('has fifteen experiences', () => {
    expect(EXPERIENCES).toHaveLength(15)
  })

  it('gives every experience a unique id, route and path', () => {
    for (const key of ['id', 'route', 'path']) {
      const values = EXPERIENCES.map((e) => e[key])
      expect(new Set(values).size, `duplicate ${key}`).toBe(values.length)
    }
  })

  it('gives every experience the fields the UI renders', () => {
    for (const e of EXPERIENCES) {
      expect(e.title, `${e.id} title`).toBeTruthy()
      expect(e.short, `${e.id} description`).toBeTruthy()
      expect(e.minutes, `${e.id} minutes`).toBeGreaterThan(0)
      expect(TIER_ORDER, `${e.id} tier`).toContain(e.tier)
    }
  })

  it('starts every path with a known section', () => {
    for (const e of EXPERIENCES) {
      expect(e.path, `${e.id} path`).toMatch(/^\/(experience|pillar|practice)\/[a-z0-9-]+$/)
    }
  })

  /**
   * The specific regression: a description that belongs to another experience.
   * Each description must be recognisably about its own subject rather than
   * simply non-empty.
   */
  it('does not swap descriptions between experiences', () => {
    const fingerprints = {
      exp02: /objection/i,
      exp03: /flourish|empirical|grounding/i,
      exp05: /steal|hire|agency|intermediary/i,
      pillarB: /time/i,
      pillarC: /propert|built|material/i
    }
    for (const [id, pattern] of Object.entries(fingerprints)) {
      const e = EXPERIENCES.find((x) => x.id === id)
      expect(e, `${id} missing`).toBeDefined()
      // Deliberately checks `short` alone. Including the title made this
      // vacuous: exp02's title is "The Objection", which satisfies /objection/
      // regardless of what its description actually says, so the swap that
      // shipped went undetected.
      expect(
        e.short,
        `${id} description does not mention its own subject — descriptions may be swapped`
      ).toMatch(pattern)
    }
  })

  it('keeps every experience in sync with its SEO entry', () => {
    for (const e of EXPERIENCES) {
      expect(pageMeta[e.id], `${e.id} has no entry in seo.js`).toBeDefined()
      expect(pageMeta[e.id].description, `${e.id} SEO description`).toBeTruthy()
    }
  })

  it('orders tiers without gaps or collisions', () => {
    for (const tier of TIER_ORDER) {
      const orders = byTier(tier).map((e) => e.order)
      expect(orders, `${tier} ordering`).toEqual([...orders].sort((a, b) => a - b))
      expect(new Set(orders).size, `${tier} duplicate order`).toBe(orders.length)
    }
  })

  it('describes every tier it uses', () => {
    for (const tier of TIER_ORDER) {
      expect(TIERS[tier], `${tier} label`).toBeDefined()
      expect(TIERS[tier].label).toBeTruthy()
      expect(TIERS[tier].note).toBeTruthy()
    }
    const used = new Set(EXPERIENCES.map((e) => e.tier))
    for (const tier of used) expect(TIER_ORDER).toContain(tier)
  })

  it('reports a total duration matching the sum of its parts', () => {
    expect(totalMinutes()).toBe(EXPERIENCES.reduce((n, e) => n + e.minutes, 0))
  })
})
