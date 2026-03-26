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

import Opening from '@/components/experiences/pillarC/Opening.vue'
import TheConnection from '@/components/experiences/pillarC/TheConnection.vue'
import TheftAsLifeTheft from '@/components/experiences/pillarC/TheftAsLifeTheft.vue'
import FraudAndTrust from '@/components/experiences/pillarC/FraudAndTrust.vue'
import SecurityAndProsperity from '@/components/experiences/pillarC/SecurityAndProsperity.vue'
import TheQuestion from '@/components/experiences/pillarC/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheConnection, TheftAsLifeTheft, FraudAndTrust, SecurityAndProsperity, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

onUnmounted(() => document.body.classList.remove('dark-mode'))

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
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
