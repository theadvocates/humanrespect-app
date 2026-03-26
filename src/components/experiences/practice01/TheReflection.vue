<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">Pick one area from your footprint and spend this week exploring voluntary alternatives. Not arguing about it online. Not trying to convince anyone. Just researching: has anyone solved this without force?</p>

    <ContentBlock variant="insight">
      <p>Your political footprint shrinks one conscious choice at a time. Not through revolution, but through the quiet decision to stop supporting force in one more area of life.</p>
    </ContentBlock>

    <NewsletterSignup source="practice01_closing" headline="Keep practicing." description="A weekly email with one real-world situation and the question: force or persuasion? Plus what other people designed as voluntary solutions." button-text="I'm in" success-message="Welcome. The first situation arrives this week." />
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
