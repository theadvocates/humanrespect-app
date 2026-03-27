<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The principle, grounded</p>
    <h2 class="display-medium">What the Philosophy of Human Respect is actually saying.</h2>
    <Divider />

    <p class="body-text-large">In Experience 01, you encountered the principle as a claim. Now you can see where it comes from — not from ideology, but from the observable structure of human well-being.</p>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
      <p style="margin-top: 1rem;">Therefore, the ethical foundation of society is the full respect for each person's body, resources, and time.</p>
    </ContentBlock>

    <p class="body-text">This isn't a political position. It's a statement about cause and effect — the same kind of statement as "plants grow toward light" or "trust increases cooperation." It describes a pattern that holds across cultures, eras, and individual lives.</p>

    <p class="body-text">Including yours. The best period of your life had these conditions present. The worst period had them violated. That's not a coincidence — it's the pattern the principle describes.</p>

    <ContentBlock variant="insight">
      <p>What makes this different from other moral frameworks is the grounding. This isn't "coercion is wrong because rights exist" — a claim that requires accepting a metaphysical premise. This is "coercion is wrong because it predictably damages human flourishing" — a claim you can test against your own experience and the evidence of every society in history.</p>
    </ContentBlock>

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

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
