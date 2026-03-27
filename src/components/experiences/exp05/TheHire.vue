<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">A principle you already accept</p>
    <h2 class="display-medium">In each of these situations, who bears moral responsibility?</h2>
    <Divider />

    <div class="scenarios">
      <div v-for="s in scenarios" :key="s.id" class="scenario">
        <div class="scenario-setup">{{ s.setup }}</div>
        <div class="scenario-choices">
          <button
            v-for="opt in s.options"
            :key="opt.id"
            class="choice-btn"
            :class="{ selected: answers[s.id] === opt.id }"
            @click="choose(s.id, opt.id)"
          >{{ opt.label }}</button>
        </div>
        <p v-if="answers[s.id]" class="scenario-note">{{ s.note }}</p>
      </div>
    </div>

    <div v-if="allAnswered">
      <ContentBlock variant="principle">
        <p>In every legal system and moral tradition people take seriously, the person who authorizes an action shares responsibility for it. Hiring someone to steal makes you a thief. Hiring someone to commit violence makes you complicit. The intermediary doesn't absorb your moral responsibility. It transfers through them.</p>
      </ContentBlock>
    </div>

    <NavBar :can-go-back="true" :disable-continue="!allAnswered" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const answers = ref({})
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const scenarios = [
  {
    id: 'theft',
    setup: 'You pay someone $500 to break into your neighbor\'s house and take their television.',
    options: [
      { id: 'you', label: 'You are responsible' },
      { id: 'them', label: 'Only the person you hired' },
      { id: 'both', label: 'Both of you' }
    ],
    note: 'Every court in every country would hold you responsible. You are the principal. The person you hired is your agent.'
  },
  {
    id: 'violence',
    setup: 'You pay a private enforcer to threaten a business owner into giving you a percentage of their revenue.',
    options: [
      { id: 'you', label: 'You are responsible' },
      { id: 'them', label: 'Only the enforcer' },
      { id: 'both', label: 'Both of you' }
    ],
    note: 'This is extortion. You ordered it. The enforcer carried it out. The law and common morality hold you both accountable.'
  },
  {
    id: 'group',
    setup: 'You and nine friends vote 6-4 to hire someone to take money from the four who voted no.',
    options: [
      { id: 'six', label: 'The six who voted yes' },
      { id: 'hired', label: 'Only the person hired' },
      { id: 'all', label: 'No one — it was a majority vote' }
    ],
    note: 'A vote doesn\'t change the nature of the act. Six people authorized taking money from four. The moral weight falls on those who voted for it.'
  }
]

const allAnswered = computed(() => Object.keys(answers.value).length === scenarios.length)

function choose(scenarioId, optionId) {
  answers.value[scenarioId] = optionId
  trackChoice('exp05', 'hire-' + scenarioId, optionId)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.scenarios { margin: 2rem 0; display: flex; flex-direction: column; gap: 2rem; }
.scenario-setup { font-family: var(--serif); font-size: 0.95rem; line-height: 1.6; color: var(--ink); margin-bottom: 0.75rem; padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.scenario-choices { display: flex; flex-wrap: wrap; gap: 0.4rem; }
.choice-btn { padding: 0.55rem 1rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.78rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.choice-btn:hover { border-color: var(--ochre); }
.choice-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
.scenario-note { font-size: 0.8rem; color: var(--ink-faint); font-style: italic; margin-top: 0.5rem; line-height: 1.55; }
</style>
