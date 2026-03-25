<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />

    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>

    <ContentBlock variant="principle">
      <p>...then a political system that operates by taking people's time without their individual consent is not merely inefficient or unfortunate. It is consuming the very substance of human life.</p>
    </ContentBlock>

    <p class="body-text">This doesn't make the people in government evil. It doesn't make voters complicit in a crime. It means the <em>system</em> — the mechanism of compulsory participation — is misaligned with what human beings actually need to flourish. And it means the search for voluntary alternatives isn't utopian idealism. It's the most practical thing we could possibly do.</p>

    <div class="closing-question-block">
      <p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p>
    </div>

    <ContentBlock variant="insight">
      <p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks fundamentally different.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>Revisit: What Flourishing Actually Means</template>
        <template #desc>The full framework — Safety, Autonomy, Connection, Competence, Purpose, and Opportunity.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Revisit: The Original Question</template>
        <template #desc>The thought experiment that started everything — now with a deeper understanding of what's at stake.</template>
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

.closing-question-block {
  margin: 2.5rem 0;
  text-align: center;
  padding: 2rem 1.5rem;
}

.closing-question {
  font-family: var(--serif);
  font-size: clamp(1.3rem, 3vw, 1.7rem);
  line-height: 1.45;
  color: var(--ink);
  font-style: italic;
  font-weight: 400;
}
</style>
