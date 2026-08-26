<template>
  <div>
    <div class="exp-app" :class="{ 'dark-mode': isDark }">
      <div class="exp-container">
        <Transition name="screen-fade" mode="out-in">
          <component
            :is="currentComponent"
            :key="screenKey"
            @advance="advance"
            @back="goBack"
            @choose-objection="handleObjectionChoice"
            @restart-with="restartWith"
          />
        </Transition>
      </div>
    </div>

    <ExperienceEssay
      id="exp02"
      :essay="essay"
      :title="meta.title"
      :path="meta.path"
      :show-cue="currentScreen === 0"
    />
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import ExperienceEssay from '@/components/shared/ExperienceEssay.vue'
import essay from '@/content/essays/exp02.js'
import { EXPERIENCES } from '@/utils/experiences.js'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import YourVerdict from '@/components/experiences/exp02/YourVerdict.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

definePageMeta({ name: 'exp02' })
usePageSeo('exp02')

const meta = EXPERIENCES.find((e) => e.id === 'exp02')

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 8
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response,
  Concession, TheQuestion, YourVerdict, WhereNext
]

const screenNames = [
  'opening', 'choose-objection', 'steelman', 'response',
  'concession', 'the-question', 'your-verdict', 'where-next'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02?.chosenObjection || 'none'}`)

useHead({ bodyAttrs: { class: computed(() => (isDark.value ? 'dark-mode' : '')) } })

watch(currentScreen, (idx) => {
  trackScreenView('exp02', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) {
    trackCompletion('exp02')
    if (!journey.exp02) journey.exp02 = {}
    journey.exp02.completed = true
    journey.exp02.completedAt = new Date().toISOString()
    journey.persist()
  }
})

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

function handleObjectionChoice(key) {
  if (!journey.exp02) journey.exp02 = {}
  journey.exp02.chosenObjection = key
  trackChoice('exp02', 'objection', key)
  journey.persist()
}

function restartWith(key) {
  handleObjectionChoice(key)
  currentScreen.value = 2
  history.value = [0, 1, 2]
  window.scrollTo(0, 0)
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
