<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What already exists</p>
    <h2 class="display-medium">Voluntary approaches to {{ issueData?.label?.toLowerCase() }} — already working.</h2>
    <Divider />

    <div v-if="issueData" class="alternatives">
      <div v-for="(approach, i) in issueData.voluntaryApproaches" :key="i" class="alternative-item">
        <span class="alt-number">{{ String(i + 1).padStart(2, '0') }}</span>
        <span class="alt-text">{{ approach }}</span>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Notice what these have in common: every participant chose to be there. Every dollar was given voluntarily. Every provider must earn continued support through results. And every solution can be improved, adapted, or replaced without a political battle.</p>
    </ContentBlock>

    <ContentBlock variant="insight" label="The record">
      <p>Voluntary alternatives for {{ issueData?.label?.toLowerCase() }} are smaller than the compulsory programs. Size isn't a result. It's what taxing everyone for one version and crowding out the rest produces. Look at the record instead. Real spending per pupil has risen sharply for decades while test scores stayed flat. The poverty rate was already falling fast before the War on Poverty and has barely moved since the early 1970s. Before the New Deal, fraternal and mutual-aid societies covered a large share of working families. The question isn't whether voluntary approaches could grow. It's whether the compulsory ones deliver.</p>
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
