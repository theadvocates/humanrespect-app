#!/bin/bash
# Updates Experience 01 Invitation to include Exp 03 in the paths
# Run from humanrespect-app/ root AFTER running exp03-screens.sh

cat > src/components/experiences/exp01/Invitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="8" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />
    <p class="body-text-large">You already live by the principle of Human Respect in most of your life. You don't steal from neighbors. You don't threaten coworkers. You solve problems through conversation, persuasion, and voluntary agreement.</p>
    <p class="body-text-large">The question is whether you'll extend that same principle to how you think about politics and society.</p>
    <p class="closing-question">What if every social problem you care about could be addressed through cooperation instead of force — and what if the solutions would actually work better?</p>
    <ContentBlock variant="insight">
      <p>This isn't a question that gets answered in five minutes. It's a question that changes how you see every political argument, every policy debate, every election — for the rest of your life.</p>
    </ContentBlock>
    <p class="body-text" style="text-align: center; margin-top: 2rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>

    <div class="continue-paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>You probably have a "but..."</template>
        <template #desc>Pick your strongest objection. We'll take it seriously, respond honestly, and tell you what the philosophy can't claim.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What flourishing actually means</template>
        <template #desc>The empirical grounding — why the principle is true, discovered from your own life experience.</template>
      </PathCard>
      <PathCard href="#" @click.prevent="share">
        <template #title>Share this experience</template>
        <template #desc>{{ shareDesc }}</template>
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
import { useJourneyStore } from '@/stores/journey'

const journey = useJourneyStore()
const el = ref(null)
const shareDesc = ref('Send this thought experiment to someone you disagree with politically. See what they discover.')

onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp01(journey.exp01.personal, journey.exp01.political)
})

function share() {
  const text = "I just went through a 5-minute thought experiment that showed me something I'd never noticed about my own political beliefs."
  const url = window.location.origin + '/experience/the-question'

  if (navigator.share) {
    navigator.share({ title: 'The Question That Changes Everything', text, url })
  } else {
    navigator.clipboard.writeText(text + ' ' + url).then(() => {
      shareDesc.value = 'Link copied to clipboard.'
      setTimeout(() => {
        shareDesc.value = 'Send this thought experiment to someone you disagree with politically. See what they discover.'
      }, 2000)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question {
  font-family: var(--serif);
  font-size: clamp(1.3rem, 3vw, 1.6rem);
  line-height: 1.5;
  color: var(--ink);
  text-align: center;
  margin: 2rem 0;
  font-style: italic;
}
</style>
VUEEOF

echo "✓ Experience 01 Invitation updated with Exp 03 link"
