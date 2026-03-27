<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Translate the language</p>
    <h2 class="display-medium">Political language obscures what you're actually authorizing. Translate it.</h2>
    <Divider />

    <p class="body-text">For each statement, choose the translation that most accurately describes the force being authorized.</p>

    <div class="translations">
      <div v-for="(t, idx) in translations" :key="t.id" class="translation-block">
        <div class="translation-sanitized">"{{ t.sanitized }}"</div>
        <div class="translation-options" v-if="!answers[t.id]">
          <button
            v-for="opt in t.options"
            :key="opt.id"
            class="option-btn"
            @click="choose(t.id, opt.id, opt.correct)"
          >{{ opt.text }}</button>
        </div>
        <div v-else class="translation-result">
          <div class="result-chosen" :class="{ correct: answers[t.id].correct, incorrect: !answers[t.id].correct }">
            {{ answers[t.id].correct ? '✓' : '✗' }} {{ answers[t.id].correct ? 'Correct.' : 'Close, but not quite.' }}
          </div>
          <div class="result-actual">
            <div class="result-label">The full translation:</div>
            <p>{{ t.actual }}</p>
          </div>
        </div>
      </div>
    </div>

    <div v-if="allAnswered">
      <ContentBlock variant="insight">
        <p>The language of politics is engineered to sound reasonable. "Funding public services." "Protecting consumers." "Ensuring compliance." Behind every one of these phrases is a chain of authorization that ends with armed agents and a cage. The philosophy asks you to see through the language to the force underneath — not to make you angry, but to make you honest about what you're choosing.</p>
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

const translations = [
  {
    id: 'healthcare',
    sanitized: 'I support universal healthcare.',
    options: [
      { id: 'a', text: 'I want everyone to have access to a doctor.', correct: false },
      { id: 'b', text: 'I authorize armed agents to take money from people who would rather spend it differently, and to penalize medical professionals who practice outside approved boundaries.', correct: true },
      { id: 'c', text: 'I believe healthcare is a human right.', correct: false },
    ],
    actual: 'I authorize the seizure of earnings from every working person to fund a system designed by political actors, and I authorize penalties — including fines and imprisonment — against anyone who provides or obtains healthcare outside the approved system.'
  },
  {
    id: 'borders',
    sanitized: 'I support strong borders.',
    options: [
      { id: 'a', text: 'I want to protect our country and culture.', correct: false },
      { id: 'b', text: 'I authorize armed agents to detain, cage, and deport people whose only action was crossing a line drawn by a government to work and feed their families.', correct: true },
      { id: 'c', text: 'I believe nations have a right to self-determination.', correct: false },
    ],
    actual: 'I authorize armed agents to patrol borders, detain people in facilities, separate families, and forcibly transport human beings to places they fled — for the act of moving across a line on a map without government permission.'
  },
  {
    id: 'education',
    sanitized: 'I support public education.',
    options: [
      { id: 'a', text: 'I want every child to have access to learning.', correct: false },
      { id: 'b', text: 'I authorize compulsory funding from all property owners regardless of whether they have children, and I authorize truancy enforcement against parents who educate their children outside the approved system.', correct: true },
      { id: 'c', text: 'I believe education is the foundation of democracy.', correct: false },
    ],
    actual: 'I authorize the seizure of property from every homeowner to fund schools they may never use, designed by political actors and administered by bureaucracies. I authorize the state to dictate how children are educated and to threaten parents with fines or custody action if they choose differently.'
  },
]

const allAnswered = computed(() => Object.keys(answers.value).length === translations.length)

function choose(translationId, optionId, correct) {
  answers.value[translationId] = { id: optionId, correct }
  trackChoice('exp05', 'translate-' + translationId, optionId + (correct ? '-correct' : '-incorrect'))
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.translations { margin: 2rem 0; display: flex; flex-direction: column; gap: 2rem; }
.translation-block { }
.translation-sanitized { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); padding: 1rem 1.25rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); margin-bottom: 0.75rem; }
.translation-options { display: flex; flex-direction: column; gap: 0.4rem; }
.option-btn { display: block; width: 100%; text-align: left; padding: 0.75rem 1rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.82rem; line-height: 1.55; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.option-btn:hover { border-color: var(--ochre); background: var(--ochre-faint); }

.translation-result { margin-top: 0.5rem; }
.result-chosen { padding: 0.5rem 0.75rem; border-radius: var(--radius); font-size: 0.82rem; font-weight: 500; margin-bottom: 0.5rem; }
.result-chosen.correct { background: var(--insight-bg); color: var(--insight-green); }
.result-chosen.incorrect { background: var(--ochre-faint); color: var(--ochre); }
.result-actual { padding: 0.85rem 1.1rem; background: var(--concede-bg); border-left: 3px solid var(--concede-warm); border-radius: var(--radius); }
.result-label { font-size: 0.68rem; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--concede-warm); margin-bottom: 0.4rem; }
.result-actual p { margin: 0; font-size: 0.82rem; line-height: 1.65; color: var(--ink-muted); }
</style>
