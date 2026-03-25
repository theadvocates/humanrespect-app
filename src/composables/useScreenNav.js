import { ref, nextTick } from 'vue'

export function useScreenNav(totalScreens) {
  const currentScreen = ref(0)
  const history = ref([0])
  const isTransitioning = ref(false)

  async function advance() {
    if (isTransitioning.value) return
    if (currentScreen.value < totalScreens - 1) {
      isTransitioning.value = true
      currentScreen.value++
      history.value.push(currentScreen.value)
      await nextTick()
      window.scrollTo({ top: 0, behavior: 'smooth' })
      setTimeout(() => { isTransitioning.value = false }, 400)
    }
  }

  async function goBack() {
    if (isTransitioning.value) return
    if (history.value.length > 1) {
      isTransitioning.value = true
      history.value.pop()
      currentScreen.value = history.value[history.value.length - 1]
      await nextTick()
      window.scrollTo({ top: 0, behavior: 'smooth' })
      setTimeout(() => { isTransitioning.value = false }, 400)
    }
  }

  function goTo(index) {
    currentScreen.value = index
    history.value = Array.from({ length: index + 1 }, (_, i) => i)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  return { currentScreen, history, advance, goBack, goTo, isTransitioning }
}
