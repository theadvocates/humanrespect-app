import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import { spawn } from 'node:child_process'
import { existsSync } from 'node:fs'
import { EXPERIENCES } from '../app/utils/experiences.js'

/**
 * The one check that could not be faked by reading source files.
 *
 * Every experience is a component that mounts one screen at a time, so its
 * server-rendered output was the Opening and nothing else — roughly 54 words
 * of an 800-word argument, on fifteen pages. Nothing in the app misbehaved.
 * The pages looked complete to every human who opened one, because a human
 * runs the JavaScript. Crawlers do not.
 *
 * So these boot the real Nitro server and read what it sends over the wire.
 * A future change that moves the essay behind a v-if, a click, or an
 * onMounted would pass every other test in this suite and silently return
 * all fifteen pages to blank.
 *
 * Skipped when .output is missing, so `vitest` alone stays fast; CI builds
 * first, and the guard below fails loudly rather than skipping silently
 * there.
 */

const BUILT = existsSync('.output/server/index.mjs')
const PORT = 3123
const ORIGIN = `http://localhost:${PORT}`

let server

async function waitForServer(timeoutMs = 30000) {
  const deadline = Date.now() + timeoutMs
  while (Date.now() < deadline) {
    try {
      const res = await fetch(ORIGIN, { signal: AbortSignal.timeout(1000) })
      if (res.ok) return
    } catch { /* not up yet */ }
    await new Promise((r) => setTimeout(r, 250))
  }
  throw new Error('nitro did not start')
}

/** Strips scripts, styles and tags — what is left is what a crawler reads. */
function visibleText(html) {
  return html
    .replace(/<script[\s\S]*?<\/script>/g, ' ')
    .replace(/<style[\s\S]*?<\/style>/g, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

describe.skipIf(!BUILT)('server-rendered content', () => {
  const pages = new Map()

  beforeAll(async () => {
    server = spawn('node', ['.output/server/index.mjs'], {
      env: { ...process.env, PORT: String(PORT), NITRO_PORT: String(PORT) },
      stdio: 'ignore'
    })
    await waitForServer()
    for (const e of EXPERIENCES) {
      pages.set(e.id, await fetch(`${ORIGIN}${e.path}`).then((r) => r.text()))
    }
  }, 60000)

  afterAll(() => server?.kill())

  it('sends the whole argument, not just the Opening screen', () => {
    for (const e of EXPERIENCES) {
      const words = visibleText(pages.get(e.id)).split(' ').length
      expect(words, `${e.path} sends ${words} words — the Opening alone is ~54`)
        .toBeGreaterThan(500)
    }
  })

  it('gives every page real headings to structure it', () => {
    for (const e of EXPERIENCES) {
      const h1 = (pages.get(e.id).match(/<h1[\s>]/g) || []).length
      const h2 = (pages.get(e.id).match(/<h2[\s>]/g) || []).length
      expect(h1, `${e.path} has ${h1} h1 elements`).toBe(1)
      expect(h2, `${e.path} has no section headings`).toBeGreaterThanOrEqual(3)
    }
  })

  it('sends each page its own essay', async () => {
    // Fifteen pages wired by script is exactly how every one of them ends up
    // pointing at the same content without anyone noticing.
    const essays = Object.fromEntries(
      await Promise.all(EXPERIENCES.map(async (e) =>
        [e.id, (await import(`../app/content/essays/${e.id}.js`)).default]))
    )
    for (const e of EXPERIENCES) {
      const text = visibleText(pages.get(e.id))
      const opener = essays[e.id].sections[0].body[0].slice(0, 60)
      expect(text, `${e.path} is not serving ${e.id}'s essay`).toContain(opener.slice(0, 40))
    }
  })

  it('serves the front door with its question intact', async () => {
    const text = visibleText(await fetch(ORIGIN).then((r) => r.text()))
    expect(text).toContain('Think of someone you know who is wrong')
  })
})

describe.skipIf(BUILT)('server-rendered content (skipped)', () => {
  it('needs a build; CI runs one first', () => {
    // Present so the skip is visible in the report rather than silent.
    expect(process.env.CI, 'CI must build before running the suite').toBeFalsy()
  })
})
