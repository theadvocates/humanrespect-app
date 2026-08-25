<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What already exists</p>
    <h2 class="display-medium">Voluntary approaches to {{ issueData?.label?.toLowerCase() }} — already working.</h2>
    <Divider />

    <p class="body-text-large">These aren't theoretical. Each of these approaches exists right now, somewhere in the world, producing real results without coercion.</p>

    <div v-if="issueData" class="alternatives">
      <div v-for="(approach, i) in issueData.voluntaryApproaches" :key="i" class="alternative-item">
        <span class="alt-number">{{ String(i + 1).padStart(2, '0') }}</span>
        <span class="alt-text">{{ approach }}</span>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Notice what these have in common: every participant chose to be there. Every dollar was given voluntarily. Every provider must earn continued support through results. And every solution can be improved, adapted, or replaced without a political battle.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Voluntary alternatives to {{ issueData?.label?.toLowerCase() }} are not yet as large-scale or well-funded as their government counterparts. This is partly because government programs crowd out voluntary alternatives — when people are already taxed for a service, they're less likely to fund it voluntarily too. The question isn't whether voluntary approaches are currently as big, but whether they <em>could</em> grow to meet the need if the compulsory alternatives were gradually phased out.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { appliedIssues } from './examplesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const chosenIssue = inject('chosenIssue', ref(null))
const issueData = computed(() => appliedIssues.find(i => i.id === chosenIssue.value))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.alternatives {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.alternative-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
}

.alt-number {
  flex-shrink: 0;
  font-family: var(--serif);
  font-size: 0.85rem;
  color: var(--ochre);
  margin-top: 0.1rem;
}

.alt-text {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.6;
}

@media (max-width: 480px) {
  .alternative-item { padding: 0.85rem 1rem; }
}
</style>
