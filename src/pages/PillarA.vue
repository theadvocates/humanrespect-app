<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="screenKey" @advance="advance" @back="goBack"  />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarA/Opening.vue'
import TheMemory from '@/components/experiences/pillarA/TheMemory.vue'
import TheCascade from '@/components/experiences/pillarA/TheCascade.vue'
import TrustInfrastructure from '@/components/experiences/pillarA/TrustInfrastructure.vue'
import ConsentBoundary from '@/components/experiences/pillarA/ConsentBoundary.vue'
import TheQuestion from '@/components/experiences/pillarA/TheQuestion.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = ['opening','the-memory','the-cascade','trust-infrastructure','consent-boundary','the-question']

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])


const screenComponents = [Opening, TheMemory, TheCascade, TrustInfrastructure, ConsentBoundary, TheQuestion]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}`)

watch(currentScreen, (idx) => {
  trackScreenView('pillarA', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarA')
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}

</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
