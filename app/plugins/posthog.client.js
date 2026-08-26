import { useJourneyStore } from '@/stores/journey'

/**
 * Product analytics, configured to keep the promises the privacy page makes.
 *
 * The site's whole argument is about consent and not coercing people, so the
 * analytics have to match the rhetoric. Concretely that means:
 *
 *   - no cookies: persistence is localStorage, first-party and same-origin,
 *     so nothing follows anyone between sites
 *   - no session recording and no heatmaps
 *   - inputs masked, so nothing anyone types is ever transmitted
 *   - identity is the existing anonymous visitorId, not a new tracking id,
 *     which also lines PostHog up with the journey data already in Supabase
 *
 * No-ops when unconfigured, so local development and previews stay silent.
 *
 * posthog-js is ~200 KB and was statically imported, which put it in the
 * initial bundle ahead of the first paint. Nothing is measurable before the
 * page renders, so it is imported dynamically and initialised once the browser
 * is idle — analytics should never compete with content for the main thread.
 */
export default defineNuxtPlugin((nuxtApp) => {
  const { posthogKey, posthogHost } = useRuntimeConfig().public
  if (!posthogKey) return

  const journey = useJourneyStore()
  let ph = null

  // Events fired before the library lands are queued rather than dropped.
  const queue = []
  const proxy = {
    capture: (...args) => (ph ? ph.capture(...args) : queue.push(args)),
    identify: (...args) => ph?.identify(...args)
  }

  const boot = () => import('posthog-js').then(({ default: posthog }) => {
    posthog.init(posthogKey, {
      api_host: posthogHost || 'https://us.i.posthog.com',

      // First-party storage only. Not a cookie, never sent cross-site.
      persistence: 'localStorage',
      disable_session_recording: true,
      disable_surveys: true,
      enable_heatmaps: false,

      // Autocapture is on for clicks and navigation, but never records what
      // people type — the experiences ask personal questions.
      autocapture: { dom_event_allowlist: ['click'] },
      mask_all_text: false,
      mask_all_element_attributes: false,

      // Pageviews are sent manually below; the SPA router does not reload.
      capture_pageview: false,
      capture_pageleave: true,

      // Honour Do Not Track rather than overriding it.
      respect_dnt: true,

      loaded: (instance) => {
        // Reuse the anonymous journey id so PostHog and Supabase describe the
        // same person, without minting a second identifier for them.
        if (journey.visitorId) instance.identify(journey.visitorId)
        if (import.meta.dev) instance.debug()
      }
    })
    ph = posthog
    queue.splice(0).forEach((args) => posthog.capture(...args))
    return posthog
  })

  // requestIdleCallback isn't in Safari; the timeout is the fallback.
  if ('requestIdleCallback' in window) requestIdleCallback(boot, { timeout: 3000 })
  else setTimeout(boot, 1500)

  // Nuxt's router does not trigger page loads, so pageviews are explicit.
  const router = useRouter()
  router.afterEach((to) => {
    nuxtApp.runWithContext(() => {
      proxy.capture('$pageview', {
        $current_url: window.location.origin + to.fullPath,
        route_name: to.name
      })
    })
  })

  return { provide: { posthog: proxy } }
})
