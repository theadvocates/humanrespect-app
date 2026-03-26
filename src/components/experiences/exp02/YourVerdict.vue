<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your assessment</p>
    <h2 class="display-medium">You've seen the steelman, the response, and the honest concession.</h2>
    <Divider />
    <p class="body-text-large">Where do you land?</p>

    <div class="verdicts">
      <button
        v-for="v in verdicts"
        :key="v.id"
        class="verdict-card"
        :class="{ selected: chosen === v.id }"
        @click="choose(v.id)"
      >
        <div class="verdict-label">{{ v.label }}</div>
        <div class="verdict-desc">{{ v.desc }}</div>
      </button>
    </div>

    <div v-if="chosen" class="response-block stagger" ref="responseEl">
      <ContentBlock v-if="chosen === 'addressed'" variant="insight">
        <p>That's worth sitting with. Not because you should agree with every detail, but because a philosophy that can survive your strongest objection has earned your further attention.</p>
      </ContentBlock>
      <ContentBlock v-if="chosen === 'partial'" variant="insight">
        <p>That's a fair assessment. The philosophy doesn't claim to have a perfect answer to every objection. What it claims is that the <em>direction</em> — toward voluntary cooperation and away from force — produces better outcomes than the alternative. Partial answers can still point in the right direction.</p>
      </ContentBlock>
      <ContentBlock v-if="chosen === 'not-addressed'" variant="concession" label="Acknowledged">
        <p>That's an honest answer, and it matters. If the philosophy can't adequately address your core concern, you shouldn't pretend it did. You might find that the deeper experiences address aspects the response missed, or you might conclude that this particular objection remains a genuine limitation. Either way, your honesty makes the conversation better.</p>
      </ContentBlock>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosen"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const responseEl = ref(null)
const chosen = ref(null)

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const verdicts = [
  {
    id: 'addressed',
    label: 'My objection was addressed.',
    desc: 'The response was substantive and the concession was honest. I\'m willing to explore further.'
  },
  {
    id: 'partial',
    label: 'Partially addressed.',
    desc: 'Some points landed, but I still have reservations. The concession helped.'
  },
  {
    id: 'not-addressed',
    label: 'Not adequately addressed.',
    desc: 'My core concern remains. The response didn\'t resolve it.'
  }
]

function choose(id) {
  chosen.value = id
  trackChoice('exp02', 'verdict', id)
  nextTick(() => {
    if (responseEl.value) {
      responseEl.value.classList.add('animate')
    }
  })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.verdicts { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.75rem; }
.verdict-card {
  display: block;
  width: 100%;
  padding: 1.1rem 1.35rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  color: var(--ink);
  -webkit-tap-highlight-color: transparent;
}
.verdict-card:hover { border-color: var(--ochre); }
.verdict-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.verdict-label { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; }
.verdict-desc { font-size: 0.82rem; color: var(--ink-muted); margin-top: 0.25rem; line-height: 1.55; }
.verdict-card.selected .verdict-label { color: var(--ink); }
.response-block { margin-top: 1.5rem; }
</style>
