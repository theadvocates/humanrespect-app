<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The most powerful tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">The most effective thing you can do isn't to explain the philosophy yourself. It's to send someone <strong>Experience 01</strong> — the original thought experiment — and let them discover the gap on their own.</p>
    <ContentBlock variant="insight">
      <p>A conclusion someone reaches themselves is a hundred times more powerful than one you handed them. The thought experiment is designed to create that self-discovery. Your job isn't to argue — it's to share the link and say: "I went through this five-minute thing. Curious what you'd get."</p>
    </ContentBlock>

    <div class="share-block">
      <p class="body-text" style="margin-bottom: 1rem;">Copy the link to share:</p>
      <button class="share-btn" @click="copyLink">{{ copied ? 'Copied!' : 'humanrespect.app → Copy link' }}</button>
    </div>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice04' }">
        <template #title>The Respect Audit</template>
        <template #desc>Track where you choose persuasion vs. force for 7 days.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice02' }">
        <template #title>The Persuasion Practice</template>
        <template #desc>Design a voluntary solution for an issue you care about.</template>
      </PathCard>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
const el = ref(null)
const copied = ref(false)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function copyLink() {
  navigator.clipboard.writeText('https://humanrespect.app').then(() => {
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  })
}
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.share-block { text-align: center; margin: 2rem 0; }
.share-btn { padding: 0.85rem 2rem; background: var(--ochre); color: white; border: none; border-radius: 100px; font-family: var(--sans); font-size: 0.9rem; cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.share-btn:hover { background: var(--ochre-light); transform: translateY(-1px); }
</style>
