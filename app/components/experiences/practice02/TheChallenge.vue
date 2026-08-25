<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If it was, that's the point. We've been trained to reach for force as the default.</p>
    <ContentBlock variant="insight"><p>Whatever you drafted, it respects everyone involved. No one is forced. Every participant chose to be there.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The next time you hear a political proposal, try this: strip out the force. What would the same goal look like through persuasion alone?</p></ContentBlock>
    <NewsletterSignup source="practice02_closing" headline="Keep practicing." description="Each week, we take one real political proposal and ask: what would this look like without force? Join and practice alongside others." button-text="I'm in" success-message="Welcome. The first situation arrives this week." />
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
