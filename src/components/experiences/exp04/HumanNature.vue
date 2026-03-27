<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start with what you already know</p>
    <h2 class="display-medium">What have you observed about how people actually behave?</h2>
    <Divider />

    <p class="body-text">No idealism here. Based on your own experience of human beings, which of these do you recognize as generally true?</p>

    <div class="traits">
      <button
        v-for="trait in traits"
        :key="trait.id"
        class="trait-card"
        :class="{ selected: selectedTraits.includes(trait.id) }"
        @click="toggle(trait.id)"
      >
        <span class="trait-check">{{ selectedTraits.includes(trait.id) ? '✓' : '' }}</span>
        <div class="trait-content">
          <span class="trait-label">{{ trait.label }}</span>
        </div>
      </button>
    </div>

    <p v-if="selectedTraits.length >= 3" class="body-text" style="margin-top: 1.5rem;">You selected {{ selectedTraits.length }} traits. Hold onto this list. We're going to apply it somewhere specific.</p>

    <NavBar :can-go-back="true" :disable-continue="selectedTraits.length < 2" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selectedTraits = inject('selectedTraits')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const traits = [
  { id: 'self-interest', label: 'People tend to act in their own interest, especially when the costs fall on someone else' },
  { id: 'game-systems', label: 'When given a system with rules, people find ways to game it' },
  { id: 'power-abuse', label: 'People who gain power tend to use it to benefit themselves and their allies' },
  { id: 'short-term', label: 'People prioritize short-term rewards over long-term consequences' },
  { id: 'in-group', label: 'People favor their own group and are suspicious of outsiders' },
  { id: 'accountability', label: 'People behave worse when they believe no one is watching or when accountability is diffuse' },
  { id: 'rationalize', label: 'People can rationalize almost anything if it benefits them' },
  { id: 'good-intentions', label: 'Good intentions frequently produce bad outcomes when the incentives are wrong' },
]

function toggle(id) {
  const idx = selectedTraits.value.indexOf(id)
  if (idx === -1) selectedTraits.value.push(id)
  else selectedTraits.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('exp04', 'human-nature-traits', selectedTraits.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.traits { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.trait-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.trait-card:hover { border-color: var(--ochre); }
.trait-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.trait-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.trait-card.selected .trait-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.trait-content { flex: 1; }
.trait-label { display: block; font-size: 0.88rem; }
</style>
