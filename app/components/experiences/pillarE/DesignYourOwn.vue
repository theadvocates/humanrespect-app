<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your turn</p>
    <h2 class="display-medium">Pick a problem you care about.</h2>
    <Divider />

    <p class="body-text-large">The real test of any philosophy is whether it works when applied to the issues that matter to you. Choose one.</p>

    <div class="issues">
      <button
        v-for="issue in appliedIssues"
        :key="issue.id"
        class="issue-btn"
        :class="{ selected: chosen === issue.id }"
        @click="choose(issue.id)"
      >
        {{ issue.label }}
      </button>
    </div>

    <div v-if="chosenIssueData" class="issue-detail">
      <ScenarioBox label="The problem">
        <p>{{ chosenIssueData.problem }}</p>
      </ScenarioBox>

      <ContentBlock variant="mirror" label="The conventional approach (force)">
        <p>{{ chosenIssueData.forceSolution }}</p>
      </ContentBlock>

      <p class="body-text">Before we show you what voluntary alternatives look like, take a moment: can you think of a way to address this problem through persuasion and voluntary cooperation alone? No taxes. No mandates. No penalties. Just people choosing to help.</p>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosen"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { appliedIssues } from './examplesData.js'

const emit = defineEmits(['advance', 'back', 'set-issue'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const chosen = ref(null)
const chosenIssueData = computed(() => appliedIssues.find(i => i.id === chosen.value))

function choose(id) { chosen.value = id }

function emitAndAdvance() {
  emit('set-issue', chosen.value)
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.issues {
  margin: 2rem 0;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.issue-btn {
  padding: 0.65rem 1.25rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink-soft);
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}

.issue-btn:hover { border-color: var(--ochre); color: var(--ink); }
.issue-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }

.issue-detail { margin-top: 1rem; }
</style>
