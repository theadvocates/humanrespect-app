<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real question</p>
    <h2 class="display-medium">Will you actually do it?</h2>
    <Divider />
    <p class="body-text-large">You just designed a voluntary solution to a real problem in your community. The philosophy says it can work. The evidence says it can work. The question is whether you'll take the first step.</p>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect isn't proven in arguments. It's proven in action — in the accumulated evidence of millions of people choosing cooperation over coercion, one problem at a time, one community at a time.</p>
    </ContentBlock>

    <ContentBlock variant="insight">
      <p>You don't need permission. You don't need a law. You don't need a government program. You need one conversation with one other person who cares about the same problem. Start there.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore the full philosophy</p>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Start from the beginning</template>
        <template #desc>The thought experiment that started everything.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What Flourishing Means</template>
        <template #desc>The empirical grounding of the philosophy.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>More examples of voluntary solutions already working.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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
