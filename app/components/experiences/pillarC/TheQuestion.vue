<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p></ContentBlock>
    <ContentBlock variant="insight" label="No half measure"><p>The principle isn't partial: a smaller taking is still a taking. Nor is compulsory funding simple; it runs on enforcement, compliance costs, and a budget every organized interest fights to capture. Americans gave $592.5 billion to charity in 2024 with no one made to. Voluntary funding isn't a hope. It's the part of the system that already works.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarC_closing" headline="One question per week, applied to the real world." description="A short email on how the force-or-persuasion question plays out in real situations." button-text="Subscribe" />
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
