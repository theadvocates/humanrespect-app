<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @set-issue="handleIssue"
          @restart-with="restartWith"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'

import Opening from '@/components/experiences/pillarE/Opening.vue'
import TheEvidence from '@/components/experiences/pillarE/TheEvidence.vue'
import WhyItWorks from '@/components/experiences/pillarE/WhyItWorks.vue'
import DesignYourOwn from '@/components/experiences/pillarE/DesignYourOwn.vue'
import VoluntaryAlternatives from '@/components/experiences/pillarE/VoluntaryAlternatives.vue'
import TheQuestion from '@/components/experiences/pillarE/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const chosenIssue = ref(null)

provide('chosenIssue', chosenIssue)

const screenComponents = [
  Opening, TheEvidence, WhyItWorks, DesignYourOwn, VoluntaryAlternatives, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${chosenIssue.value}`)

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

function handleIssue(id) { chosenIssue.value = id }

function restartWith(id) {
  chosenIssue.value = id
  currentScreen.value = 3 // jump to DesignYourOwn
  history.value = [0, 1, 2, 3]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<style scoped>
.exp-app {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1.5rem;
  transition: background 0.6s ease, color 0.6s ease;
  background: var(--paper);
}
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
