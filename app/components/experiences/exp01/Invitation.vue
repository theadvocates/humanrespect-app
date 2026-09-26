<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="7" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />

    <p class="body-text-large">If persuasion works better than force in your closest relationships — if you already know this from a lifetime of experience — then why do we build our collective institutions on force?</p>

    <ContentBlock variant="insight">
      <p>This question changes how you see every policy debate. The experiences that follow show the evidence, from your own life, and then take your strongest objection seriously.</p>
    </ContentBlock>

    <JourneyNav current="exp01" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
