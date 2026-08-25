<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p></ContentBlock>
    <p class="body-text-large">If every dollar you earned represents hours of your life, then taking those dollars without your individual consent is taking your life-hours.</p>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>The philosophy doesn't claim that transitioning to voluntary funding is simple. The argument is <em>directional</em>: we should be moving toward more voluntary funding and less compulsory taking.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarC_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarC" />
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
