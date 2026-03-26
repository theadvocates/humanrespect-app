#!/bin/bash
# Updates analytics composable to sync completions to journey store
# Run from humanrespect-app/ root

cat > src/composables/useAnalytics.js << 'JSEOF'
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
    // markComplete handles both store update AND event firing
    // so we don't double-fire the event
    if (experienceId !== 'exp01' && experienceId !== 'exp02') {
      // exp01 and exp02 have their own completeExp01/completeExp02 methods
      // that already call markComplete internally
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
JSEOF

echo "✅ Analytics composable updated — trackCompletion now syncs to journey store"
