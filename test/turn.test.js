import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mountSuspended, mockNuxtImport } from '@nuxt/test-utils/runtime'
import TheTurn from '../app/components/turn/TheTurn.vue'

/**
 * The Turn is the front door. Two things about it are load-bearing and easy to
 * break silently:
 *
 *  - it must advance through all six beats, because a stuck transition leaves
 *    the visitor on a dead screen with no error anywhere
 *  - beat four must echo back the reasons the visitor actually chose, because
 *    that is the entire mechanism by which the argument reads as discovered
 *    rather than asserted. A generic list would look fine and mean nothing.
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

async function clickText(wrapper, text) {
  const el = wrapper.findAll('button').find((b) => b.text().includes(text))
  if (!el) throw new Error(`no button matching "${text}" — visible: ${wrapper.findAll('button').map((b) => b.text()).join(' / ')}`)
  await el.trigger('click')
  await new Promise((r) => setTimeout(r, 0))
  return el
}

describe('the Turn', () => {
  beforeEach(() => { captured.length = 0 })

  it('renders the first beat immediately, with no hidden state', async () => {
    const w = await mountSuspended(TheTurn)
    expect(w.text()).toContain('Think of someone you know who is wrong')
    // The old landing page kept its call to action invisible for 1.8s. The
    // first beat's button must exist on render.
    expect(w.findAll('button').length).toBeGreaterThan(0)
  })

  it('does not frame the recall around affection', async () => {
    const w = await mountSuspended(TheTurn)
    // 'someone you love' invites the rebuttal that political opponents are not
    // loved, which walks straight through the argument.
    expect(w.text().toLowerCase()).not.toContain('someone you love')
  })

  it('advances through every beat to the closing question', async () => {
    const w = await mountSuspended(TheTurn)

    await clickText(w, "Yes, I've got one")
    expect(w.text()).toContain('Now imagine a button')

    await clickText(w, "No, I wouldn't")
    expect(w.text()).toContain('Why not?')

    // Continue is disabled until at least one reason is chosen.
    const reasons = w.findAll('.reason')
    expect(reasons.length).toBeGreaterThan(2)
    await reasons[0].trigger('click')
    await clickText(w, 'Continue')
    expect(w.text()).toContain("what you didn't say")

    await clickText(w, 'Go on')
    expect(w.text()).toContain('harder part')

    await clickText(w, "So what's the question?")
    expect(w.text()).toContain('Would you pay someone else to?')
  })

  it('echoes back the reasons the visitor chose, and only those', async () => {
    const w = await mountSuspended(TheTurn)
    await clickText(w, "Yes, I've got one")
    await clickText(w, "No, I wouldn't")

    const reasons = w.findAll('.reason')
    await reasons[0].trigger('click')   // "wreck the relationship"
    await reasons[2].trigger('click')   // "they'd resent me"
    await clickText(w, 'Continue')

    const echoes = w.findAll('.echo').map((e) => e.text())
    expect(echoes).toHaveLength(2)
    expect(echoes.join(' ')).toMatch(/relationship/i)
    expect(echoes.join(' ')).toMatch(/resent/i)
    // The unchosen reasons must not appear — a static list would pass a
    // "shows some echoes" check while meaning nothing.
    expect(echoes.join(' ')).not.toMatch(/trust/i)
  })

  it('will not let the visitor continue without choosing a reason', async () => {
    const w = await mountSuspended(TheTurn)
    await clickText(w, "Yes, I've got one")
    await clickText(w, "No, I wouldn't")

    const cont = w.findAll('button').find((b) => b.text().includes('Continue'))
    expect(cont.attributes('disabled')).toBeDefined()

    await w.findAll('.reason')[0].trigger('click')
    expect(cont.attributes('disabled')).toBeUndefined()
  })

  it('adapts when the visitor admits they would use force', async () => {
    const w = await mountSuspended(TheTurn)
    await clickText(w, "Yes, I've got one")
    await clickText(w, 'Honestly, I might')
    // That answer must not be treated as a wrong one; it gets its own framing.
    expect(w.text()).toContain('Say you did press it')
  })

  it('reports each beat for the funnel', async () => {
    const w = await mountSuspended(TheTurn)
    await clickText(w, "Yes, I've got one")
    await clickText(w, "No, I wouldn't")

    const screens = captured.filter((c) => c.type === 'screen').map((c) => c.screen)
    expect(screens).toContain('recall')
    expect(screens).toContain('the-button')
    expect(screens).toContain('why-not')
    expect(captured.every((c) => c.experience === 'turn')).toBe(true)
  })
})
