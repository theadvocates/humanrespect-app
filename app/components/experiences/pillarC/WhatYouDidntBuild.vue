<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hidden cost</p>
    <h2 class="display-medium">What have you not built because you weren't sure you could keep it?</h2>
    <Divider />

    <p class="body-text">The visible cost of theft is the thing taken. The invisible cost is everything that never gets created. When people can't trust that the products of their effort will remain theirs, they stop creating.</p>

    <p class="body-text">Have you ever held back because of material insecurity? Check any that apply.</p>

    <div class="items">
      <button
        v-for="item in items"
        :key="item.id"
        class="item-card"
        :class="{ selected: selected.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <span class="item-label">{{ item.label }}</span>
      </button>
    </div>

    <div v-if="selected.length > 0" class="reflection">
      <ContentBlock variant="mirror">
        <p>Each one of these represents something that could have existed but doesn't. A business that might have employed people. A risk that might have paid off. A contribution to the world that was never made. Multiply your list by every person who made the same calculation, and you begin to see the real cost of material insecurity.</p>
      </ContentBlock>
    </div>

    <ContentBlock variant="insight">
      <p>Economists call this "dead capital" and "regime uncertainty." When property is insecure, people invest less, build less, share less, and take fewer risks. The cost is invisible because you can't see what was never created. But it compounds across millions of people and entire generations.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selected = ref([])
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const items = [
  { id: 'business', label: 'A business I thought about starting but didn\'t' },
  { id: 'investment', label: 'An investment I avoided because I wasn\'t sure the rules would stay stable' },
  { id: 'property', label: 'A property or home I didn\'t buy because of tax or regulatory burden' },
  { id: 'career-risk', label: 'A career risk I didn\'t take because the safety net wasn\'t there' },
  { id: 'generosity', label: 'A charitable gift I didn\'t make because I wasn\'t financially secure enough' },
  { id: 'project', label: 'A creative project I abandoned because it wouldn\'t pay enough after taxes and fees' },
  { id: 'savings', label: 'Savings I didn\'t build because too much of my income was already spoken for' },
  { id: 'none', label: 'None of these apply to me' },
]

function toggle(id) {
  if (id === 'none') {
    selected.value = ['none']
  } else {
    selected.value = selected.value.filter(i => i !== 'none')
    const idx = selected.value.indexOf(id)
    if (idx === -1) selected.value.push(id)
    else selected.value.splice(idx, 1)
  }
  trackChoice('pillarC', 'what-you-didnt-build', selected.value.join(','))
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: center; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); transition: all 0.2s; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-label { flex: 1; font-size: 0.88rem; }
.reflection { margin-top: 1.5rem; }
</style>
