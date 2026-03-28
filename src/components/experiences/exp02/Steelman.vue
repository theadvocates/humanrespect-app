<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Taking your objection seriously</p>
    <h2 class="display-medium">{{ obj.title }}</h2>
    <Divider />

    <p class="body-text-large">Before responding, we need to state your objection in its strongest form. Not a caricature. The real argument, as a thoughtful person would make it.</p>

    <ContentBlock variant="mirror" label="Your objection, at its strongest">
      <p>{{ obj.steelman }}</p>
    </ContentBlock>

    <p class="body-text" style="margin-top: 1.5rem;">Is this a fair representation of your concern?</p>

    <div class="fairness-options">
      <button
        v-for="opt in fairnessOptions"
        :key="opt.id"
        class="fairness-btn"
        :class="{ selected: fairness === opt.id }"
        @click="chooseFairness(opt.id)"
      >{{ opt.label }}</button>
    </div>

    <div v-if="fairness === 'missing'" class="strengthen">
      <p class="body-text" style="margin-top: 1rem;">What's missing? In your own words, what would make this objection stronger?</p>
      <textarea v-model="strengthening" class="strengthen-input" placeholder="The part this misses is..." rows="3"></textarea>
    </div>

    <div v-if="fairness === 'stronger'" class="strengthen">
      <p class="body-text" style="margin-top: 1rem;">What's the stronger version?</p>
      <textarea v-model="strengthening" class="strengthen-input" placeholder="My real objection is..." rows="3"></textarea>
    </div>

    <p v-if="fairness" class="body-text" style="margin-top: 1.5rem; font-style: italic; color: var(--ink-faint);">We're going to engage with the strongest version of this objection — because that's the only version worth responding to.</p>

    <NavBar :can-go-back="true" :disable-continue="!fairness" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const fairness = ref(null)
const strengthening = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const fairnessOptions = [
  { id: 'fair', label: 'Yes, this captures it' },
  { id: 'missing', label: 'Close, but missing something' },
  { id: 'stronger', label: 'My real objection is stronger than this' },
]

function chooseFairness(id) {
  fairness.value = id
  trackChoice('exp02', 'steelman-fairness', id)
}

function handleContinue() {
  if (strengthening.value.trim()) {
    trackChoice('exp02', 'steelman-strengthened', 'provided')
  }
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.fairness-options { margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.4rem; }
.fairness-btn { padding: 0.55rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.fairness-btn:hover { border-color: var(--ochre); }
.fairness-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
.strengthen-input { width: 100%; margin-top: 0.5rem; padding: 0.85rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.88rem; line-height: 1.6; color: var(--ink); resize: vertical; }
.strengthen-input:focus { outline: none; border-color: var(--ochre); }
</style>
