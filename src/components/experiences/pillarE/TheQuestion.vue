<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />

    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies. It resolves billions in disputes, funds hundreds of billions in charitable giving, and sustains communities across the globe.</p>

    <ContentBlock variant="principle">
      <p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p>
    </ContentBlock>

    <p class="body-text">Every social problem that seems to "require" government force was once solved — or is currently being solved — by people who chose to cooperate. The question isn't whether voluntary solutions are possible. It's whether we'll give them the space to grow.</p>

    <ContentBlock variant="insight">
      <p>The Philosophy of Human Respect doesn't claim that voluntary cooperation will solve every problem overnight. It claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity. And it asks: given the evidence, which trajectory do you want to be on?</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>Why time is the most fundamental human resource — and what coercion really costs.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>The question isn't what you value — it's how you propose to advance it.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>The Original Question</template>
        <template #desc>Where it all started — the thought experiment that reveals the gap.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
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

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
