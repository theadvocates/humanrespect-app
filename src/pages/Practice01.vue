<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, provide, watch } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/practice01/Opening.vue'
import TheMapping from '@/components/experiences/practice01/TheMapping.vue'
import YourFootprint from '@/components/experiences/practice01/YourFootprint.vue'
import TheChallenge from '@/components/experiences/practice01/TheChallenge.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 5
const currentScreen = ref(0)
const history = ref([0])
const selectedAreas = ref([])

provide('selectedAreas', selectedAreas)

const screenComponents = [Opening, TheMapping, YourFootprint, TheChallenge, TheReflection]
const screenNames = ['opening', 'mapping', 'footprint', 'challenge', 'reflection']

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('practice01', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('practice01', { areas_checked: selectedAreas.value.length })
})

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}
</script>

<style scoped>
.exp-app { min-height: 100vh; background: var(--paper); transition: background 0.6s ease; }
.exp-app.dark-mode { background: var(--bg-dark); }
.exp-container { max-width: 640px; margin: 0 auto; padding: 4rem 1.5rem; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.35s ease, transform 0.35s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(12px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-container { padding: 3rem 1rem; } }
</style>
