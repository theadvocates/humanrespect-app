<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Pass 1 of 2</p>
    <h2 class="display-medium">Where does government force currently operate in your life?</h2>
    <Divider />
    <p class="body-text">This isn't about whether you agree with these policies. Just identify where force — the threat of fines, seizure, or imprisonment — is the enforcement mechanism.</p>

    <div class="categories">
      <div v-for="cat in categories" :key="cat.id" class="category">
        <p class="cat-label">{{ cat.label }}</p>
        <div class="items">
          <button
            v-for="item in cat.items"
            :key="item.id"
            class="item-card"
            :class="{ selected: operates.includes(item.id) }"
            @click="toggle(item.id)"
          >
            <span class="item-check">{{ operates.includes(item.id) ? '✓' : '' }}</span>
            <div class="item-content">
              <span class="item-label">{{ item.label }}</span>
              <span class="item-mechanism">{{ item.mechanism }}</span>
            </div>
          </button>
        </div>
      </div>
    </div>

    <p class="tally">{{ operates.length }} of {{ totalItems }} areas identified</p>

    <NavBar :can-go-back="true" :disable-continue="operates.length === 0" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { categories, totalItems } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function toggle(id) {
  const idx = operates.value.indexOf(id)
  if (idx === -1) operates.value.push(id)
  else operates.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.categories { margin: 2rem 0; }
.cat-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin: 1.5rem 0 0.5rem; }
.category:first-child .cat-label { margin-top: 0; }
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
