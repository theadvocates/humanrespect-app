import { describe, it, expect } from 'vitest'
import { readFileSync } from 'node:fs'
import { token, ratio } from './contrast.helper.js'

/**
 * The palette shipped with body copy at 2.43:1 and its accent colour at
 * 3.48:1 — both below the 4.5:1 AA threshold, on a site whose entire premise
 * is that a stranger will read a paragraph carefully.
 *
 * Contrast is invisible to every other check: it lints clean, builds clean,
 * and looks fine to whoever picked the colour. These read the tokens straight
 * out of the stylesheet so a future palette tweak cannot quietly undo it.
 *
 * The trap the first fix walked into is covered by the dark-surface cases:
 * darkening the ochre far enough for --paper drops it to 3.31:1 on --bg-dark,
 * where fifteen experience Openings live.
 */

const AA = 4.5

describe('palette contrast', () => {
  const paper = token('--paper')
  const cream = token('--cream')
  const dark = token('--bg-dark')

  it('meets AA for the faintest text colour on both light grounds', () => {
    const faint = token('--ink-faint')
    expect(ratio(faint, paper), `--ink-faint on --paper`).toBeGreaterThanOrEqual(AA)
    expect(ratio(faint, cream), `--ink-faint on --cream`).toBeGreaterThanOrEqual(AA)
  })

  it('meets AA for every ink on paper', () => {
    for (const name of ['--ink', '--ink-soft', '--ink-muted', '--ink-faint']) {
      expect(ratio(token(name), paper), `${name} on --paper`).toBeGreaterThanOrEqual(AA)
    }
  })

  it('meets AA for the light-surface ochre, as text and behind white', () => {
    const ochre = token('--ochre')
    expect(ratio(ochre, paper), '--ochre as text on --paper').toBeGreaterThanOrEqual(AA)
    expect(ratio('#FFFFFF', ochre), 'white button text on --ochre').toBeGreaterThanOrEqual(AA)
    expect(ratio('#FFFFFF', token('--ochre-deep')), 'white text on the hover state').toBeGreaterThanOrEqual(AA)
  })

  it('keeps the dark-surface ochre readable on --bg-dark', () => {
    // Every experience Opening puts --ochre-light on --bg-dark. Darkening it
    // to satisfy the light pages would break all fifteen.
    expect(ratio(token('--ochre-light'), dark)).toBeGreaterThanOrEqual(AA)
  })

  it('remaps the light-surface colours for dark mode', () => {
    // Without the .dark-mode block these resolve to their light values, which
    // land at ~3.3:1 on --bg-dark.
    expect(ratio(token('--ink-faint', '.dark-mode'), dark), '--ink-faint in dark mode').toBeGreaterThanOrEqual(AA)
    expect(ratio(token('--ochre', '.dark-mode'), dark), '--ochre in dark mode').toBeGreaterThanOrEqual(AA)
  })

  it('meets AA for inverse text on the dark ground', () => {
    expect(ratio(token('--text-inverse'), dark)).toBeGreaterThanOrEqual(AA)
  })
})

describe('reduced motion', () => {
  const mobile = readFileSync('app/styles/mobile.css', 'utf8')

  it('is declared once, in the last stylesheet loaded', () => {
    // It used to be duplicated in base.css and typography.css, where it lost
    // to the !important stagger delays declared later in mobile.css.
    const others = ['base.css', 'typography.css']
      .filter((f) => readFileSync(`app/styles/${f}`, 'utf8').includes('prefers-reduced-motion'))
    expect(others, 'a stale reduced-motion block is still in place').toEqual([])
    expect(mobile).toContain('prefers-reduced-motion: reduce')
  })

  it('zeroes delays, not just durations', () => {
    // Zeroing duration alone leaves a reveal at opacity: 0 for up to 0.95s.
    const block = mobile.slice(mobile.lastIndexOf('@media (prefers-reduced-motion: reduce)'))
    expect(block).toMatch(/transition-delay:\s*0s\s*!important/)
    expect(block).toMatch(/animation-delay:\s*0s\s*!important/)
    expect(block).toMatch(/scroll-behavior:\s*auto\s*!important/)
  })

  it('overrides the staggers at their own specificity', () => {
    const block = mobile.slice(mobile.lastIndexOf('@media (prefers-reduced-motion: reduce)'))
    expect(block, 'a bare * selector loses to .stagger.animate > *:nth-child()')
      .toContain('.stagger.animate > *:nth-child(n)')
  })

  it('does not leave observer-driven reveals invisible', () => {
    const block = mobile.slice(mobile.lastIndexOf('@media (prefers-reduced-motion: reduce)'))
    expect(block).toMatch(/opacity:\s*1\s*!important/)
  })
})
