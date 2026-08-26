import { describe, it, expect } from 'vitest'
import { readFileSync } from 'node:fs'
import { EXPERIENCES } from '../app/utils/experiences.js'
import { readingMinutes, essayWords } from '../app/utils/reading.js'

/**
 * Every experience mounts one screen at a time, so its server-rendered output
 * is the Opening and nothing else — about 54 words of an 800-word argument.
 * Fifteen pages of real content were, to a crawler, blank. The essays are what
 * those pages actually say, rendered on the server, on the same URL.
 *
 * Two things have to hold or that fix is cosmetic: every experience needs one
 * (a missing essay is a page that silently goes back to 54 words), and the
 * page has to actually render it — which is asserted against the built server
 * output in ssr.test.js, not here.
 */

const essays = Object.fromEntries(
  await Promise.all(
    EXPERIENCES.map(async (e) => [e.id, (await import(`../app/content/essays/${e.id}.js`)).default])
  )
)



describe('the written arguments', () => {
  it('exists for every experience in the catalogue', () => {
    for (const e of EXPERIENCES) {
      expect(essays[e.id], `${e.id} (${e.path}) has no essay`).toBeDefined()
    }
  })

  it('is long enough to be worth indexing', () => {
    // The Opening alone is ~54 words. Anything under a few hundred leaves the
    // page thin, which is the problem these were written to solve.
    for (const [id, essay] of Object.entries(essays)) {
      expect(essayWords(essay), `${id} is too short to carry the argument`).toBeGreaterThan(450)
    }
  })

  it('derives its reading time rather than storing one', () => {
    // Every essay once carried a hand-written `minutes`, and all fifteen
    // overstated — the number was set while drafting and never rechecked.
    for (const [id, essay] of Object.entries(essays)) {
      expect(essay.minutes, `${id} has a hand-written minutes again`).toBeUndefined()
      const derived = readingMinutes(essay)
      expect(derived, `${id} rounds to an implausible ${derived} min`).toBeGreaterThanOrEqual(2)
      expect(derived, `${id} is longer than anyone will read here`).toBeLessThanOrEqual(8)
    }
  })

  it('has a standfirst and real headings throughout', () => {
    for (const [id, essay] of Object.entries(essays)) {
      expect(essay.standfirst?.length, `${id} has no standfirst`).toBeGreaterThan(40)
      expect(essay.sections.length, `${id} has too few sections to scan`).toBeGreaterThanOrEqual(3)
      for (const s of essay.sections) {
        expect(s.heading?.trim(), `${id} has an empty heading`).toBeTruthy()
        expect(s.body.length, `${id} § "${s.heading}" is empty`).toBeGreaterThan(0)
        for (const p of s.body) expect(typeof p, `${id} § "${s.heading}"`).toBe('string')
      }
    }
  })

  it('never repeats a heading inside one essay', () => {
    for (const [id, essay] of Object.entries(essays)) {
      const headings = essay.sections.map((s) => s.heading)
      expect(new Set(headings).size, `${id} repeats a heading`).toBe(headings.length)
    }
  })

  it('closes every pull-quote it opens', () => {
    // A stray ** renders as literal asterisks in the middle of a paragraph.
    for (const [id, essay] of Object.entries(essays)) {
      for (const p of essay.sections.flatMap((s) => s.body)) {
        const marks = (p.match(/\*\*/g) || []).length
        if (marks === 0) continue
        expect(marks, `${id}: unbalanced ** in "${p.slice(0, 50)}…"`).toBe(2)
        expect(p.startsWith('**') && p.endsWith('**'),
          `${id}: ** mid-paragraph is not rendered as emphasis`).toBe(true)
      }
    }
  })

  it('uses the pull-quote sparingly, for the claim itself', () => {
    for (const [id, essay] of Object.entries(essays)) {
      const quotes = essay.sections.flatMap((s) => s.body).filter((p) => p.startsWith('**'))
      expect(quotes.length, `${id} has ${quotes.length} pull-quotes; they stop meaning anything`)
        .toBeLessThanOrEqual(2)
    }
  })

  it('does not open by telling the reader what they already think', () => {
    // These are read by people who disagree, arriving from a link someone
    // sent them. An essay that opens by assuming agreement loses them.
    for (const [id, essay] of Object.entries(essays)) {
      expect(essay.standfirst.toLowerCase(), `${id} standfirst asserts agreement`)
        .not.toMatch(/you already agree|as you know|obviously|of course/)
    }
  })
})

describe('essay wiring', () => {
  const pages = EXPERIENCES.map((e) => ({
    id: e.id,
    src: readFileSync(pagePath(e.path), 'utf8')
  }))

  function pagePath(routePath) {
    return `app/pages${routePath}.vue`
  }

  it('renders the essay on every experience page', () => {
    for (const p of pages) {
      expect(p.src, `${p.id} does not render its essay — that page is still 54 words`)
        .toContain('<ExperienceEssay')
      expect(p.src, `${p.id} imports no essay`).toContain(`@/content/essays/${p.id}.js`)
    }
  })

  it('passes each page its own essay, not another one', () => {
    // The catalogue had already drifted once this way: your-journey showed
    // exp02's description under exp03. Wiring fifteen pages by script is
    // exactly how that happens again.
    for (const p of pages) {
      expect(p.src, `${p.id} is wired to the wrong essay`).toContain(`id="${p.id}"`)
      const imported = p.src.match(/@\/content\/essays\/(\w+)\.js/)[1]
      expect(imported, `${p.id} imports ${imported}'s essay`).toBe(p.id)
    }
  })

  it('only offers the read while the Opening is showing', () => {
    for (const p of pages) {
      expect(p.src, `${p.id} shows the cue mid-experience`).toContain(':show-cue="currentScreen === 0"')
    }
  })
})
