<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If physical safety is the precondition for flourishing...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...what does that mean for institutions whose primary tool is the threat of force?</p></ContentBlock>
    <p class="body-text-large">Every law is ultimately backed by the threat of physical enforcement. Every tax carries the implicit promise: comply, or men with guns will eventually come.</p>
    <ContentBlock variant="insight"><p>A society aligned with Human Respect must design systems that protect bodies and restore safety <em>without</em> becoming a source of the fear they're meant to prevent.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarA_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarA" />
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
