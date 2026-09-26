<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />
    <p class="body-text-large">Not because your values don't matter. Because the method matters as much as the goal, and a world of mutual persuasion produces more flourishing than a world of mutual coercion.</p>
    <ContentBlock variant="principle"><p>If you can — what does that look like in your life, your community, and your politics?</p></ContentBlock>
    <ContentBlock variant="insight" label="What demands faith"><p>When you care deeply about an issue, the pull toward force is real. But force is what demands faith: a law hands your cause to whoever wins next. Persuasion keeps feedback, exit, and accountability. Force removes all three.</p></ContentBlock>
    <p class="body-text">Beneath every political disagreement lies a deeper question: will you advance your values through persuasion, or through force? People of every political identity can agree on that without giving up a single value. And it is the way out of the conflict, because the conflict exists only as long as there is machinery of force worth capturing.</p>
    <NewsletterSignup variant="minimal" source="pillarD_closing" headline="One question per week, applied to the real world." description="A short email on how the force-or-persuasion question plays out in real situations." button-text="Subscribe" />
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
