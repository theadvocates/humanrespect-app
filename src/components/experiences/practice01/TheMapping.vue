<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Mapping your support for force</p>
    <h2 class="display-medium">Which of these do you currently support?</h2>
    <Divider />
    <p class="body-text">No judgment. This isn't about guilt — it's about seeing clearly. Check each policy you support or benefit from.</p>

    <div class="items">
      <button v-for="item in items" :key="item.id" class="item-card" :class="{ selected: selected.includes(item.id) }" @click="toggle(item.id)">
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
          <span class="item-force">Force used: {{ item.force }}</span>
        </div>
      </button>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const items = [
  { id: 'tax-income', label: 'Income tax', force: 'Compulsory payment backed by imprisonment' },
  { id: 'tax-property', label: 'Property tax', force: 'Pay or lose your home' },
  { id: 'public-school', label: 'Public schools (tax-funded)', force: 'Compulsory funding regardless of use' },
  { id: 'social-security', label: 'Social Security', force: 'Mandatory participation, no opt-out' },
  { id: 'min-wage', label: 'Minimum wage laws', force: 'Criminalizes voluntary agreements below a threshold' },
  { id: 'drug-laws', label: 'Drug prohibition', force: 'Imprisonment for personal choices' },
  { id: 'licensing', label: 'Occupational licensing', force: 'Government permission required to work' },
  { id: 'zoning', label: 'Zoning laws', force: 'Restrictions on how you use your own property' },
  { id: 'military', label: 'Military funding', force: 'Compulsory funding of foreign operations' },
  { id: 'regulations', label: 'Business regulations', force: 'Comply or face fines, closure, imprisonment' },
]

const selected = ref([])
function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.85rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.25s ease; text-align: left; font-family: inherit; font-size: 0.9rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 20px; height: 20px; border: 1.5px solid var(--border-subtle); border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: var(--ochre); margin-top: 1px; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; }
.item-force { display: block; font-size: 0.75rem; color: var(--ink-faint); margin-top: 0.1rem; font-style: italic; }
</style>
