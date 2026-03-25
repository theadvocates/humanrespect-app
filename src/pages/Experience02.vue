<template>
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
          @share="handleShare"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useJourneyStore } from '@/stores/journey'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()

const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response, Concession, TheQuestion, WhereNext
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02.chosenObjection}`)

watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

function advance() {
  if (currentScreen.value < screenComponents.length - 1) {
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

function handleObjectionChoice(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
}

function restartWith(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
  currentScreen.value = 2 // jump to Steelman
  history.value = [0, 1, 2]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function handleShare() {
  const text = "I picked my strongest objection to a philosophical idea — and it got a more honest answer than I expected."
  const url = window.location.origin + '/experience/the-objection'

  if (navigator.share) {
    navigator.share({ title: 'The Objection You\'re Already Thinking', text, url })
  } else {
    navigator.clipboard.writeText(text + ' ' + url)
  }
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
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
</style>
