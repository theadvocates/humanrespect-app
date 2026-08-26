import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mountSuspended, mockNuxtImport } from '@nuxt/test-utils/runtime'
import ShareLink from '../app/components/shared/ShareLink.vue'

/**
 * The share loop is the site's only growth mechanism. Before it existed there
 * was a single clipboard copy buried in an experience nobody had ever
 * completed, and it copied the bare home page URL.
 *
 * Two things have to hold or the loop is decorative: the links must be
 * well-formed, and they must carry ?ref=share so arrivals can actually be
 * attributed rather than assumed.
 */

const shares = []
mockNuxtImport('useAnalytics', () => () => ({
  trackShare: (method, source) => shares.push({ method, source }),
  trackScreenView: vi.fn(), trackChoice: vi.fn(), trackCompletion: vi.fn(),
  trackNewsletterSignup: vi.fn(), trackAbandonOnExit: vi.fn(), capture: vi.fn()
}))

describe('ShareLink', () => {
  beforeEach(() => { shares.length = 0 })

  it('offers copy, X and email without requiring native share', async () => {
    const w = await mountSuspended(ShareLink, { props: { source: 'test' } })
    const text = w.text()
    expect(text).toContain('Copy link')
    expect(text).toContain('Post')
    expect(text).toContain('Email')
  })

  it('tags every shared URL so arrivals can be attributed', async () => {
    const w = await mountSuspended(ShareLink, { props: { path: '/', source: 'test' } })
    for (const a of w.findAll('a')) {
      const href = a.attributes('href')
      expect(decodeURIComponent(href), 'a share link without ?ref=share is unattributable')
        .toContain('?ref=share')
    }
  })

  it('builds a valid X intent carrying the site URL', async () => {
    const w = await mountSuspended(ShareLink, { props: { source: 'test' } })
    const href = w.findAll('a').map((a) => a.attributes('href')).find((h) => h.includes('x.com'))
    expect(() => new URL(href)).not.toThrow()
    const q = new URL(href).searchParams
    expect(q.get('url')).toBe('https://humanrespect.app/?ref=share')
    expect(q.get('text')).toBeTruthy()
  })

  it('builds a mailto with both a subject and the link in the body', async () => {
    const w = await mountSuspended(ShareLink, { props: { source: 'test' } })
    const href = w.findAll('a').map((a) => a.attributes('href')).find((h) => h.startsWith('mailto:'))
    expect(href).toBeTruthy()
    const decoded = decodeURIComponent(href)
    expect(decoded).toMatch(/subject=.+/)
    expect(decoded).toContain('https://humanrespect.app/?ref=share')
  })

  it('shares the page it was given, not always the home page', async () => {
    const w = await mountSuspended(ShareLink, { props: { path: '/certificate/abc123', source: 'cert' } })
    const href = w.findAll('a').map((a) => a.attributes('href')).find((h) => h.includes('x.com'))
    expect(new URL(href).searchParams.get('url')).toBe('https://humanrespect.app/certificate/abc123?ref=share')
  })

  it('records which share method was used, and from where', async () => {
    const w = await mountSuspended(ShareLink, { props: { source: 'turn_question' } })
    const x = w.findAll('a').find((a) => a.attributes('href').includes('x.com'))
    await x.trigger('click')
    expect(shares).toContainEqual({ method: 'x', source: 'turn_question' })
  })

  it('confirms a copy so the button is never silently dead', async () => {
    const writeText = vi.fn().mockResolvedValue()
    vi.stubGlobal('navigator', { ...navigator, clipboard: { writeText } })

    const w = await mountSuspended(ShareLink, { props: { source: 'test' } })
    const btn = w.findAll('button').find((b) => b.text().includes('Copy link'))
    await btn.trigger('click')
    await new Promise((r) => setTimeout(r, 0))

    expect(writeText).toHaveBeenCalledWith('https://humanrespect.app/?ref=share')
    expect(w.text()).toContain('Link copied')
    expect(shares).toContainEqual({ method: 'copy', source: 'test' })
    vi.unstubAllGlobals()
  })

  it('still copies when the clipboard API refuses', async () => {
    // Clipboard access needs a secure context and can be denied outright; the
    // fallback exists so the button does something rather than nothing.
    vi.stubGlobal('navigator', { ...navigator, clipboard: { writeText: vi.fn().mockRejectedValue(new Error('denied')) } })
    document.execCommand = vi.fn().mockReturnValue(true)

    const w = await mountSuspended(ShareLink, { props: { source: 'test' } })
    const btn = w.findAll('button').find((b) => b.text().includes('Copy link'))
    await btn.trigger('click')
    await new Promise((r) => setTimeout(r, 0))

    expect(document.execCommand).toHaveBeenCalledWith('copy')
    expect(w.text()).toContain('Link copied')
    vi.unstubAllGlobals()
  })

  it('lets the caller change the prompt for context', async () => {
    const w = await mountSuspended(ShareLink, { props: { prompt: 'Share it.', source: 'cert' } })
    expect(w.text()).toContain('Share it.')
  })
})
