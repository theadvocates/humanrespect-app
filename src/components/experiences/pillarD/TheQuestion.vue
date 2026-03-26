<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />

    <p class="body-text-large">Not because your values don't matter. Not because the issues aren't urgent. But because the method matters as much as the goal — and because a world of mutual persuasion produces more flourishing than a world of mutual coercion.</p>

    <ContentBlock variant="principle">
      <p>Can you hold your deepest values while committing never to force them on another person? And if you can — what would that actually look like in your life, your community, and your politics?</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>This is hard. Genuinely hard. When you care deeply about an issue — poverty, education, moral standards, the environment — the temptation to use force is powerful. "If only we could make everyone do the right thing." But the Philosophy of Human Respect asks you to trust that persuasion, voluntary cooperation, and creative problem-solving will produce better outcomes than coercion — even for the causes you care about most.</p>
    </ContentBlock>

    <p class="body-text">The political wars of our era are not really about values. They're about method. And the moment enough people commit to persuasion over force, the war ends — not because everyone agrees, but because no one is trying to compel agreement anymore.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>Why time is the most fundamental human resource — and what that means for every form of coercion.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What Flourishing Actually Means</template>
        <template #desc>The six pillars of well-being and three domains of human integrity.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>The Original Question</template>
        <template #desc>Where it all started — the thought experiment that reveals the gap.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
