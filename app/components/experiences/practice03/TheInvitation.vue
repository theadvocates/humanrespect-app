<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The best tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">A conclusion someone reaches on their own holds far better than one you handed them. Share the one-minute question on the home page and let them find the gap themselves.</p>
    <div class="share-block">
      <button class="share-btn" @click="copyLink">{{ copied ? 'Link copied' : 'Copy link to humanrespect.app' }}</button>
    </div>
    <NewsletterSignup source="practice03_closing" headline="Keep practicing." description="One real situation a week, the force-or-persuasion question applied to it, and what others having these conversations have learned." button-text="Subscribe" success-message="Welcome. The first one arrives this week." />
    <JourneyNav current="practice03" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
const copied = ref(false)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
function copyLink() {
  navigator.clipboard.writeText('https://humanrespect.app').then(() => {
    copied.value = true; setTimeout(() => { copied.value = false }, 2000)
  })
}
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.share-block { text-align: center; margin: 2rem 0; }
.share-btn { padding: 0.85rem 2rem; background: var(--ochre); color: white; border: none; border-radius: 100px; font-family: var(--sans); font-size: 0.9rem; cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.share-btn:hover { background: var(--ochre-deep); transform: translateY(-1px); }
</style>
