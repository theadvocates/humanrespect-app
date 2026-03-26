<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />

    <ContentBlock variant="principle">
      <p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p>
    </ContentBlock>

    <p class="body-text-large">This isn't a gotcha. It's a genuine question that the Philosophy of Human Respect takes seriously. If every dollar you earned represents hours of your life, then taking those dollars without your individual consent is taking your life-hours. The mechanism — whether it's a thief, a scammer, or a tax collector — doesn't change the effect on the person whose time was consumed.</p>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>The philosophy doesn't claim that transitioning to voluntary funding is simple or painless. Many people depend on services funded by compulsory taxation, and pulling the rug would cause real harm. The argument is <em>directional</em>: we should be moving toward more voluntary funding and less compulsory taking, not because taxation is identical to street theft, but because both involve the same fundamental act — consuming someone's life-hours without their individual consent.</p>
    </ContentBlock>

    <p class="body-text">The three domains are now complete. Your body, your resources, and your time — each one essential for flourishing, each one violated by a different form of coercion, and each one deserving of respect.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">The complete Three Domains</p>
      <PathCard :to="{ name: 'pillarA' }">
        <template #title>Bodily Integrity</template>
        <template #desc>Respect the Body: Do not harm. The precondition for all flourishing.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Temporal Integrity</template>
        <template #desc>Respect Time: Do not coerce. The most fundamental human resource.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Values aren't the problem. The method is.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Real evidence that voluntary solutions work.</template>
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
