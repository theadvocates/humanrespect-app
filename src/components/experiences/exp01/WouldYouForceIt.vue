<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The thought experiment</p>
    <h2 class="display-medium">Now imagine you had access to someone with the authority to simply force the other person to comply.</h2>
    <Divider />

    <p class="body-text-large">No conversation needed. No compromise. Just a call, and someone with real power would make the other person do what you wanted. They'd face penalties if they refused.</p>

    <p class="body-text">In that disagreement you were just thinking about — would you have used it?</p>

    <div class="choices">
      <button class="choice-btn" :class="{ selected: wouldForce === 'no' }" @click="choose('no')">
        No.
      </button>
      <button class="choice-btn" :class="{ selected: wouldForce === 'yes' }" @click="choose('yes')">
        Yes, I would have.
      </button>
    </div>

    <div v-if="wouldForce === 'no'" class="followup stagger" ref="followupEl">
      <p class="body-text" style="margin-top: 1.5rem;">Why not? Select everything that rings true.</p>

      <div class="reasons">
        <button
          v-for="r in reasons"
          :key="r.id"
          class="reason-card"
          :class="{ selected: whyNot.includes(r.id) }"
          @click="toggleReason(r.id)"
        >
          <span class="reason-check">{{ whyNot.includes(r.id) ? '✓' : '' }}</span>
          <span class="reason-label">{{ r.label }}</span>
        </button>
      </div>
    </div>

    <div v-if="wouldForce === 'yes'" class="followup">
      <ContentBlock variant="mirror">
        <p>That's honest. Hold onto that answer. The philosophy has something specific to say about what happens when force becomes the go-to method for resolving disagreements, even when the person using it believes they're right.</p>
      </ContentBlock>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!wouldForce || (wouldForce === 'no' && whyNot.length === 0)"
      @back="$emit('back')"
      @continue="handleContinue"
    />
  </div>
</template>

<script setup>
import { ref, inject, nextTick, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const followupEl = ref(null)
const wouldForce = inject('wouldForce')
const whyNot = inject('whyNot')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const reasons = [
  { id: 'relationship', label: 'It would have damaged the relationship' },
  { id: 'resentment', label: 'They would have resented me' },
  { id: 'belief', label: 'It wouldn\'t have changed what they actually believe' },
  { id: 'respect', label: 'It feels wrong to override someone I respect' },
  { id: 'cost', label: 'The long-term cost isn\'t worth the short-term win' },
  { id: 'wrong', label: 'Using force on someone who hasn\'t harmed me is simply wrong' },
]

function choose(value) {
  wouldForce.value = value
  trackChoice('exp01', 'would-force', value)
  if (value === 'no') {
    nextTick(() => {
      if (followupEl.value) followupEl.value.classList.add('animate')
    })
  }
}

function toggleReason(id) {
  const idx = whyNot.value.indexOf(id)
  if (idx === -1) whyNot.value.push(id)
  else whyNot.value.splice(idx, 1)
}

function handleContinue() {
  if (wouldForce.value === 'no') {
    trackChoice('exp01', 'why-not', whyNot.value.join(','))
  }
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 1.5rem 0; display: flex; gap: 0.75rem; }
.choice-btn { flex: 1; padding: 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.choice-btn:hover { border-color: var(--ochre); }
.choice-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.reasons { margin: 1rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.reason-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.7rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.85rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.reason-card:hover { border-color: var(--ochre); }
.reason-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.reason-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 1px; transition: all 0.2s; }
.reason-card.selected .reason-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.reason-label { flex: 1; }
</style>
