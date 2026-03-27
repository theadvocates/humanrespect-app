<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The social cascade</p>
    <h2 class="display-medium">Violence doesn't just break bones. It breaks trust.</h2>
    <Divider />
    <p class="body-text-large">A single act of aggression ripples outward through an entire community. Understanding this cascade reveals why bodily integrity is a social issue, not just a personal one.</p>

    <div class="cascade">
      <div class="cascade-step">
        <div class="cascade-num">1</div>
        <div>
          <div class="cascade-title">Violence occurs</div>
          <p>A person is harmed — or credibly threatened with harm.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">2</div>
        <div>
          <div class="cascade-title">Fear spreads</div>
          <p>Not just the victim — witnesses, neighbors, and the wider community begin to feel unsafe. Chronic vigilance replaces relaxed openness.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">3</div>
        <div>
          <div class="cascade-title">Trust collapses</div>
          <p>People withdraw from public spaces, stop helping strangers, lock doors, avoid engagement. The invisible infrastructure of cooperation erodes.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">4</div>
        <div>
          <div class="cascade-title">Cooperation declines</div>
          <p>Without trust, voluntary cooperation becomes rare. People stop sharing resources, investing in shared goods, or working together on common problems.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">5</div>
        <div>
          <div class="cascade-title">Prosperity stagnates</div>
          <p>Without cooperation, innovation slows, economic activity contracts, and the community's capacity to solve problems diminishes. Everyone is poorer — materially and socially.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Societies with high levels of violence are invariably poor, while the most prosperous societies are those where physical safety is the norm. The relationship is causal. Safety produces trust, trust produces cooperation, cooperation produces prosperity.</p>
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
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.cascade { margin: 2rem 0; }
.cascade-step { display: flex; gap: 1rem; align-items: flex-start; }
.cascade-num { flex-shrink: 0; width: 28px; height: 28px; border-radius: 50%; background: var(--ochre-faint); display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 0.8rem; font-weight: 500; color: var(--ochre); margin-top: 2px; }
.cascade-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.cascade-step p { font-size: 0.88rem; color: var(--ink-soft); line-height: 1.6; margin: 0; }
.cascade-arrow { text-align: center; color: var(--ink-faint); font-size: 0.85rem; padding: 0.4rem 0; padding-left: 8px; }
</style>
