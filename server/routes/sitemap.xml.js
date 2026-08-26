import { pageMeta, SITE_URL } from '../../app/utils/seo.js'
import { EXPERIENCES } from '../../app/utils/experiences.js'

/**
 * Sitemap generated from the same metadata the pages use, so a new experience
 * cannot be added to app/utils/seo.js and silently left out of the sitemap.
 *
 * robots.txt has always advertised this URL; until now it returned 404, so
 * every crawler that followed it found nothing.
 */

// Standalone pages. Experience URLs come from the catalogue below, so adding
// one there puts it in the sitemap automatically.
const STATIC_ROUTES = {
  home: '/',
  about: '/about',
  terms: '/terms',
  privacy: '/privacy'
}

// The foundation sequence is the entry point, so it outranks the rest.
const PRIORITY = {
  home: '1.0',
  exp01: '0.9',
  exp02: '0.8',
  exp03: '0.8',
  about: '0.7',
  terms: '0.3',
  privacy: '0.3'
}

export default defineEventHandler((event) => {
  const lastmod = new Date().toISOString().split('T')[0]

  const routes = {
    ...STATIC_ROUTES,
    ...Object.fromEntries(EXPERIENCES.map((e) => [e.id, e.path]))
  }

  const urls = Object.entries(routes)
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
