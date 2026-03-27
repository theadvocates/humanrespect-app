<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />
    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>
    <ContentBlock variant="principle"><p>...then a political system that operates by taking people's time without their individual consent is consuming the very substance of human life.</p></ContentBlock>
    <p class="body-text">This doesn't make the people in government evil. It means the <em>system</em> is misaligned with what human beings actually need to flourish.</p>
    <div class="closing-question-block"><p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p></div>
    <ContentBlock variant="insight"><p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks different.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarB_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarB" />
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
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question-block { margin: 2.5rem 0; text-align: center; padding: 2rem 1.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.7rem); line-height: 1.45; color: var(--ink); font-style: italic; font-weight: 400; }
</style>
