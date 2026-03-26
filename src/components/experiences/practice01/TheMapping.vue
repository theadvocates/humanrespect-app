<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Map your footprint</p>
    <h2 class="display-medium">Where do you currently support the use of force?</h2>
    <Divider />
    <p class="body-text">No judgment. This is about seeing clearly. For each area, ask: does the government use force (fines, imprisonment, seizure) to fund or enforce this?</p>

    <div class="categories">
      <div v-for="cat in categories" :key="cat.id" class="category">
        <p class="cat-label">{{ cat.label }}</p>
        <div class="items">
          <button
            v-for="item in cat.items"
            :key="item.id"
            class="item-card"
            :class="{ selected: selectedAreas.includes(item.id) }"
            @click="toggle(item.id)"
          >
            <span class="item-check">{{ selectedAreas.includes(item.id) ? '✓' : '' }}</span>
            <div class="item-content">
              <span class="item-label">{{ item.label }}</span>
              <span class="item-mechanism">{{ item.mechanism }}</span>
            </div>
          </button>
        </div>
      </div>
    </div>

    <p class="tally">{{ selectedAreas.length }} of {{ totalItems }} areas selected</p>

    <NavBar :can-go-back="true" :disable-continue="selectedAreas.length === 0" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selectedAreas = inject('selectedAreas')

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const categories = [
  {
    id: 'money',
    label: 'Your money',
    items: [
      { id: 'income-tax', label: 'Income tax', mechanism: 'Compulsory payment; non-compliance leads to penalties and imprisonment' },
      { id: 'property-tax', label: 'Property tax', mechanism: 'Pay or your home is seized, even if fully paid for' },
      { id: 'sales-tax', label: 'Sales tax', mechanism: 'Added to every purchase; businesses face closure for non-collection' },
      { id: 'social-security', label: 'Social Security / Medicare', mechanism: 'Mandatory payroll deduction; no individual opt-out' },
    ]
  },
  {
    id: 'services',
    label: 'Services you use',
    items: [
      { id: 'public-schools', label: 'Public schools', mechanism: 'Tax-funded regardless of whether you use them or have children' },
      { id: 'roads', label: 'Roads and infrastructure', mechanism: 'Gas taxes and general revenue; no option to fund only roads you use' },
      { id: 'police', label: 'Police and courts', mechanism: 'Tax-funded; no option to choose alternative dispute resolution' },
      { id: 'military', label: 'Military and defense', mechanism: 'Compulsory funding of all operations including those you oppose' },
    ]
  },
  {
    id: 'rules',
    label: 'Rules you support',
    items: [
      { id: 'min-wage', label: 'Minimum wage laws', mechanism: 'Criminalizes voluntary employment agreements below a threshold' },
      { id: 'drug-laws', label: 'Drug prohibition', mechanism: 'Imprisonment for personal consumption choices' },
      { id: 'licensing', label: 'Occupational licensing', mechanism: 'Government permission required to practice many professions' },
      { id: 'zoning', label: 'Zoning and building codes', mechanism: 'Restrictions on how you use property you own' },
      { id: 'regulations', label: 'Business regulations', mechanism: 'Comply or face fines, forced closure, or imprisonment' },
      { id: 'env-regs', label: 'Environmental regulations', mechanism: 'Mandated compliance backed by fines and penalties' },
    ]
  }
]

const totalItems = computed(() => categories.reduce((sum, cat) => sum + cat.items.length, 0))

function toggle(id) {
  const idx = selectedAreas.value.indexOf(id)
  if (idx === -1) selectedAreas.value.push(id)
  else selectedAreas.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('practice01', 'footprint-areas', selectedAreas.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.categories { margin: 2rem 0; }
.cat-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin: 1.5rem 0 0.5rem; }
.cat-label:first-child { margin-top: 0; }
.items { display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.item-mechanism { display: block; font-size: 0.72rem; color: var(--ink-faint); margin-top: 0.1rem; }
.tally { text-align: center; margin-top: 1.5rem; font-size: 0.85rem; color: var(--ink-muted); font-style: italic; }
</style>
