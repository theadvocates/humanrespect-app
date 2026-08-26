import { describe, it, expect } from 'vitest'
import { EXPERIENCES } from '../app/utils/experiences.js'
import { pageMeta, SITE_URL } from '../app/utils/seo.js'

/**
 * robots.txt has advertised /sitemap.xml since launch. For months it returned
 * 404, so every crawler that followed it found nothing — a failure with no
 * symptom anywhere in the app.
 *
 * The route builds its URL list from the catalogue plus a handful of static
 * pages. These assert the properties that matter without booting Nitro, so a
 * page added to the catalogue and forgotten in the sitemap fails here.
 */

const STATIC_PAGES = ['home', 'about', 'terms', 'privacy']

describe('sitemap contents', () => {
  it('has SEO metadata for every static page it lists', () => {
    for (const key of STATIC_PAGES) {
      expect(pageMeta[key], `${key} missing from seo.js`).toBeDefined()
      expect(pageMeta[key].title).toBeTruthy()
      expect(pageMeta[key].description).toBeTruthy()
    }
  })

  it('can build an absolute URL for every experience', () => {
    for (const e of EXPERIENCES) {
      const url = `${SITE_URL}${e.path}`
      expect(() => new URL(url), `${e.id} produces an invalid URL`).not.toThrow()
      expect(url.startsWith('https://'), `${e.id} is not https`).toBe(true)
    }
  })

  it('lists nineteen URLs — fifteen experiences plus four pages', () => {
    expect(EXPERIENCES.length + STATIC_PAGES.length).toBe(19)
  })

  it('excludes pages that must never be indexed', () => {
    const paths = EXPERIENCES.map((e) => e.path)
    // Account pages are noindex and certificates are per-person; neither
    // belongs in a sitemap.
    for (const p of paths) {
      expect(p.startsWith('/account'), `${p} must not be listed`).toBe(false)
      expect(p.startsWith('/certificate'), `${p} must not be listed`).toBe(false)
    }
  })

  it('never emits a duplicate URL', () => {
    const all = [...EXPERIENCES.map((e) => e.path), '/', '/about', '/terms', '/privacy']
    expect(new Set(all).size).toBe(all.length)
  })
})

describe('SEO metadata', () => {
  it('gives every page a description short enough to survive a search result', () => {
    for (const [key, meta] of Object.entries(pageMeta)) {
      expect(meta.description.length, `${key} description is very long`).toBeLessThan(320)
      expect(meta.description.length, `${key} description is too short to be useful`).toBeGreaterThan(40)
    }
  })

  it('does not repeat the site name inside a page title', () => {
    // usePageSeo appends " — Human Respect"; a title that already contains it
    // renders as "Certificate — Human Respect — Human Respect", which shipped
    // once already.
    for (const [key, meta] of Object.entries(pageMeta)) {
      if (key === 'home') continue
      expect(meta.title, `${key} title double-appends the site name`).not.toMatch(/Human Respect/)
    }
  })
})
