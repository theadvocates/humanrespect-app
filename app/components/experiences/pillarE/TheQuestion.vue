<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />
    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies.</p>
    <ContentBlock variant="principle"><p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p></ContentBlock>
    <ContentBlock variant="insight"><p>The Philosophy of Human Respect claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity.</p></ContentBlock>

    <div v-if="otherIssues.length" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another issue</p>
      <PathCard v-for="issue in otherIssues" :key="issue.id" href="#" @click.prevent="$emit('restart-with', issue.id)">
        <template #title>{{ issue.label }}</template>
        <template #desc>See voluntary alternatives for {{ issue.label.toLowerCase() }}.</template>
      </PathCard>
    </div>

    <NewsletterSignup variant="minimal" source="pillarE_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarE" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { appliedIssues } from './examplesData.js'

defineEmits(['restart-with'])
const chosenIssue = inject('chosenIssue', ref(null))
const otherIssues = computed(() => appliedIssues.filter(i => i.id !== chosenIssue.value))
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
