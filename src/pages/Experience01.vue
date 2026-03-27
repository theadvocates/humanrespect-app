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
import { ref, computed, provide, watch, onUnmounted } from 'vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp01/Opening.vue'
import TheDisagreement from '@/components/experiences/exp01/TheDisagreement.vue'
import HowYouHandledIt from '@/components/experiences/exp01/HowYouHandledIt.vue'
import WouldYouForceIt from '@/components/experiences/exp01/WouldYouForceIt.vue'
import WhatYouAlreadyKnow from '@/components/experiences/exp01/WhatYouAlreadyKnow.vue'
import ThePivot from '@/components/experiences/exp01/ThePivot.vue'
import ThePrinciple from '@/components/experiences/exp01/ThePrinciple.vue'
import Invitation from '@/components/experiences/exp01/Invitation.vue'

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 8
const currentScreen = ref(0)
const history = ref([0])
const selectedMethods = ref([])
const wouldForce = ref(null)
const whyNot = ref([])

provide('selectedMethods', selectedMethods)
provide('wouldForce', wouldForce)
provide('whyNot', whyNot)

const screenComponents = [
  Opening, TheDisagreement, HowYouHandledIt, WouldYouForceIt,
  WhatYouAlreadyKnow, ThePivot, ThePrinciple, Invitation
]

const screenNames = [
  'opening', 'the-disagreement', 'how-you-handled-it', 'would-you-force-it',
  'what-you-already-know', 'the-pivot', 'the-principle', 'invitation'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp01', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) {
    trackCompletion('exp01', {
      methods: selectedMethods.value,
      would_force: wouldForce.value,
      why_not: whyNot.value
    })
    journey.exp01.completed = true
    journey.exp01.completedAt = new Date().toISOString()
    journey.persist()
  }
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
