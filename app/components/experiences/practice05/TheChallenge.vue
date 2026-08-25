<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real question</p>
    <h2 class="display-medium">Will you actually do it?</h2>
    <Divider />
    <p class="body-text-large">You just designed a voluntary solution to a real problem. The question is whether you'll take the first step.</p>
    <ContentBlock variant="principle"><p>You don't need permission. You don't need a law. You need one conversation with one other person who cares about the same problem. Start there.</p></ContentBlock>
    <NewsletterSignup source="practice05_closing" headline="Keep building." description="Each week, we share one voluntary solution someone actually built — real people solving real problems without force. Get inspired, then build your own." button-text="I'm in" success-message="Welcome. Real solutions, weekly." />
    <JourneyNav current="practice05" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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
