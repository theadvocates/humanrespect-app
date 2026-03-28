import { useJourneyStore } from '@/stores/journey'

export function useAnalytics() {
  const journey = useJourneyStore()

  function trackScreenView(experienceId, screenId) {
    journey.trackEvent('screen_view', {
      experience: experienceId,
      screen: screenId,
      timestamp: new Date().toISOString()
    })
  }

  function trackChoice(experienceId, questionId, answer) {
    journey.trackEvent('choice_made', {
      experience: experienceId,
      question: questionId,
      answer,
      timestamp: new Date().toISOString()
    })
  }

  function trackCompletion(experienceId, data = {}) {
    if (experienceId === 'exp01') {
      journey.completeExp01(data)
    } else if (experienceId === 'exp02') {
      journey.completeExp02(data.objection, data.verdict)
    } else {
      journey.markComplete(experienceId)
    }
  }

  function trackShare(method, experienceId) {
    journey.trackEvent('share', {
      method,
      experience: experienceId,
      timestamp: new Date().toISOString()
    })
  }

  function trackNewsletterSignup(source) {
    journey.trackEvent('newsletter_signup', {
      source,
      timestamp: new Date().toISOString()
    })
  }

  return {
    trackScreenView,
    trackChoice,
    trackCompletion,
    trackShare,
    trackNewsletterSignup
  }
}
