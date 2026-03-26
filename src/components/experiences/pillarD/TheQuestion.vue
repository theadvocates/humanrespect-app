<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />
    <p class="body-text-large">Not because your values don't matter. Because the method matters as much as the goal — and a world of mutual persuasion produces more flourishing than a world of mutual coercion.</p>
    <ContentBlock variant="principle"><p>Can you hold your deepest values while committing never to force them on another person? And if you can — what would that actually look like in your life, your community, and your politics?</p></ContentBlock>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>This is genuinely hard. When you care deeply about an issue, the temptation to use force is powerful. The philosophy asks you to trust that persuasion and cooperation will produce better outcomes — even for the causes you care about most.</p></ContentBlock>
    <p class="body-text">People across the political spectrum genuinely disagree on values — and those disagreements are real, not trivial. But beneath the disagreements lies a question that cuts deeper: will you advance your values through persuasion, or through force? That question is the one thing people of every political identity could agree on without giving up a single value they hold. It may be the only path out of the conflict.</p>
    <NewsletterSignup variant="minimal" source="pillarD_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarD" />
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
