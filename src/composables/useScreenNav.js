import { ref, watch } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

export function useScreenNav(totalScreens, experienceId = null, screenNames = []) {
  const currentScreen = ref(0)
  const history = ref([0])
  const { trackScreenView } = useAnalytics()

  // Track screen views when experienceId is provided
  if (experienceId) {
    watch(currentScreen, (idx) => {
      const name = screenNames[idx] || `screen-${idx}`
      trackScreenView(experienceId, name)
    })
  }

  function advance() {
    if (currentScreen.value < totalScreens - 1) {
      currentScreen.value++
      history.value.push(currentScreen.value)
      window.scrollTo(0, 0)
    }
  }

  function goBack() {
    if (history.value.length > 1) {
      history.value.pop()
      currentScreen.value = history.value[history.value.length - 1]
      window.scrollTo(0, 0)
    }
  }

  return { currentScreen, advance, goBack }
}
