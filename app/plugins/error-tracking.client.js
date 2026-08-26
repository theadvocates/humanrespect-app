/**
 * Error tracking.
 *
 * Nothing caught runtime errors before this. If the Turn threw for some
 * browser, the funnel would simply stop and the cause would be invisible.
 *
 * Listeners are installed here rather than relying on PostHog's own exception
 * autocapture, because PostHog is deliberately deferred to requestIdleCallback
 * — its handlers don't exist during initial load, which is when the errors
 * that matter most happen. These listeners are registered immediately and send
 * through the same queue, so an error thrown before the library lands is still
 * reported once it arrives.
 *
 * Runs before the posthog plugin (alphabetical order), so $posthog is resolved
 * lazily at report time rather than captured at registration.
 */

import { createErrorThrottle } from '~/utils/errorThrottle'

export default defineNuxtPlugin((nuxtApp) => {
  const throttle = createErrorThrottle()

  // The whole body is guarded. An error reporter that throws masks the very
  // error it was called about and cascades into further unhandled rejections —
  // which is exactly what happened here: the payload built `window.location`
  // outside the try, and a listener firing during teardown threw
  // ReferenceError: window is not defined.
  function report(kind, error, context = {}) {
    try {
      reportUnsafe(kind, error, context)
    } catch (e) { /* never let reporting become the failure */ }
  }

  function reportUnsafe(kind, error, context = {}) {
    const message = String(error?.message || error || 'Unknown error')
    const signature = `${kind}:${message}`.slice(0, 200)
    if (!throttle.shouldReport(signature)) return

    const payload = {
      error_kind: kind,
      error_message: message.slice(0, 500),
      // Stacks are truncated: the top frames identify the fault, and full
      // traces from minified bundles are mostly noise.
      error_stack: String(error?.stack || '').split('\n').slice(0, 8).join('\n').slice(0, 1500),
      // globalThis rather than window: this can run during teardown, where
      // the window binding may already be gone.
      page: globalThis?.location?.pathname ?? null,
      ...context
    }

    try {
      // Read off the closed-over nuxtApp, never useNuxtApp(): these fire from raw
      // event listeners where no Nuxt context is active, so useNuxtApp() throws
      // and the catch below swallows it — reporting nothing at all. Read at
      // report time, not registration: the posthog plugin runs after this one,
      // so by the time an error fires $posthog and its queue exist.
      nuxtApp.$posthog?.capture('$exception', payload)
    } catch (e) { /* reporting must never throw */ }

    if (import.meta.dev) {
      console.error(`[${kind}]`, error)
      // A readable record of what this actually reported, so you can confirm
      // capture and dedup from the console instead of guessing from native
      // browser logging, which looks identical.
      ;(window.__hrErrors ||= []).push({ kind, message: payload.error_message })
    }
  }

  // Errors inside Vue components — render errors, lifecycle hooks, handlers.
  nuxtApp.hook('vue:error', (error, _instance, info) => {
    report('vue', error, { vue_info: String(info || '') })
  })

  // Failures during Nuxt's own startup or navigation.
  nuxtApp.hook('app:error', (error) => report('nuxt', error))

  // Anything thrown outside Vue's boundary.
  // capture: true is required — resource load errors do not bubble, and a
  // failed /_nuxt/*.js chunk after a deploy is exactly the failure worth
  // knowing about, since it leaves the page interactive but broken.
  window.addEventListener('error', (event) => {
    if (!event.error) {
      const src = event.target?.src || event.target?.href
      if (src) report('resource', new Error(`Failed to load ${src}`))
      return
    }
    report('window', event.error)
  }, true)

  window.addEventListener('unhandledrejection', (event) => {
    report('promise', event.reason)
  })
})
