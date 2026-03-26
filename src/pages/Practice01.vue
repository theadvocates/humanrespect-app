<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="currentScreen" @advance="advance" @back="goBack" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onUnmounted } from 'vue'
import { useScreenNav } from '@/composables/useScreenNav'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/practice01/Opening.vue'
import TheMapping from '@/components/experiences/practice01/TheMapping.vue'
import TheTotal from '@/components/experiences/practice01/TheTotal.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'

const screenNames = ['opening','the-mapping','the-total','the-reflection']
const { currentScreen, advance, goBack } = useScreenNav(4, 'practice01', screenNames)
const { trackCompletion } = useAnalytics()

const screenComponents = [Opening, TheMapping, TheTotal, TheReflection]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(currentScreen, (idx) => {
  if (idx === 3) trackCompletion('practice01')
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))
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
