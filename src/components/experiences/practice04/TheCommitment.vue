<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play.</p>
    <ContentBlock variant="insight"><p>By the end of seven days, you'll see the force/persuasion question everywhere. That's not the philosophy talking. That's your own observation.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The Philosophy of Human Respect isn't something you adopt in a moment. It's something you discover gradually, as you notice the pattern in your own daily life.</p></ContentBlock>
    <NewsletterSignup source="practice04_closing" headline="Keep noticing." description="One email per week with a real situation to apply the audit to. Think of it as your weekly prompt." button-text="I'm in" success-message="Welcome. Your first weekly prompt arrives soon." />
    <JourneyNav current="practice04" />
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
