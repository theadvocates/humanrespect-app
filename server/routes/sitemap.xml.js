import { pageMeta, SITE_URL } from '../../app/utils/seo.js'

/**
 * Sitemap generated from the same metadata the pages use, so a new experience
 * cannot be added to app/utils/seo.js and silently left out of the sitemap.
 *
 * robots.txt has always advertised this URL; until now it returned 404, so
 * every crawler that followed it found nothing.
 */

// Route path for each key in pageMeta. Anything not listed is intentionally
// excluded: account pages are noindex, certificates are per-person.
const ROUTES = {
  home: '/',
  exp01: '/experience/the-question',
  exp02: '/experience/the-objection',
  exp03: '/experience/flourishing',
  exp04: '/experience/human-nature',
  exp05: '/experience/human-agency',
  pillarA: '/pillar/your-body-is-not-negotiable',
  pillarB: '/pillar/your-time-is-your-life',
  pillarC: '/pillar/what-you-built',
  pillarD: '/pillar/the-method-is-the-message',
  pillarE: '/pillar/cooperation-is-a-technology',
  practice01: '/practice/political-footprint',
  practice02: '/practice/persuasion-practice',
  practice03: '/practice/the-conversation',
  practice04: '/practice/respect-audit',
  practice05: '/practice/design-a-solution',
  about: '/about',
  privacy: '/privacy'
}

// The foundation sequence is the entry point, so it outranks the rest.
const PRIORITY = {
  home: '1.0',
  exp01: '0.9',
  exp02: '0.8',
  exp03: '0.8',
  about: '0.7',
  privacy: '0.3'
}

export default defineEventHandler((event) => {
  const lastmod = new Date().toISOString().split('T')[0]

  const urls = Object.entries(ROUTES)
    .filter(([key]) => pageMeta[key])
    .map(([key, path]) => {
      const priority = PRIORITY[key] || '0.6'
      return [
        '  <url>',
        `    <loc>${SITE_URL}${path}</loc>`,
        `    <lastmod>${lastmod}</lastmod>`,
        '    <changefreq>monthly</changefreq>',
        `    <priority>${priority}</priority>`,
        '  </url>'
      ].join('\n')
    })
    .join('\n')

  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')
  setHeader(event, 'Cache-Control', 'public, max-age=3600')

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>`
})
