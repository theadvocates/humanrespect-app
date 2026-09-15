<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If so, that's the point. Most of us were taught to reach for force first.</p>
    <ContentBlock variant="insight"><p>Whatever you drafted, no one in it is forced. Everyone involved chose to be there.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The next time you hear a political proposal, try this: strip out the force. What would the same goal look like through persuasion alone?</p></ContentBlock>
    <NewsletterSignup source="practice02_closing" headline="Keep practicing." description="Each week, one real political proposal and the question: what would this look like without force?" button-text="Subscribe" success-message="Welcome. The first one arrives this week." />
    <JourneyNav current="practice02" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
