// Nuxt's ~ alias resolves to the app directory in both the dev server and the
// production bundle. Relative paths only work in the bundle — they resolved to
// /app/utils/... in dev and broke `nuxt dev` entirely.
import { pageMeta, SITE_URL } from '~/utils/seo.js'
import { EXPERIENCES } from '~/utils/experiences.js'
import { VIDEOS } from '~/utils/videos.js'

/**
 * Sitemap generated from the same metadata the pages use, so a new experience
 * cannot be added to app/utils/seo.js and silently left out of the sitemap.
 *
 * robots.txt has always advertised this URL; until now it returned 404, so
 * every crawler that followed it found nothing.
 *
 * The video pages carry the sitemap video extension, which is how a search
 * engine is told that a page's main content is a video, with its poster,
 * file, length and date, without having to render the page to find out.
 */

// Standalone pages. Experience URLs come from the catalogue below, so adding
// one there puts it in the sitemap automatically.
const STATIC_ROUTES = {
  home: '/',
  test: '/test',
  watch: '/watch',
  about: '/about',
  terms: '/terms',
  privacy: '/privacy'
}

// The foundation sequence is the entry point, so it outranks the rest.
const PRIORITY = {
  home: '1.0',
  exp01: '0.9',
  test: '0.9',
  exp02: '0.8',
  exp03: '0.8',
  about: '0.7',
  terms: '0.3',
  privacy: '0.3'
}

function escape(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
}

function pageEntry(path, lastmod, priority) {
  return [
    '  <url>',
    `    <loc>${SITE_URL}${path}</loc>`,
    `    <lastmod>${lastmod}</lastmod>`,
    '    <changefreq>monthly</changefreq>',
    `    <priority>${priority}</priority>`,
    '  </url>'
  ].join('\n')
}

function videoEntry(v) {
  return [
    '  <url>',
    `    <loc>${SITE_URL}/watch/${v.slug}</loc>`,
    `    <lastmod>${v.uploadDate}</lastmod>`,
    '    <changefreq>monthly</changefreq>',
    '    <priority>0.8</priority>',
    '    <video:video>',
    `      <video:thumbnail_loc>${SITE_URL}/videos/${v.file}.jpg</video:thumbnail_loc>`,
    `      <video:title>${escape(v.title)}</video:title>`,
    `      <video:description>${escape(v.description)}</video:description>`,
    `      <video:content_loc>${SITE_URL}/videos/${v.file}.mp4</video:content_loc>`,
    `      <video:duration>${v.seconds}</video:duration>`,
    `      <video:publication_date>${v.uploadDate}</video:publication_date>`,
    '      <video:family_friendly>yes</video:family_friendly>',
    '      <video:live>no</video:live>',
    '    </video:video>',
    '  </url>'
  ].join('\n')
}

export default defineEventHandler((event) => {
  const lastmod = new Date().toISOString().split('T')[0]

  const routes = {
    ...STATIC_ROUTES,
    ...Object.fromEntries(EXPERIENCES.map((e) => [e.id, e.path]))
  }

  const pages = Object.entries(routes)
    .filter(([key]) => pageMeta[key])
    .map(([key, path]) => pageEntry(path, lastmod, PRIORITY[key] || '0.6'))

  const videos = VIDEOS.map(videoEntry)

  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')
  setHeader(event, 'Cache-Control', 'public, max-age=3600')

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:video="http://www.google.com/schemas/sitemap-video/1.1">
${[...pages, ...videos].join('\n')}
</urlset>`
})
