<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Translate the language</p>
    <h2 class="display-medium">Political language obscures what you're actually authorizing. Translate it.</h2>
    <Divider />

    <p class="body-text">Each of these statements sounds reasonable. For each one, choose the translation that most accurately describes the force being authorized. These span the political spectrum deliberately — the philosophy doesn't take sides.</p>

    <div class="translations">
      <div v-for="t in translations" :key="t.id" class="translation-block">
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
        <p>Notice that these translations cut across the political spectrum. Progressive policies use force. Conservative policies use force. The philosophy doesn't ask you to abandon your values. It asks you to see the method clearly — and then decide whether that method is consistent with what you know about how force affects human beings.</p>
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
      { id: 'b', text: 'I authorize the seizure of earnings from every working person and penalties against anyone who provides or obtains care outside the approved system.', correct: true },
      { id: 'c', text: 'I believe healthcare is a human right that society should guarantee.', correct: false },
    ],
    actual: 'I authorize armed agents to take a portion of every working person\'s earnings to fund a system designed by political actors. I authorize fines and imprisonment for anyone who provides medical care outside approved channels — including a doctor who charges less than the approved rate, or a patient who buys medication from abroad.'
  },
  {
    id: 'drug-war',
    sanitized: 'I support the war on drugs.',
    options: [
      { id: 'a', text: 'I want to protect communities from the damage of addiction.', correct: false },
      { id: 'b', text: 'I authorize armed raids on homes, imprisonment of people for possessing substances, and the destruction of families — for choices that directly harmed no one else.', correct: true },
      { id: 'c', text: 'I believe certain substances are too dangerous to allow.', correct: false },
    ],
    actual: 'I authorize armed agents to break into homes, cage human beings for years, and permanently destroy their employability, their families, and their futures — for the act of consuming a substance in private. I authorize this knowing that enforcement falls disproportionately on the poorest and most marginalized communities.'
  },
  {
    id: 'rent-control',
    sanitized: 'I support rent control.',
    options: [
      { id: 'a', text: 'I want housing to be affordable for working families.', correct: false },
      { id: 'b', text: 'I authorize the government to dictate what a property owner may charge for the use of their own building, with fines and legal action against anyone who asks for more.', correct: true },
      { id: 'c', text: 'I believe landlords shouldn\'t be able to exploit tenants.', correct: false },
    ],
    actual: 'I authorize the government to override voluntary agreements between property owners and tenants. If a landlord charges more than the approved rate — even if a tenant willingly agrees to pay it — I authorize fines, legal proceedings, and ultimately armed enforcement against the owner. The long-term result, documented across every city that has tried it: housing shortages, deteriorating buildings, and a black market that hurts the people the policy was meant to protect.'
  },
  {
    id: 'mandatory-min',
    sanitized: 'I support mandatory minimum sentences.',
    options: [
      { id: 'a', text: 'I want consistent justice that doesn\'t depend on which judge you get.', correct: false },
      { id: 'b', text: 'I authorize the removal of judicial discretion, requiring judges to cage people for predetermined periods regardless of circumstances, remorse, or likelihood of rehabilitation.', correct: true },
      { id: 'c', text: 'I believe criminals need to face real consequences.', correct: false },
    ],
    actual: 'I authorize legislators who will never meet the defendant to predetermine the sentence. I remove the power of the one person in the system who actually sees the human being — the judge — to exercise judgment. I authorize caging a first-time offender for the same duration as a career criminal, destroying families and producing people more likely to reoffend, because the system that was supposed to rehabilitate them did nothing but warehouse them.'
  }
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
