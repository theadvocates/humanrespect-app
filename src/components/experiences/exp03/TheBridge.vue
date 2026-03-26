<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">You now have the complete framework.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div>
          <div class="foundation-title">The gap</div>
          <p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div>
          <div class="foundation-title">The objection</div>
          <p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div>
          <div class="foundation-title">The grounding</div>
          <p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time. Coercion violates all three.</p>
        </div>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">From here, the philosophy goes deeper. Each dimension has implications that reshape how you think about justice, economics, community, and the role of institutions in human life.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Go deeper</p>

      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The philosophy's most original insight: time is the irreplaceable substance of life, and every form of coercion is ultimately a theft of time.</template>
      </PathCard>

      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Your values aren't the problem — progressive or conservative, they're both genuine. The question is whether you advance them through persuasion or force.</template>
      </PathCard>

      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Voluntary cooperation isn't just morally superior to coercion — it's more effective. Real examples of people solving "impossible" problems without force.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Or revisit</p>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Experience 01: The Question</template>
        <template #desc>The thought experiment that started it all.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>Experience 02: The Objection</template>
        <template #desc>Your strongest pushback, honestly examined.</template>
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
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.foundation-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
</style>
