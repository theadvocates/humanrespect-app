<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">You don't need to change everything at once. Pick one area where you currently support force and ask yourself: is there a voluntary alternative? Could this be done through persuasion, cooperation, and choice instead of compulsion?</p>

    <ContentBlock variant="insight">
      <p>The path from a coercive society to a cooperative one isn't a revolution. It's a million individual decisions to support persuasion over force, one issue at a time. Your political footprint shrinks one conscious choice at a time.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice02' }">
        <template #title>The Persuasion Practice</template>
        <template #desc>Take an issue you care about and draft a persuasion-only approach.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>See real voluntary alternatives that already work.</template>
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
