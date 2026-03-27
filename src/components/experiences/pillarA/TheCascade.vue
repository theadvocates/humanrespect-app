<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The chain reaction</p>
    <h2 class="display-medium">One act of violence breaks four things at once.</h2>
    <Divider />

    <div class="cascade">
      <div class="cascade-step">
        <div class="cascade-num">1</div>
        <div>
          <div class="cascade-title">The body</div>
          <p>Physical harm, or the credible threat of it. The nervous system shifts from growth mode to survival mode.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">2</div>
        <div>
          <div class="cascade-title">The mind</div>
          <p>Fear spreads beyond the victim. Witnesses, neighbors, and entire communities begin to operate from vigilance instead of openness.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">3</div>
        <div>
          <div class="cascade-title">Trust</div>
          <p>People withdraw from public spaces, stop helping strangers, avoid engagement. The invisible infrastructure of cooperation erodes.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">4</div>
        <div>
          <div class="cascade-title">Prosperity</div>
          <p>Without trust, cooperation costs more. Every interaction requires contracts, verification, protection. Innovation slows. Investment dries up. The economy of a community runs on trust, and violence drains the tank.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Societies with high levels of violence are invariably poor. The most prosperous societies are those where physical safety is the norm. The relationship is causal. Safety produces trust, trust produces cooperation, cooperation produces prosperity.</p>
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
.cascade { margin: 2rem 0; display: flex; flex-direction: column; gap: 0; }
.cascade-step { display: flex; gap: 1rem; align-items: flex-start; padding: 0.75rem 0; }
.cascade-num { flex-shrink: 0; width: 24px; height: 24px; border-radius: 50%; background: var(--ochre-faint); color: var(--ochre); font-family: var(--serif); font-size: 0.8rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.cascade-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.15rem; }
.cascade-step p { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
.cascade-arrow { text-align: center; color: var(--ink-faint); font-size: 0.8rem; padding: 0.15rem 0; margin-left: 8px; }
</style>
