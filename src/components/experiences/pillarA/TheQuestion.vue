<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If physical safety is the precondition for flourishing...</h2>
    <Divider />

    <ContentBlock variant="principle">
      <p>...what does that mean for institutions whose primary tool is the threat of force?</p>
    </ContentBlock>

    <p class="body-text-large">Every law is ultimately backed by the threat of physical enforcement. Every tax carries the implicit promise: comply, or men with guns will come to your door. Every regulation rests on the willingness to cage those who disobey.</p>

    <p class="body-text">This isn't a radical claim. It's a description of how government functions. The question is whether that constant background hum of threatened force — even when rarely carried out — suppresses the very flourishing it claims to protect.</p>

    <ContentBlock variant="insight">
      <p>A society aligned with Human Respect must design systems that protect bodies and restore safety <em>without</em> becoming a source of the fear they're meant to prevent. Protection through voluntary cooperation, community accountability, and restorative justice — rather than through the threat of state violence.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarC' }">
        <template #title>What You Built Is Who You Were</template>
        <template #desc>Property as crystallized time — the second domain of human integrity.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The third domain — and the most fundamental of all.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Values aren't the problem. The method is.</template>
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
