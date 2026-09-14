import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mountSuspended, mockNuxtImport } from '@nuxt/test-utils/runtime'
import RespectTest from '../app/components/test/RespectTest.vue'
import { ITEMS, RESULTS, score, classify } from '../app/utils/respectTest.js'
import { PARTNERS, resolvePartner, partnerHref } from '../app/utils/testPartners.js'

/**
 * The short test makes a claim with a number attached, so the number has to be
 * right. Three things are load-bearing:
 *
 *  - the halves must be matched item for item, or the gap measures nothing
 *  - the score must follow the WSPQ convention people will compare it against
 *  - the copy must stay inside the Six Key Concepts rules; the first draft of
 *    this test broke them in three places before anyone noticed
 */

const captured = []
mockNuxtImport('useAnalytics', () => () => ({
  trackScreenView: (experience, screen) => captured.push({ type: 'screen', experience, screen }),
  trackChoice: (experience, question, props) => captured.push({ type: 'choice', experience, question, props }),
  trackCompletion: vi.fn(),
  trackShare: vi.fn(),
  trackNewsletterSignup: vi.fn(),
  trackAbandonOnExit: vi.fn(),
  capture: vi.fn()
}))

const allAs = (fn) => Object.fromEntries(ITEMS.map((i) => [i.id, fn(i)]))

describe('scoring', () => {
  it('matches every "directly" item with a "through others" item on the same topic', () => {
    const topic = (i) => i.id.slice(2)
    const d = ITEMS.filter((i) => i.part === 'directly').map(topic)
    const o = ITEMS.filter((i) => i.part === 'others').map(topic)
    expect(d).toHaveLength(5)
    expect(o).toEqual(d)
  })

  it('scores agree 20, maybe 10, disagree 0, to 100 per half', () => {
    expect(score(allAs(() => 'agree'))).toEqual({ directly: 100, others: 100, gap: 0 })
    expect(score(allAs(() => 'maybe'))).toEqual({ directly: 50, others: 50, gap: 0 })
    expect(score(allAs(() => 'disagree'))).toEqual({ directly: 0, others: 0, gap: 0 })
    expect(score(allAs((i) => (i.part === 'directly' ? 'agree' : 'maybe'))).gap).toBe(50)
  })

  it('classifies the four corners', () => {
    expect(classify({ directly: 100, others: 90 })).toBe('consistent')
    expect(classify({ directly: 90, others: 40 })).toBe('loophole')
    expect(classify({ directly: 20, others: 10 })).toBe('force')
    expect(classify({ directly: 50, others: 50 })).toBe('weighing')
    // Rare, but possible: stricter about delegated force than one's own.
    expect(classify({ directly: 40, others: 90 })).toBe('weighing')
  })
})

describe('copy', () => {
  const everything = [
    ...ITEMS.map((i) => i.text),
    ...Object.values(RESULTS).flatMap((r) => [r.name, r.head, ...r.body])
  ].join(' ').toLowerCase()

  it('stays inside the Six Key Concepts rules', () => {
    // "Rights are not a concept in this philosophy."
    expect(everything).not.toMatch(/\b(a|no|the|my|their) right\b|\brights\b/)
    // Harm-principle framing reads as classical liberalism, which the rules
    // name as the tell that something is not Human Respect.
    expect(everything).not.toMatch(/harming anyone|peaceful person|non-aggression/)
  })

  it('does not name parties or ideologies in the statements', () => {
    const statements = ITEMS.map((i) => i.text).join(' ').toLowerCase()
    expect(statements).not.toMatch(/libertarian|democrat|republican|liberal|conservative|tax/)
  })
})

async function click(wrapper, text) {
  const el = wrapper.findAll('button').find((b) => b.text().trim() === text || b.text().includes(text))
  if (!el) throw new Error(`no button matching "${text}" — visible: ${wrapper.findAll('button').map((b) => b.text()).join(' / ')}`)
  await el.trigger('click')
  await new Promise((r) => setTimeout(r, 0))
}

describe('the test', () => {
  beforeEach(() => { captured.length = 0 })

  it('renders its intro with a heading and a start button, nothing hidden', async () => {
    const w = await mountSuspended(RespectTest)
    expect(w.find('h1').text()).toBe('Persuade or force?')
    expect(w.text()).toContain('Start')
  })

  it('runs ten statements to a result that shows both scores and the gap', async () => {
    const w = await mountSuspended(RespectTest)
    await click(w, 'Start')

    for (let n = 0; n < ITEMS.length; n++) {
      expect(w.text()).toContain(ITEMS[n].text)
      expect(w.text()).toContain(`${n + 1} of 10`)
      await click(w, n < 5 ? 'Agree' : 'Disagree')
    }

    expect(w.text()).toContain('Your result')
    expect(w.find('.marker-you').text()).toContain('100')
    expect(w.find('.marker-others').text()).toContain('0')
    expect(w.text()).toContain('Your gap: 100 points')
    expect(w.text()).toContain(RESULTS.loophole.head)
    // The share belongs at the reveal, and must carry the scores with it.
    expect(w.text()).toContain('Copy link')
  })

  it('announces the switch to the second half', async () => {
    const w = await mountSuspended(RespectTest)
    await click(w, 'Start')
    for (let n = 0; n < 5; n++) await click(w, 'Agree')
    expect(w.text()).toContain('Part 2')
    expect(w.text()).toMatch(/Now, when a vote, a law, or a leader/)
  })

  it('lets a mistap be undone without losing the other answers', async () => {
    const w = await mountSuspended(RespectTest)
    await click(w, 'Start')
    await click(w, 'Disagree')
    await click(w, 'Back')
    expect(w.text()).toContain(ITEMS[0].text)
    expect(w.find('.rt-answer.picked').text()).toBe('Disagree')

    await click(w, 'Agree')
    for (let n = 1; n < ITEMS.length; n++) await click(w, 'Agree')
    expect(w.text()).toContain(RESULTS.consistent.head)
    expect(w.text()).not.toContain('Your gap')
  })

  it('reports each statement for the funnel, and the result with its scores', async () => {
    const w = await mountSuspended(RespectTest)
    await click(w, 'Start')
    for (let n = 0; n < ITEMS.length; n++) await click(w, 'Maybe')

    const screens = captured.filter((c) => c.type === 'screen').map((c) => c.screen)
    expect(screens).toContain('intro')
    expect(screens).toContain('q1')
    expect(screens).toContain('q10')
    expect(screens).toContain('result')

    const result = captured.find((c) => c.type === 'choice' && c.question === 'result')
    expect(result.props).toMatchObject({ result: 'weighing', directly: 50, others: 50, gap: 0 })
    expect(captured.every((c) => c.experience === 'test')).toBe(true)
  })
})

describe('partner versions', () => {
  beforeEach(() => { captured.length = 0 })

  it('picks a partner from ?partner=, then utm_source, then the referring site', () => {
    expect(resolvePartner({ query: { partner: 'SFL' } })).toBe('sfl')
    expect(resolvePartner({ query: { utm_source: 'youarethepower' } })).toBe('yatp')
    expect(resolvePartner({ query: { utm_source: 'You-Are-The-Power' } })).toBe('yatp')
    expect(resolvePartner({ referrer: 'https://www.youarethepower.net/causes/' })).toBe('yatp')
    expect(resolvePartner({ referrer: 'https://join.studentsforliberty.org/' })).toBe('sfl')
    expect(resolvePartner({ referrer: 'https://www.respectamerica.org/?gclid=abc' })).toBe('ra')
    expect(resolvePartner({ query: { utm_source: 'theadvocates' } })).toBe('asg')
    // An explicit tag beats wherever the click came from.
    expect(resolvePartner({ query: { partner: 'sfl' }, referrer: 'https://youarethepower.net/' })).toBe('sfl')
  })

  it('keeps unapproved partners off the production site, and on previews', () => {
    for (const [id, p] of Object.entries(PARTNERS)) {
      const query = { partner: id }
      const expected = p.approved ? id : null
      expect(resolvePartner({ query, host: 'humanrespect.app' }), `${id} on production`).toBe(expected)
      expect(resolvePartner({ query, host: 'www.humanrespect.app' }), `${id} on www`).toBe(expected)
      expect(resolvePartner({ query, host: 'humanrespect-app-git-respect-test.vercel.app' })).toBe(id)
      expect(resolvePartner({ query, host: 'localhost' })).toBe(id)
    }
  })

  it('falls back to the default test for anything it does not recognise', () => {
    expect(resolvePartner({ query: { utm_source: 'facebook' } })).toBeNull()
    expect(resolvePartner({ referrer: 'https://notyouarethepower.net/' })).toBeNull()
    expect(resolvePartner({ referrer: 'not a url' })).toBeNull()
    expect(resolvePartner()).toBeNull()
  })

  it('tags outbound links so the partner can attribute them by result', () => {
    const url = new URL(partnerHref('https://studentsforliberty.org/get-involved/', 'loophole'))
    expect(url.searchParams.get('utm_source')).toBe('humanrespect.app')
    expect(url.searchParams.get('utm_content')).toBe('loophole')
  })

  it('gives every partner a line for every result, inside the copy rules', () => {
    for (const [id, p] of Object.entries(PARTNERS)) {
      for (const key of Object.keys(RESULTS)) {
        expect(p.results[key], `${id} has no line for ${key}`).toBeTruthy()
        expect(p.results[key].toLowerCase()).not.toMatch(/\b(a|no|the|my|their) right\b|\brights\b/)
      }
      expect(p.cta.length).toBeGreaterThan(0)
      for (const c of p.cta) expect(() => new URL(c.href)).not.toThrow()
    }
  })

  it('renders a tagged link with the partner intro, the same statements, and partner links on the result', async () => {
    const w = await mountSuspended(RespectTest, { route: '/test?utm_source=sfl' })
    expect(w.text()).toContain(PARTNERS.sfl.intro.eyebrow)
    expect(w.text()).toContain(PARTNERS.sfl.intro.lead)

    await click(w, 'Start')
    for (let n = 0; n < ITEMS.length; n++) {
      expect(w.text(), 'partners must not get different statements').toContain(ITEMS[n].text)
      await click(w, n < 5 ? 'Agree' : 'Disagree')
    }

    expect(w.text()).toContain(RESULTS.loophole.head)
    expect(w.text()).toContain(PARTNERS.sfl.results.loophole)
    const links = w.findAll('a.path').map((a) => a.attributes('href'))
    expect(links[0]).toContain('studentsforliberty.org')
    expect(links[0]).toContain('utm_content=loophole')

    const result = captured.find((c) => c.type === 'choice' && c.question === 'result')
    expect(result.props.partner).toBe('sfl')
  })

  it('leaves the default test untouched without a tag', async () => {
    const w = await mountSuspended(RespectTest, { route: '/test' })
    expect(w.text()).toContain('The Human Respect Test')
    for (const p of Object.values(PARTNERS)) expect(w.text()).not.toContain(p.name)
  })
})
