<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you care about</p>
    <h2 class="display-medium">Which of these values resonate with you?</h2>
    <Divider />
    <p class="body-text">There are no wrong answers. All of these are genuine, positive values that guide real people's lives. Select the ones that feel most important to you.</p>

    <div class="values-grid">
      <button
        v-for="v in allValues"
        :key="v.id"
        class="value-card"
        :class="{ selected: selected.includes(v.id) }"
        @click="toggle(v.id)"
      >
        <span class="value-check">{{ selected.includes(v.id) ? '✓' : '' }}</span>
        <div class="value-content">
          <span class="value-label">{{ v.label }}</span>
          <span class="value-desc">{{ v.desc }}</span>
        </div>
      </button>
    </div>

    <ContentBlock v-if="selected.length >= 2" variant="insight">
      <p v-if="hasBoth">You selected values from both progressive and conservative traditions. That's not a contradiction — it's human. Most people hold a mix.</p>
      <p v-else-if="leansProg">Your values lean progressive. That's a genuine expression of what you believe matters. The next question isn't about <em>whether</em> these values are right — it's about <em>how</em> to advance them.</p>
      <p v-else>Your values lean conservative. That's a genuine expression of what you believe matters. The next question isn't about <em>whether</em> these values are right — it's about <em>how</em> to advance them.</p>
    </ContentBlock>

    <NavBar
      :can-go-back="true"
      :disable-continue="selected.length < 2"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { values as allValues } from './valuesData.js'

const emit = defineEmits(['advance', 'back', 'set-values'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selected = ref([])

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
}

const progCount = computed(() => selected.value.filter(id => allValues.find(v => v.id === id)?.lean === 'progressive').length)
const consCount = computed(() => selected.value.filter(id => allValues.find(v => v.id === id)?.lean === 'conservative').length)
const hasBoth = computed(() => progCount.value > 0 && consCount.value > 0)
const leansProg = computed(() => progCount.value > consCount.value)

function emitAndAdvance() {
  emit('set-values', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.values-grid {
  margin: 2rem 0 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.value-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 1rem 1.25rem;
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

.value-card:hover { border-color: var(--ochre); box-shadow: var(--shadow-hover); }
.value-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }

.value-check {
  flex-shrink: 0;
  width: 22px; height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.75rem; color: var(--ochre);
  transition: all 0.2s ease; margin-top: 1px;
}

.value-card.selected .value-check {
  background: var(--ochre); border-color: var(--ochre); color: white;
}

.value-content { flex: 1; }
.value-label { display: block; font-weight: 500; color: var(--ink); }
.value-desc { display: block; font-size: 0.8rem; color: var(--ink-muted); margin-top: 0.15rem; }

@media (max-width: 480px) {
  .value-card { padding: 0.85rem 1rem; font-size: 0.9rem; }
}
</style>
