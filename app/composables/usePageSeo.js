import { pageMeta, SITE_URL, SITE_NAME, DEFAULT_OG_IMAGE } from '@/utils/seo'

/**
 * Applies server-rendered SEO + Open Graph tags for a page.
 * `key` indexes into app/utils/seo.js; pass overrides for dynamic pages.
 */
export function usePageSeo(key, overrides = {}) {
  const route = useRoute()
  const meta = { ...(pageMeta[key] || pageMeta.home), ...overrides }

  const fullTitle = key === 'home' ? meta.title : `${meta.title} — ${SITE_NAME}`
  const url = `${SITE_URL}${route.path}`
  const image = meta.image || DEFAULT_OG_IMAGE

  useSeoMeta({
    title: fullTitle,
    description: meta.description,
    ogType: 'website',
    ogSiteName: SITE_NAME,
    ogLocale: 'en_US',
    ogTitle: meta.title,
    ogDescription: meta.description,
    ogUrl: url,
    ogImage: image,
    ogImageWidth: 1200,
    ogImageHeight: 630,
    ogImageAlt: meta.title,
    twitterCard: 'summary_large_image',
    twitterTitle: meta.title,
    twitterDescription: meta.description,
    twitterImage: image,
    twitterImageAlt: meta.title
  })

  useHead({ link: [{ rel: 'canonical', href: url }] })
}
