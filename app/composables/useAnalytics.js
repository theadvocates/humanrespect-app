import { useJourneyStore } from '@/stores/journey'

/**
 * Analytics, written to two places on purpose.
 *
 * Supabase is the durable record — it survives ad blockers, it's queryable with
 * SQL, and it's where the journey rows already live. PostHog is the analysis
 * surface: funnels, retention, and drop-off without hand-writing queries.
 *
 * Previously only Supabase received these, which meant every screen view and
 * choice in the app was invisible to PostHog and no funnel could be built.
 *
 * Event names match what the original app already wrote (`screen_view`,
 * `choice_made`, `experience_completed`) so the 235 historical events stay
 * comparable. PostHog funnels are keyed on event name, so renaming later would
 * orphan the history for no real gain. New signals get new names.
 */

// Module scope: screen timing must survive component unmounts, since the
// interesting number is how long someone sat on the screen they abandoned.
let screenEnteredAt = null
let currentScreen = null
let sessionStartedAt = null

export function useAnalytics() {
  const journey = useJourneyStore()

  function posthog() {
    if (import.meta.server) return null
    return useNuxtApp().$posthog || null
  }

  function secondsSince(t) {
    return t ? Math.round((Date.now() - t) / 1000) : null
  }

  /** Sends one event to both sinks. Never throws into caller code. */
  function capture(name, props = {}) {
    if (import.meta.server) return

    if (!sessionStartedAt) sessionStartedAt = Date.now()
    const enriched = {
      ...props,
      seconds_in_session: secondsSince(sessionStartedAt),
      visitor_id: journey.visitorId || null
    }

    try {
      posthog()?.capture(name, enriched)
    } catch (e) { /* analytics must never break the page */ }

    try {
      journey.trackEvent(name, enriched)
    } catch (e) { /* ditto */ }
  }

  /**
   * Records a screen view, and closes out the previous screen with how long
   * the person actually spent on it — the number that identifies where an
   * experience loses people.
   */
  function trackScreenView(experienceId, screenId, extra = {}) {
    if (import.meta.server) return

    if (currentScreen && currentScreen.screen !== screenId) {
      capture('screen_left', {
        experience: currentScreen.experience,
        screen: currentScreen.screen,
        seconds_on_screen: secondsSince(screenEnteredAt),
        advanced_to: screenId
      })
    }

    currentScreen = { experience: experienceId, screen: screenId }
    screenEnteredAt = Date.now()

    capture('screen_view', {
      experience: experienceId,
      screen: screenId,
      ...extra
    })
  }

  function trackChoice(experienceId, questionId, answer) {
    capture('choice_made', {
      experience: experienceId,
      question: questionId,
      answer,
      screen: currentScreen?.screen || null,
      seconds_on_screen: secondsSince(screenEnteredAt)
    })
  }

  function trackCompletion(experienceId, data = {}) {
    capture('experience_completed', {
      experience: experienceId,
      seconds_on_screen: secondsSince(screenEnteredAt)
    })

    // Journey state still needs updating — these are the store's own shapes.
    if (experienceId === 'exp01') journey.completeExp01(data)
    else if (experienceId === 'exp02') journey.completeExp02(data.objection, data.verdict)
    else journey.markComplete(experienceId)
  }

  function trackShare(method, experienceId) {
    capture('share', { method, experience: experienceId })
  }

  function trackNewsletterSignup(source) {
    capture('newsletter_signup', { source })
  }

  /**
   * Fires when someone leaves without finishing. Uses visibilitychange rather
   * than beforeunload, which mobile browsers routinely skip.
   */
  function trackAbandonOnExit() {
    if (import.meta.server) return
    const onHide = () => {
      if (document.visibilityState !== 'hidden' || !currentScreen) return
      capture('session_left', {
        experience: currentScreen.experience,
        screen: currentScreen.screen,
        seconds_on_screen: secondsSince(screenEnteredAt)
      })
    }
    document.addEventListener('visibilitychange', onHide)
    onScopeDispose(() => document.removeEventListener('visibilitychange', onHide))
  }

  return {
    capture,
    trackScreenView,
    trackChoice,
    trackCompletion,
    trackShare,
    trackNewsletterSignup,
    trackAbandonOnExit
  }
}
