<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">Pick one area from your footprint, ideally one you marked as involuntary, and spend this week looking into voluntary alternatives. Not arguing about it online. Not convincing anyone. Just finding out: has anyone solved this without force?</p>

    <ContentBlock variant="insight">
      <p>Your political footprint changes one choice at a time — not by revolution, but by quietly questioning force in one more area of life.</p>
    </ContentBlock>

    <NewsletterSignup source="practice01_closing" headline="Keep practicing." description="One real situation a week, and the question: force or persuasion? Plus the voluntary solutions other people have designed." button-text="Subscribe" success-message="Welcome. The first situation arrives this week." />
    <JourneyNav current="practice01" />
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
