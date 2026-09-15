import { ref, watch } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'
import { useStepHistory } from '@/composables/useStepHistory'

export function useScreenNav(totalScreens, experienceId = null, screenNames = []) {
  const currentScreen = ref(0)
  const steps = useStepHistory(currentScreen, { id: experienceId || 'screens' })
  const { trackScreenView } = useAnalytics()

  // Track screen views when experienceId is provided
  if (experienceId) {
    watch(currentScreen, (idx) => {
      const name = screenNames[idx] || `screen-${idx}`
      trackScreenView(experienceId, name)
    }, { immediate: true }) // the opening screen counts too
  }

  function advance() {
    if (currentScreen.value < totalScreens - 1) {
      currentScreen.value++
      window.scrollTo(0, 0)
    }
  }

  function goBack() {
    steps.back()
  }

  return { currentScreen, advance, goBack }
}
