import { useJourneyStore } from '@/stores/journey'

/**
 * Restores journey progress from localStorage once, on the client only.
 * Runs after hydration so server-rendered markup and client markup match.
 */
export default defineNuxtPlugin(() => {
  const journey = useJourneyStore()
  journey.hydrate()
  journey.recordVisit()
})
