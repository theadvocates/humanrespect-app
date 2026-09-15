<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Translate the language</p>
    <h2 class="display-medium">Political language names the goal. Name the method.</h2>
    <Divider />

    <p class="body-text">Each of these statements names something people sincerely want. For each one, pick the sentence that describes the method: what happens to someone who doesn't go along. They come from across the political spectrum on purpose. The philosophy doesn't take sides.</p>

    <div class="translations">
      <div v-for="t in translations" :key="t.id" class="translation-block">
        <div class="translation-sanitized">"{{ t.sanitized }}"</div>
        <div v-if="!answers[t.id]" class="translation-options">
          <button
            v-for="opt in t.options"
            :key="opt.id"
            class="option-btn"
            @click="choose(t.id, opt.id, opt.correct)"
          >{{ opt.text }}</button>
        </div>
        <div v-else class="translation-result">
          <div class="result-chosen" :class="{ correct: answers[t.id].correct, incorrect: !answers[t.id].correct }">
            {{ answers[t.id].correct ? 'That\'s the method.' : 'That\'s the goal, and it\'s a real one. The method is what the policy does to get there.' }}
          </div>
          <div class="result-actual">
            <div class="result-label">The goal and the method:</div>
            <p>{{ t.actual }}</p>
          </div>
        </div>
      </div>
    </div>

    <div v-if="allAnswered">
      <ContentBlock variant="insight">
        <p>The goals on this list are good ones, and they come from the left and the right. Progressive policies use force. Conservative policies use force. The philosophy doesn't ask you to abandon your values. It asks you to see the method clearly — and then decide whether that method is consistent with what you know about how force affects human beings.</p>
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
      { id: 'a', text: 'I want everyone to be able to see a doctor.', correct: false },
      { id: 'b', text: 'I authorize taking part of every working person\'s earnings to pay for it, with penalties for anyone who refuses.', correct: true },
      { id: 'c', text: 'I believe no one should go without care because they can\'t pay.', correct: false },
    ],
    actual: 'The goal is that no one goes without care. The method is taxation: a share of every working person\'s earnings, collected whether or not they agree with the plan, with penalties, seizure, and eventually prison for anyone who refuses. Most versions also set rules on what doctors may charge and who may practice, backed by the same enforcement.'
  },
  {
    id: 'drug-war',
    sanitized: 'I support the war on drugs.',
    options: [
      { id: 'a', text: 'I want to protect communities from the damage of addiction.', correct: false },
      { id: 'b', text: 'I authorize arresting and imprisoning people for making, selling, or possessing certain substances.', correct: true },
      { id: 'c', text: 'I believe some substances are too dangerous to be sold freely.', correct: false },
    ],
    actual: 'The goal is fewer lives wrecked by addiction. The method is searches, arrests, prosecution, and prison for people who make, sell, or use certain substances, including adults who have not threatened anyone. The enforcement has fallen hardest on poor neighborhoods.'
  },
  {
    id: 'rent-control',
    sanitized: 'I support rent control.',
    options: [
      { id: 'a', text: 'I want housing to be affordable for working families.', correct: false },
      { id: 'b', text: 'I authorize penalties against owners who charge more than an approved rent, even when a tenant agrees to pay it.', correct: true },
      { id: 'c', text: 'I believe tenants shouldn\'t be priced out of their own neighborhoods.', correct: false },
    ],
    actual: 'The goal is housing that working families can afford. The method is legal limits on what owners may charge, enforced through fines and lawsuits, even when owner and tenant would both agree to a different price. Economists on the left and the right have long warned that such limits shrink and age the supply of rental housing over time.'
  },
  {
    id: 'mandatory-min',
    sanitized: 'I support mandatory minimum sentences.',
    options: [
      { id: 'a', text: 'I want consistent justice that doesn\'t depend on which judge you get.', correct: false },
      { id: 'b', text: 'I authorize legislators to fix prison terms in advance and require judges to impose them, whatever the circumstances.', correct: true },
      { id: 'c', text: 'I believe crimes should carry real consequences.', correct: false },
    ],
    actual: 'The goal is equal treatment and real consequences. The method is a law requiring a judge to imprison someone for a set term, whatever the judge learns about the person in front of them. Legislators who will never meet the defendant decide the sentence, and the judge who does meet them cannot change it.'
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
