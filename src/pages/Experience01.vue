<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
          @choose="handleChoice"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onUnmounted } from 'vue'
import { useScreenNav } from '@/composables/useScreenNav'
import { useJourneyStore } from '@/stores/journey'

import Opening from '@/components/experiences/exp01/Opening.vue'
import CommonGround from '@/components/experiences/exp01/CommonGround.vue'
import Scenario from '@/components/experiences/exp01/Scenario.vue'
import PersonalChoice from '@/components/experiences/exp01/PersonalChoice.vue'
import PoliticalChoice from '@/components/experiences/exp01/PoliticalChoice.vue'
import Mirror from '@/components/experiences/exp01/Mirror.vue'
import WhyTheGap from '@/components/experiences/exp01/WhyTheGap.vue'
import ThePrinciple from '@/components/experiences/exp01/ThePrinciple.vue'
import Invitation from '@/components/experiences/exp01/Invitation.vue'

const TOTAL_SCREENS = 9
const { currentScreen, advance, goBack } = useScreenNav(TOTAL_SCREENS)
const journey = useJourneyStore()

const screenComponents = [
  Opening, CommonGround, Scenario, PersonalChoice, PoliticalChoice,
  Mirror, WhyTheGap, ThePrinciple, Invitation
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

// Sync dark mode to body
watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

// CRITICAL: Clean up dark mode when leaving this page
onUnmounted(() => {
  document.body.classList.remove('dark-mode')
})

function handleChoice({ key, value }) {
  if (key === 'personal') journey.exp01.personal = value
  if (key === 'political') journey.exp01.political = value
  journey.persist()
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

.exp-app.dark-mode {
  background: var(--bg-dark);
  color: var(--text-inverse);
}

.exp-container {
  max-width: 640px;
  width: 100%;
}

.screen-fade-enter-active,
.screen-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}

.screen-fade-enter-from {
  opacity: 0;
  transform: translateY(16px);
}

.screen-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

@media (max-width: 480px) {
  .exp-app {
    padding: 1.5rem 1rem;
  }
}
</style>
