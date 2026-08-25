<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The inverse</p>
    <h2 class="display-medium">Now consider the hardest sustained period of your life.</h2>
    <Divider />
    <p class="body-text-large">A stretch where things weren't working. Where you felt diminished, stuck, or struggling. Not a bad day — a bad chapter.</p>
    <p class="body-text">What was being violated or missing? Select what applies.</p>

    <div class="violations">
      <button
        v-for="v in violations"
        :key="v.id"
        class="violation-card"
        :class="{ selected: selected.includes(v.id) }"
        @click="toggle(v.id)"
      >
        <span class="violation-check">{{ selected.includes(v.id) ? '✓' : '' }}</span>
        <div class="violation-content">
          <span class="violation-text">{{ v.label }}</span>
          <span class="violation-domain">{{ v.domain }}</span>
        </div>
      </button>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="selected.length === 0"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

const emit = defineEmits(['advance', 'back', 'select-violations'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const violations = [
  { id: 'body-unsafe', label: 'My physical safety was threatened or compromised', domain: 'Body' },
  { id: 'body-fear', label: 'I lived with persistent fear or anxiety about harm', domain: 'Body' },
  { id: 'resources-taken', label: 'My money, property, or resources were taken or unstable', domain: 'Resources' },
  { id: 'resources-insecure', label: 'I couldn\'t plan for the future because my material foundation was shaky', domain: 'Resources' },
  { id: 'time-controlled', label: 'Someone else controlled how I spent my time', domain: 'Time' },
  { id: 'time-wasted', label: 'I was forced to spend my hours on things I didn\'t choose', domain: 'Time' },
  { id: 'time-trapped', label: 'I felt trapped — unable to direct my own life', domain: 'Time' }
]

const selected = ref([])

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) {
    selected.value.push(id)
  } else {
    selected.value.splice(idx, 1)
  }
}

function emitAndAdvance() {
  emit('select-violations', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.violations { margin: 2rem 0 1rem; }

.violation-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 1rem 1.25rem;
  margin-bottom: 0.6rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.violation-card:hover {
  border-color: var(--concede-warm);
  box-shadow: var(--shadow-hover);
}

.violation-card.selected {
  border-color: var(--concede-warm);
  background: var(--concede-bg);
}

.violation-check {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  color: var(--concede-warm);
  transition: all 0.2s ease;
  margin-top: 1px;
}

.violation-card.selected .violation-check {
  background: var(--concede-warm);
  border-color: var(--concede-warm);
  color: white;
}

.violation-content { flex: 1; }
.violation-text { display: block; }
.violation-domain {
  display: block;
  font-size: 0.75rem;
  color: var(--ink-faint);
  margin-top: 0.2rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .violation-card {
    padding: 0.85rem 1rem;
    font-size: 0.9rem;
  }
}
</style>
