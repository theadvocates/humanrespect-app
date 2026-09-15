import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAnalytics } from '../app/composables/useAnalytics'
import { useJourneyStore } from '../app/stores/journey'

/**
 * The analytics numbers drive growth decisions, so the events themselves are
 * under test: one completion event per completion, carrying its data, and
 * choice answers that PostHog can actually filter on.
 */

function setup() {
  setActivePinia(createPinia())
  const journey = useJourneyStore()
  journey.visitorId = 'test-visitor'
  // Keep the store off the network and record what reaches the Supabase sink.
  vi.spyOn(journey, 'syncToSupabase').mockResolvedValue()
  const events = []
  vi.spyOn(journey, 'trackEvent').mockImplementation((name, props) => { events.push({ name, props }) })
  return { journey, events, analytics: useAnalytics() }
}

describe('trackCompletion', () => {
  let ctx
  beforeEach(() => { ctx = setup() })

  it('emits exactly one experience_completed event with the completion data', () => {
    ctx.analytics.trackCompletion('pillarB', { income: 60000, taxRate: 30 })
    const done = ctx.events.filter((e) => e.name === 'experience_completed')
    expect(done).toHaveLength(1)
    expect(done[0].props).toMatchObject({
      experience: 'pillarB', tier: 'pillar', income: 60000, taxRate: 30, repeat: false, total_completed: 1
    })
  })

  it('keeps exp01 answers in the event and in the store', () => {
    ctx.analytics.trackCompletion('exp01', { methods: ['talk'], would_force: 'no', why_not: ['resent'] })
    const done = ctx.events.filter((e) => e.name === 'experience_completed')
    expect(done).toHaveLength(1)
    expect(done[0].props).toMatchObject({ experience: 'exp01', methods: ['talk'], would_force: 'no' })
    expect(ctx.journey.exp01.methods).toEqual(['talk'])
  })

  it('tags a revisit as a repeat instead of counting a new completion', () => {
    ctx.analytics.trackCompletion('exp04')
    ctx.analytics.trackCompletion('exp04')
    const done = ctx.events.filter((e) => e.name === 'experience_completed')
    expect(done.map((e) => e.props.repeat)).toEqual([false, true])
    expect(done[1].props.total_completed).toBe(1)
  })

  it('does not erase the objection chosen earlier in exp02', () => {
    ctx.journey.exp02.chosenObjection = 'chaos'
    ctx.analytics.trackCompletion('exp02')
    expect(ctx.journey.exp02.chosenObjection).toBe('chaos')
    expect(ctx.journey.exp02.completed).toBe(true)
    expect(ctx.journey.exp02.exploredObjections).toContain('chaos')
  })
})

describe('trackChoice', () => {
  let ctx
  beforeEach(() => { ctx = setup() })

  it('keeps a string answer under `answer`', () => {
    ctx.analytics.trackChoice('exp02', 'objection', 'chaos')
    expect(ctx.events[0].props).toMatchObject({ experience: 'exp02', question: 'objection', answer: 'chaos' })
  })

  it('flattens an object answer into top-level properties', () => {
    ctx.analytics.trackChoice('test', 'q3', { answer: 'force', partner: 'advocates', seconds: 4 })
    const props = ctx.events[0].props
    expect(props).toMatchObject({ experience: 'test', question: 'q3', answer: 'force', partner: 'advocates', seconds: 4 })
    expect(typeof props.answer).toBe('string')
  })

  it('never lets an object answer overwrite the experience or question', () => {
    ctx.analytics.trackChoice('test', 'result', { question: 'x', experience: 'y', result: 'persuader' })
    expect(ctx.events[0].props).toMatchObject({ experience: 'test', question: 'result', result: 'persuader' })
  })

  it('keeps an array answer intact', () => {
    ctx.analytics.trackChoice('exp03', 'conditions', ['safety', 'trust'])
    expect(ctx.events[0].props.answer).toEqual(['safety', 'trust'])
  })
})
