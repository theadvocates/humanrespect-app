<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your own evidence</p>
    <h2 class="display-medium">Think about the best sustained period of your life.</h2>
    <Divider />
    <p class="body-text-large">Not a single happy moment — a stretch where things were genuinely working. A time when you felt like the version of yourself you were meant to be.</p>
    <p class="body-text">What was present during that time? Select everything that applies.</p>

    <div class="conditions">
      <button
        v-for="c in conditions"
        :key="c.id"
        class="condition-card"
        :class="{ selected: selected.includes(c.id) }"
        @click="toggle(c.id)"
      >
        <span class="condition-check">{{ selected.includes(c.id) ? '✓' : '' }}</span>
        <span class="condition-text">{{ c.label }}</span>
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

const emit = defineEmits(['advance', 'back', 'select-conditions'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const conditions = [
  { id: 'safety', label: 'I felt safe — physically and emotionally secure' },
  { id: 'autonomy', label: 'I had control over my own choices and direction' },
  { id: 'connection', label: 'I was surrounded by people I trusted and who trusted me' },
  { id: 'competence', label: 'I was building something, learning, or doing meaningful work' },
  { id: 'purpose', label: 'I had a clear sense of purpose or direction' },
  { id: 'opportunity', label: 'I had the time and resources to pursue what mattered to me' }
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
  emit('select-conditions', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.conditions { margin: 2rem 0 1rem; }

.condition-card {
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

.condition-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
}

.condition-card.selected {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.condition-check {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  color: var(--ochre);
  transition: all 0.2s ease;
  margin-top: 1px;
}

.condition-card.selected .condition-check {
  background: var(--ochre);
  border-color: var(--ochre);
  color: white;
}

.condition-text {
  flex: 1;
}

@media (max-width: 480px) {
  .condition-card {
    padding: 0.85rem 1rem;
    font-size: 0.9rem;
  }
}
</style>
