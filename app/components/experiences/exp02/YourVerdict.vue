<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your assessment</p>
    <h2 class="display-medium">Did the response address your objection?</h2>
    <Divider />

    <div class="verdict-options">
      <button
        v-for="v in verdictOptions"
        :key="v.id"
        class="verdict-btn"
        :class="{ selected: verdict === v.id }"
        @click="chooseVerdict(v.id)"
      >
        <div class="verdict-label">{{ v.label }}</div>
        <div class="verdict-desc">{{ v.desc }}</div>
      </button>
    </div>

    <div v-if="verdict" class="verdict-response">
      <p v-if="verdict === 'addressed'" class="body-text" style="font-style: italic; color: var(--insight-green);">The next experiences explore what the principle means for your body, your time, your resources, and how you relate to political systems.</p>
      <p v-else-if="verdict === 'partial'" class="body-text" style="font-style: italic; color: var(--ochre);">The principle holds either way. Which part didn't land? Name it, and take it into the next experience — it is probably the version of your objection that matters most.</p>
      <p v-else class="body-text" style="font-style: italic; color: var(--concede-warm);">The principle holds. The response may have missed your version of the objection, and that is the version worth answering. The next experiences come at it from other directions.</p>
    </div>

    <NavBar :can-go-back="true" :disable-continue="!verdict" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const verdict = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const verdictOptions = [
  { id: 'addressed', label: 'Yes, it addressed my concern', desc: 'The response engaged with the real objection and the reasoning holds.' },
  { id: 'partial', label: 'Partially', desc: 'Some parts landed. Others didn\'t. I\'m not fully convinced.' },
  { id: 'not-addressed', label: 'No, it missed the point', desc: 'The response didn\'t engage with what actually concerns me.' },
]

function chooseVerdict(id) {
  verdict.value = id
  trackChoice('exp02', 'verdict', id)
  if (!journey.exp02) journey.exp02 = {}
  journey.exp02.verdict = id
  journey.persist()
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.verdict-options { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.verdict-btn { width: 100%; text-align: left; padding: 1rem 1.25rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.verdict-btn:hover { border-color: var(--ochre); }
.verdict-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.verdict-label { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.verdict-desc { font-size: 0.78rem; color: var(--ink-faint); margin-top: 0.15rem; }
.verdict-response { margin-top: 1rem; }
</style>
