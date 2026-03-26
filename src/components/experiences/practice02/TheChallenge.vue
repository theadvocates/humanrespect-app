<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If it was, that's the point. We've been trained to reach for force as the default tool. "There ought to be a law" is the reflex. Designing voluntary solutions requires more creativity, more empathy, and more trust in other people.</p>
    <ContentBlock variant="insight">
      <p>But notice what you just did: you designed an approach that respects everyone involved. No one is forced. No one is threatened. Every participant chose to be there. Whatever you drafted, it's built on cooperation — and that means it's built on trust, which means it's built to last.</p>
    </ContentBlock>
    <ContentBlock variant="principle">
      <p>The next time you hear a political proposal, try this: strip out the force. Imagine the same goal pursued through persuasion alone. What would it take? What would it look like? And is it really impossible — or just unfamiliar?</p>
    </ContentBlock>
    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice03' }">
        <template #title>The Conversation</template>
        <template #desc>A framework for discussing Human Respect with someone who disagrees.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice01' }">
        <template #title>Your Political Footprint</template>
        <template #desc>Map where you currently support coercion in your life.</template>
      </PathCard>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
