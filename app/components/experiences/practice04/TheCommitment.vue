<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play.</p>
    <ContentBlock variant="insight"><p>By day seven you'll start seeing the question everywhere. That isn't the philosophy talking; it's your own observation.</p></ContentBlock>
    <ContentBlock variant="principle"><p>Nobody adopts the Philosophy of Human Respect in a moment. You find it gradually, by noticing the pattern in your own days.</p></ContentBlock>
    <NewsletterSignup source="practice04_closing" headline="Keep noticing." description="One email a week with a real situation to run the audit on." button-text="Subscribe" success-message="Welcome. The first one arrives this week." />
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
