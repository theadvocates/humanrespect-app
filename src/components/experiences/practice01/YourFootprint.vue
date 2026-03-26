<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your political footprint</p>
    <h2 class="display-medium">{{ selectedAreas.length }} of {{ totalItems }} areas.</h2>
    <Divider />

    <!-- Visual footprint -->
    <div class="footprint-visual">
      <div class="footprint-grid">
        <div
          v-for="item in allItems"
          :key="item.id"
          class="footprint-cell"
          :class="{ active: selectedAreas.includes(item.id) }"
          :title="item.label"
        />
      </div>
      <p class="footprint-legend">
        <span class="legend-active"></span> Force supported
        <span class="legend-inactive"></span> Not selected
      </p>
    </div>

    <p class="body-text-large">Each filled square represents an area of life where you support using government force against peaceful people who disagree or don't comply.</p>

    <ContentBlock variant="mirror">
      <p>This doesn't make you a bad person. Nearly everyone's footprint looks like this. These policies are so normal that the force behind them has become invisible. That's exactly why this exercise exists — to make the invisible visible.</p>
    </ContentBlock>

    <div class="breakdown">
      <div v-for="cat in categorizedSelections" :key="cat.label" class="breakdown-row">
        <div class="breakdown-label">{{ cat.label }}</div>
        <div class="breakdown-bar">
          <div class="breakdown-fill" :style="{ width: cat.pct + '%' }"></div>
        </div>
        <div class="breakdown-count">{{ cat.selected }}/{{ cat.total }}</div>
      </div>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
const selectedAreas = inject('selectedAreas')

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const categories = [
  { label: 'Your money', ids: ['income-tax', 'property-tax', 'sales-tax', 'social-security'] },
  { label: 'Services you use', ids: ['public-schools', 'roads', 'police', 'military'] },
  { label: 'Rules you support', ids: ['min-wage', 'drug-laws', 'licensing', 'zoning', 'regulations', 'env-regs'] },
]

const allItems = computed(() => {
  const items = []
  categories.forEach(cat => {
    cat.ids.forEach(id => items.push({ id, label: id.replace(/-/g, ' ') }))
  })
  return items
})

const totalItems = computed(() => allItems.value.length)

const categorizedSelections = computed(() => {
  return categories.map(cat => ({
    label: cat.label,
    total: cat.ids.length,
    selected: cat.ids.filter(id => selectedAreas.value.includes(id)).length,
    pct: Math.round(100 * cat.ids.filter(id => selectedAreas.value.includes(id)).length / cat.ids.length)
  }))
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.footprint-visual { margin: 2rem 0; text-align: center; }
.footprint-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 6px;
  max-width: 280px;
  margin: 0 auto;
}
.footprint-cell {
  aspect-ratio: 1;
  border-radius: 4px;
  background: var(--paper-warm);
  border: 1px solid var(--border-subtle);
  transition: all 0.3s ease;
}
.footprint-cell.active {
  background: var(--ochre);
  border-color: var(--ochre);
}

.footprint-legend {
  margin-top: 1rem;
  font-size: 0.72rem;
  color: var(--ink-faint);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}
.legend-active {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 2px;
  background: var(--ochre);
  margin-right: 0.2rem;
}
.legend-inactive {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 2px;
  background: var(--paper-warm);
  border: 1px solid var(--border-subtle);
  margin-left: 0.75rem;
  margin-right: 0.2rem;
}

.breakdown { margin: 2rem 0; }
.breakdown-row {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.65rem;
}
.breakdown-label {
  flex-shrink: 0;
  width: 120px;
  font-size: 0.8rem;
  color: var(--ink-muted);
  text-align: right;
}
.breakdown-bar {
  flex: 1;
  height: 8px;
  background: var(--paper-warm);
  border-radius: 4px;
  overflow: hidden;
}
.breakdown-fill {
  height: 100%;
  background: var(--ochre);
  border-radius: 4px;
  transition: width 0.6s ease;
}
.breakdown-count {
  flex-shrink: 0;
  width: 36px;
  font-size: 0.75rem;
  color: var(--ink-faint);
}
</style>
