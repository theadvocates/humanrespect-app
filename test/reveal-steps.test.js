import { describe, it, expect, vi } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import TraceTheChain from '../app/components/experiences/exp05/TraceTheChain.vue'
import Response from '../app/components/experiences/exp02/Response.vue'

/**
 * Two screens reveal their content one piece at a time. The pieces not yet
 * revealed must not be in the layout at all: hidden with opacity, they kept
 * their full height and pushed the "Then what happens?" button to the bottom
 * of an empty page.
 */

vi.mock('../app/composables/useAnalytics', () => ({
  useAnalytics: () => ({ trackChoice: vi.fn(), trackScreenView: vi.fn(), trackCompletion: vi.fn(), capture: vi.fn() })
}))

describe('revealed-in-steps screens', () => {
  it('the chain only renders the links revealed so far', async () => {
    const w = await mountSuspended(TraceTheChain)
    expect(w.findAll('.chain-step')).toHaveLength(0)
    await w.find('.policy-btn').trigger('click')
    expect(w.findAll('.chain-step')).toHaveLength(1)
    await w.find('.reveal-btn').trigger('click')
    expect(w.findAll('.chain-step')).toHaveLength(2)
  })

  it('the response only renders the paragraphs read so far', async () => {
    const w = await mountSuspended(Response)
    expect(w.findAll('.response-block')).toHaveLength(1)
    await w.find('.reaction-btn').trigger('click')
    await new Promise((r) => setTimeout(r, 0))
    expect(w.findAll('.response-block')).toHaveLength(2)
  })
})
