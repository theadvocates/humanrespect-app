<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your instinct</p>
    <h2 class="display-medium">How did you handle it?</h2>
    <Divider />

    <p class="body-text">Think about the disagreement you just recalled. What did you actually do? Select everything that applies.</p>

    <div class="methods">
      <button
        v-for="m in methods"
        :key="m.id"
        class="method-card"
        :class="{ selected: selectedMethods.includes(m.id) }"
        @click="toggle(m.id)"
      >
        <span class="method-check">{{ selectedMethods.includes(m.id) ? '✓' : '' }}</span>
        <span class="method-label">{{ m.label }}</span>
      </button>
    </div>

    <NavBar :can-go-back="true" :disable-continue="selectedMethods.length === 0" @back="$emit('back')" @continue="handleContinue" />
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
const selectedMethods = inject('selectedMethods')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const methods = [
  { id: 'talked', label: 'Talked it through — explained my perspective and listened to theirs' },
  { id: 'compromised', label: 'Found a compromise — neither got everything, both got enough' },
  { id: 'agreed-disagree', label: 'Agreed to disagree — accepted we see it differently' },
  { id: 'gave-in', label: 'Gave in to preserve the relationship — the connection mattered more' },
  { id: 'third-party', label: 'Brought in a neutral third party — asked someone we both trust' },
  { id: 'time', label: 'Gave it time — stepped away and came back to it later' },
  { id: 'persuaded', label: 'Made my case until they came around — through argument and evidence' },
  { id: 'forced', label: 'Used my authority or leverage to override them' },
]

function toggle(id) {
  const idx = selectedMethods.value.indexOf(id)
  if (idx === -1) selectedMethods.value.push(id)
  else selectedMethods.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('exp01', 'methods', selectedMethods.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.methods { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.method-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.method-card:hover { border-color: var(--ochre); }
.method-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.method-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.method-card.selected .method-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.method-label { flex: 1; font-size: 0.88rem; }
</style>
