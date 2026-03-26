<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The most powerful tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">A conclusion someone reaches themselves is a hundred times more powerful than one you handed them. Share <strong>Experience 01</strong> and let them discover the gap on their own.</p>
    <div class="share-block">
      <button class="share-btn" @click="copyLink">{{ copied ? 'Copied!' : 'Copy link to humanrespect.app' }}</button>
    </div>
    <JourneyNav current="practice03" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
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
.share-btn:hover { background: var(--ochre-light); transform: translateY(-1px); }
</style>
