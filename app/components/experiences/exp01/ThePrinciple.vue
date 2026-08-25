<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern has a name</p>
    <h2 class="display-medium">The Principle of Human Respect</h2>
    <Divider />

    <p class="body-text-large">You didn't need a philosophy to tell you that force damages relationships, erodes trust, and produces compliance instead of cooperation. You already knew. You demonstrate it every day.</p>

    <p class="body-text">The Philosophy of Human Respect simply observes that this pattern scales. What's true between two people is true between two million.</p>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>

    <p class="body-text">This holds whether the force comes from a controlling partner, an authoritarian boss, a neighborhood bully, or a democratic government. The mechanism changes. The effect on the person being forced does not.</p>

    <p class="body-text">The next experience explores the evidence for this — not from political theory, but from your own life. The conditions that were present when you were at your best, and the violations that were present when you were at your worst.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
