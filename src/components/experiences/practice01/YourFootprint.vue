<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your political footprint</p>
    <h2 class="display-medium">The gap between force and support.</h2>
    <Divider />

    <!-- Stats row -->
    <div class="stats-row">
      <div class="stat">
        <div class="stat-number">{{ operates.length }}</div>
        <div class="stat-label">areas where force operates</div>
      </div>
      <div class="stat">
        <div class="stat-number stat-green">{{ supports.length }}</div>
        <div class="stat-label">areas you support</div>
      </div>
      <div class="stat">
        <div class="stat-number stat-ochre">{{ gap }}</div>
        <div class="stat-label">areas of involuntary force</div>
      </div>
    </div>

    <!-- Visual grid -->
    <div class="footprint-visual">
      <div class="footprint-grid">
        <div
          v-for="item in allItems"
          :key="item.id"
          class="footprint-cell"
          :class="cellClass(item.id)"
          :title="item.label + ': ' + cellLabel(item.id)"
        />
      </div>
      <div class="footprint-legend">
        <span class="legend-item"><span class="legend-dot supported"></span> Force you support</span>
        <span class="legend-item"><span class="legend-dot involuntary"></span> Force imposed on you</span>
        <span class="legend-item"><span class="legend-dot none"></span> No force identified</span>
      </div>
    </div>

    <ContentBlock v-if="gap > 0" variant="mirror">
      <p>{{ gap }} areas of your life involve government force that you don't actually endorse. That's not a political position — it's a measurement. These are places where someone else's priorities are being imposed on you through the threat of punishment.</p>
    </ContentBlock>

    <ContentBlock v-if="gap === 0 && supports.length > 0" variant="mirror">
      <p>You support every area of force you identified. That's a consistent position. The question the philosophy raises: for each one, could the same goal be achieved through voluntary cooperation instead?</p>
    </ContentBlock>

    <ContentBlock v-if="supports.length === 0 && operates.length > 0" variant="mirror">
      <p>You identified {{ operates.length }} areas where force operates but don't endorse any of them. Your entire political footprint is involuntary. You already see the scope of the problem the philosophy describes.</p>
    </ContentBlock>

    <!-- Per-category breakdown -->
    <div class="breakdown">
      <div v-for="cat in categoryBreakdown" :key="cat.label" class="breakdown-row">
        <div class="breakdown-label">{{ cat.label }}</div>
        <div class="breakdown-bars">
          <div class="bar-track">
            <div class="bar-fill operates" :style="{ width: cat.operatesPct + '%' }"></div>
            <div class="bar-fill supported" :style="{ width: cat.supportsPct + '%' }"></div>
          </div>
        </div>
        <div class="breakdown-count">{{ cat.supportsCount }}/{{ cat.operatesCount }}</div>
      </div>
      <div class="breakdown-legend">
        <span class="legend-item"><span class="legend-dot involuntary" style="width:8px;height:8px;"></span> operates</span>
        <span class="legend-item"><span class="legend-dot supported" style="width:8px;height:8px;"></span> supported</span>
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
import { categories, allItemIds } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
const supports = inject('supports')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allItems = categories.flatMap(cat => cat.items)
const gap = computed(() => operates.value.length - supports.value.length)

function cellClass(id) {
  if (supports.value.includes(id)) return 'supported'
  if (operates.value.includes(id)) return 'involuntary'
  return 'none'
}

function cellLabel(id) {
  if (supports.value.includes(id)) return 'force you support'
  if (operates.value.includes(id)) return 'force imposed on you'
  return 'no force identified'
}

const categoryBreakdown = computed(() => {
  return categories.map(cat => {
    const ids = cat.items.map(i => i.id)
    const operatesCount = ids.filter(id => operates.value.includes(id)).length
    const supportsCount = ids.filter(id => supports.value.includes(id)).length
    const total = ids.length
    return {
      label: cat.label,
      operatesCount,
      supportsCount,
      operatesPct: Math.round(100 * operatesCount / total),
      supportsPct: Math.round(100 * supportsCount / total)
    }
  })
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.stats-row { display: flex; gap: 1rem; margin: 2rem 0; text-align: center; }
.stat { flex: 1; padding: 1rem 0.5rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.stat-number { font-family: var(--serif); font-size: 2rem; font-weight: 500; color: var(--ink); }
.stat-green { color: var(--insight-green); }
.stat-ochre { color: var(--ochre); }
.stat-label { font-size: 0.68rem; color: var(--ink-muted); margin-top: 0.25rem; line-height: 1.3; }

.footprint-visual { margin: 2rem 0; text-align: center; }
.footprint-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; max-width: 280px; margin: 0 auto; }
.footprint-cell { aspect-ratio: 1; border-radius: 4px; border: 1px solid var(--border-subtle); transition: all 0.3s ease; }
.footprint-cell.supported { background: var(--insight-green); border-color: var(--insight-green); }
.footprint-cell.involuntary { background: var(--ochre); border-color: var(--ochre); }
.footprint-cell.none { background: var(--paper-warm); }

.footprint-legend { margin-top: 1rem; display: flex; flex-wrap: wrap; justify-content: center; gap: 1rem; font-size: 0.72rem; color: var(--ink-faint); }
.legend-item { display: flex; align-items: center; gap: 0.3rem; }
.legend-dot { display: inline-block; width: 10px; height: 10px; border-radius: 2px; }
.legend-dot.supported { background: var(--insight-green); }
.legend-dot.involuntary { background: var(--ochre); }
.legend-dot.none { background: var(--paper-warm); border: 1px solid var(--border-subtle); }

.breakdown { margin: 2rem 0; }
.breakdown-row { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.65rem; }
.breakdown-label { flex-shrink: 0; width: 110px; font-size: 0.78rem; color: var(--ink-muted); text-align: right; }
.breakdown-bars { flex: 1; }
.bar-track { height: 10px; background: var(--paper-warm); border-radius: 5px; overflow: hidden; position: relative; }
.bar-fill { height: 100%; position: absolute; top: 0; left: 0; border-radius: 5px; transition: width 0.6s ease; }
.bar-fill.operates { background: var(--ochre); opacity: 0.4; }
.bar-fill.supported { background: var(--insight-green); z-index: 1; }
.breakdown-count { flex-shrink: 0; width: 36px; font-size: 0.72rem; color: var(--ink-faint); }
.breakdown-legend { display: flex; justify-content: flex-end; gap: 1rem; font-size: 0.68rem; color: var(--ink-faint); margin-top: 0.5rem; padding-right: 36px; }

@media (max-width: 480px) {
  .stats-row { gap: 0.5rem; }
  .stat { padding: 0.75rem 0.3rem; }
  .stat-number { font-size: 1.5rem; }
  .stat-label { font-size: 0.62rem; }
  .breakdown-label { width: 80px; font-size: 0.72rem; }
}
</style>
