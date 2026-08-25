import { useRouter } from 'vue-router'
import { useJourneyStore } from '@/stores/journey'

export function useSmartBack() {
  const router = useRouter()
  const journey = useJourneyStore()

  function goBack() {
    // If there's browser history, use it
    if (window.history.length > 1) {
      router.back()
    } else {
      // No history — smart fallback
      const hasProgress = journey.exp01?.completed || journey.exp02?.completed ||
        (journey.completions && Object.keys(journey.completions).length > 0)

      if (hasProgress) {
        router.push('/your-journey')
      } else {
        router.push('/')
      }
    }
  }

  return { goBack }
}
