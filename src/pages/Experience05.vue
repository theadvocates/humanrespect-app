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
import { ref, computed, watch, onUnmounted } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp05/Opening.vue'
import TheHire from '@/components/experiences/exp05/TheHire.vue'
import TheVote from '@/components/experiences/exp05/TheVote.vue'
import TraceTheChain from '@/components/experiences/exp05/TraceTheChain.vue'
import TheDefenses from '@/components/experiences/exp05/TheDefenses.vue'
import TranslateThePolicy from '@/components/experiences/exp05/TranslateThePolicy.vue'
import TheQuestion from '@/components/experiences/exp05/TheQuestion.vue'

const { trackScreenView, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 7
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheHire, TheVote, TraceTheChain,
  TheDefenses, TranslateThePolicy, TheQuestion
]

const screenNames = [
  'opening', 'the-hire', 'the-vote', 'trace-the-chain',
  'the-defenses', 'translate-the-policy', 'the-question'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp05', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('exp05')
})

onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) {
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
</script>

<style scoped>
.exp-app { min-height: 100vh; background: var(--paper); transition: background 0.6s ease; }
.exp-app.dark-mode { background: var(--bg-dark); }
.exp-container { max-width: 640px; margin: 0 auto; padding: 4rem 1.5rem; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.35s ease, transform 0.35s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(12px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-container { padding: 2.5rem 1rem; } }
</style>
