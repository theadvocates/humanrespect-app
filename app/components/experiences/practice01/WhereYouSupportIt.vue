<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Pass 2 of 2</p>
    <h2 class="display-medium">Now: which of these do you actually support?</h2>
    <Divider />
    <p class="body-text">You identified {{ operates.length }} areas where government force operates in your life. Now look at each one and ask: do I believe this <em>should</em> be enforced through force? Check only the ones you genuinely endorse.</p>

    <div class="items">
      <button
        v-for="item in operatingItems"
        :key="item.id"
        class="item-card"
        :class="{ selected: supports.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ supports.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
        </div>
      </button>
    </div>

    <p class="tally">{{ supports.length }} of {{ operates.length }} areas supported</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { categories } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
const supports = inject('supports')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allItems = categories.flatMap(cat => cat.items)
const operatingItems = computed(() => allItems.filter(i => operates.value.includes(i.id)))

function toggle(id) {
  const idx = supports.value.indexOf(id)
  if (idx === -1) supports.value.push(id)
  else supports.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: center; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--insight-green); }
.item-card.selected { border-color: var(--insight-green); background: var(--insight-bg); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--insight-green); margin-top: 0px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--insight-green); border-color: var(--insight-green); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.tally { text-align: center; margin-top: 1.5rem; font-size: 0.85rem; color: var(--ink-muted); font-style: italic; }
</style>
