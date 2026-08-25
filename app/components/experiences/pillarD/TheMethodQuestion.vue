<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The method question</p>
    <h2 class="display-medium">For each issue, how should society advance the goal?</h2>
    <Divider />
    <p class="body-text">Everyone agrees these are worthwhile goals. The question is whether to pursue them through force or persuasion.</p>

    <div class="issues">
      <div v-for="issue in allIssues" :key="issue.id" class="issue-block">
        <div class="issue-label">{{ issue.label }}</div>
        <div class="issue-options">
          <button
            class="method-btn"
            :class="{ selected: answers[issue.id] === 'force' }"
            @click="setAnswer(issue.id, 'force')"
          >
            <span class="method-icon">⚡</span>
            <span class="method-text">{{ issue.forceOption }}</span>
          </button>
          <button
            class="method-btn"
            :class="{ selected: answers[issue.id] === 'persuade' }"
            @click="setAnswer(issue.id, 'persuade')"
          >
            <span class="method-icon">🤝</span>
            <span class="method-text">{{ issue.persuadeOption }}</span>
          </button>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="Object.keys(answers).length < allIssues.length"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { issues as allIssues } from './valuesData.js'

const emit = defineEmits(['advance', 'back', 'set-methods'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const answers = reactive({})

function setAnswer(issueId, method) {
  answers[issueId] = method
}

function emitAndAdvance() {
  emit('set-methods', { ...answers })
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.issues {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.issue-block {}

.issue-label {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.75rem;
}

.issue-options {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.method-btn {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 0.85rem 1.1rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.88rem;
  line-height: 1.5;
  color: var(--ink-soft);
  -webkit-tap-highlight-color: transparent;
}

.method-btn:hover { border-color: var(--ochre); }
.method-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); }

.method-icon { flex-shrink: 0; font-size: 0.9rem; margin-top: 1px; }
.method-text { flex: 1; }

@media (max-width: 480px) {
  .method-btn { padding: 0.75rem 1rem; font-size: 0.85rem; }
}
</style>
