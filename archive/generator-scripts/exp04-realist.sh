#!/bin/bash
# New Experience: The Realist Case
# Route: /experience/human-nature
# Position: Foundation tier, after Exp03 (before pillars)
# Run from humanrespect-app/ root

set -e

echo "🏗️  Building Experience 04: The Realist Case..."

mkdir -p src/components/experiences/exp04

# ══════════════════════════════════════
# PAGE COMPONENT
# ══════════════════════════════════════

cat > src/pages/Experience04.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, provide, watch, onUnmounted } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp04/Opening.vue'
import HumanNature from '@/components/experiences/exp04/HumanNature.vue'
import TheExperiment from '@/components/experiences/exp04/TheExperiment.vue'
import PredictableResults from '@/components/experiences/exp04/PredictableResults.vue'
import TheContradiction from '@/components/experiences/exp04/TheContradiction.vue'
import TheReframe from '@/components/experiences/exp04/TheReframe.vue'
import TheQuestion from '@/components/experiences/exp04/TheQuestion.vue'

const { trackScreenView, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 7
const currentScreen = ref(0)
const history = ref([0])
const selectedTraits = ref([])

provide('selectedTraits', selectedTraits)

const screenComponents = [
  Opening, HumanNature, TheExperiment, PredictableResults,
  TheContradiction, TheReframe, TheQuestion
]

const screenNames = [
  'opening', 'human-nature', 'the-experiment', 'predictable-results',
  'the-contradiction', 'the-reframe', 'the-question'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp04', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('exp04')
})

onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo(0, 0)
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo(0, 0)
  }
}
</script>

<style scoped>
.exp-app { min-height: 100vh; background: var(--paper); transition: background 0.6s ease; }
.exp-app.dark-mode { background: var(--bg-dark); }
.exp-container { max-width: 640px; margin: 0 auto; padding: 4rem 1.5rem; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.35s ease, transform 0.35s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(12px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-container { padding: 2.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Experience04.vue"

# ══════════════════════════════════════
# SCREEN 1: OPENING (dark)
# ══════════════════════════════════════

cat > src/components/experiences/exp04/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 04 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">The realist<br><em>objection.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">"Nice philosophy, but people aren't that good." You're right. They aren't. And that turns out to be the strongest argument for everything that follows.</p>
    <button class="begin-btn" @click="$emit('advance')">
      Begin <span class="arrow">→</span>
    </button>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
defineEmits(['advance'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.opening { text-align: center; padding: 2rem 0; }
.overline { font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase; color: var(--ochre-light); margin-bottom: 2rem; display: block; }
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle { font-family: var(--sans); font-size: 1rem; line-height: 1.8; color: rgba(240,235,227,0.65); max-width: 480px; margin: 0 auto; }
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening"

# ══════════════════════════════════════
# SCREEN 2: HUMAN NATURE — interactive
# Visitor affirms what they already believe about people
# ══════════════════════════════════════

cat > src/components/experiences/exp04/HumanNature.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start with what you already know</p>
    <h2 class="display-medium">What have you observed about how people actually behave?</h2>
    <Divider />

    <p class="body-text">No idealism here. Based on your own experience of human beings, which of these do you recognize as generally true?</p>

    <div class="traits">
      <button
        v-for="trait in traits"
        :key="trait.id"
        class="trait-card"
        :class="{ selected: selectedTraits.includes(trait.id) }"
        @click="toggle(trait.id)"
      >
        <span class="trait-check">{{ selectedTraits.includes(trait.id) ? '✓' : '' }}</span>
        <div class="trait-content">
          <span class="trait-label">{{ trait.label }}</span>
        </div>
      </button>
    </div>

    <p v-if="selectedTraits.length >= 3" class="body-text" style="margin-top: 1.5rem;">You selected {{ selectedTraits.length }} traits. Hold onto this list. We're going to apply it somewhere specific.</p>

    <NavBar :can-go-back="true" :disable-continue="selectedTraits.length < 2" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selectedTraits = inject('selectedTraits')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const traits = [
  { id: 'self-interest', label: 'People tend to act in their own interest, especially when the costs fall on someone else' },
  { id: 'game-systems', label: 'When given a system with rules, people find ways to game it' },
  { id: 'power-abuse', label: 'People who gain power tend to use it to benefit themselves and their allies' },
  { id: 'short-term', label: 'People prioritize short-term rewards over long-term consequences' },
  { id: 'in-group', label: 'People favor their own group and are suspicious of outsiders' },
  { id: 'accountability', label: 'People behave worse when they believe no one is watching or when accountability is diffuse' },
  { id: 'rationalize', label: 'People can rationalize almost anything if it benefits them' },
  { id: 'good-intentions', label: 'Good intentions frequently produce bad outcomes when the incentives are wrong' },
]

function toggle(id) {
  const idx = selectedTraits.value.indexOf(id)
  if (idx === -1) selectedTraits.value.push(id)
  else selectedTraits.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('exp04', 'human-nature-traits', selectedTraits.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.traits { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.trait-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.trait-card:hover { border-color: var(--ochre); }
.trait-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.trait-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.trait-card.selected .trait-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.trait-content { flex: 1; }
.trait-label { display: block; font-size: 0.88rem; }
</style>
VUEEOF

echo "  ✓ HumanNature (interactive)"

# ══════════════════════════════════════
# SCREEN 3: THE EXPERIMENT
# Apply the visitor's own model of human nature to government
# ══════════════════════════════════════

cat > src/components/experiences/exp04/TheExperiment.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">Take everything you just said about human nature. Now give those humans a specific set of tools.</h2>
    <Divider />

    <div class="tools-list">
      <div class="tool-item">
        <div class="tool-icon">⚖️</div>
        <p>The legal authority to take anyone's property</p>
      </div>
      <div class="tool-item">
        <div class="tool-icon">🔒</div>
        <p>The power to cage people who disobey</p>
      </div>
      <div class="tool-item">
        <div class="tool-icon">🔫</div>
        <p>A monopoly on the legitimate use of violence</p>
      </div>
      <div class="tool-item">
        <div class="tool-icon">📋</div>
        <p>The ability to write the rules that govern everyone else</p>
      </div>
      <div class="tool-item">
        <div class="tool-icon">🛡️</div>
        <p>Legal immunity for most of what they do with these tools</p>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">You said people {{ topTraitSummary }}. What do you predict happens when those same people get these tools?</p>

    <ContentBlock variant="mirror">
      <p>You don't need the Philosophy of Human Respect to answer this. Your own model of human nature already predicts exactly what happens. The question is whether you've applied that model consistently.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
const selectedTraits = inject('selectedTraits')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const traitSummaries = {
  'self-interest': 'act in their own interest',
  'game-systems': 'game any system they can',
  'power-abuse': 'abuse power when they have it',
  'short-term': 'chase short-term rewards',
  'in-group': 'favor their own group',
  'accountability': 'behave worse without accountability',
  'rationalize': 'rationalize anything that benefits them',
  'good-intentions': 'produce bad outcomes despite good intentions'
}

const topTraitSummary = computed(() => {
  const selected = selectedTraits.value.slice(0, 3)
  const summaries = selected.map(id => traitSummaries[id]).filter(Boolean)
  if (summaries.length === 0) return 'are flawed and self-interested'
  if (summaries.length === 1) return summaries[0]
  return summaries.slice(0, -1).join(', ') + ' and ' + summaries[summaries.length - 1]
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.tools-list { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.75rem; }
.tool-item { display: flex; align-items: flex-start; gap: 1rem; padding: 0.85rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); }
.tool-icon { font-size: 1.2rem; flex-shrink: 0; margin-top: 1px; }
.tool-item p { margin: 0; font-size: 0.92rem; line-height: 1.55; color: var(--ink); }
</style>
VUEEOF

echo "  ✓ TheExperiment"

# ══════════════════════════════════════
# SCREEN 4: PREDICTABLE RESULTS
# Concrete examples — not hypothetical
# ══════════════════════════════════════

cat > src/components/experiences/exp04/PredictableResults.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The results are in</p>
    <h2 class="display-medium">Every one of these outcomes was predictable from the incentive structure.</h2>
    <Divider />

    <p class="body-text">These are not failures of the system. They are the system working exactly as its incentives dictate.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card" :class="{ expanded: expanded === ex.id }" @click="toggleExpand(ex.id)">
        <div class="example-header">
          <div class="example-title">{{ ex.title }}</div>
          <div class="example-toggle">{{ expanded === ex.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === ex.id" class="example-body">
          <p class="example-incentive"><strong>The incentive:</strong> {{ ex.incentive }}</p>
          <p class="example-result"><strong>The result:</strong> {{ ex.result }}</p>
          <p class="example-prediction">{{ ex.prediction }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>None of these required corruption in the traditional sense. The people involved were often acting rationally within the incentive structure they were given. The problem is the structure itself: when you reward political actors for expanding their authority, they expand it. When you shield them from the costs of their decisions, they make worse decisions. When you give them the power to reward allies with other people's money, they do exactly that.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
const expanded = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function toggleExpand(id) {
  expanded.value = expanded.value === id ? null : id
}

const examples = [
  {
    id: 'regulatory-capture',
    title: 'Regulatory capture',
    incentive: 'Industries being regulated have billions at stake. Regulators have modest salaries and career ambitions. The regulated have every incentive to hire, fund, and influence the regulators.',
    result: 'Major banks write their own financial regulations. Pharmaceutical companies staff the FDA. Telecom giants shape FCC policy. The agencies created to protect the public become tools of the industries they oversee.',
    prediction: 'Anyone who understands self-interest would predict this. Give one group the power to write rules for another, and the group with the most at stake will capture the rule-writers.'
  },
  {
    id: 'civil-forfeiture',
    title: 'Civil asset forfeiture',
    incentive: 'Police departments get to keep property they seize from suspects. No conviction required. The seized assets fund department budgets.',
    result: 'In many jurisdictions, police seize more property from citizens than burglars do. People who are never charged with a crime lose their cars, homes, and savings. The burden of proof falls on the victim to prove their property is "innocent."',
    prediction: 'Tell any group of humans they can take other people\'s property and keep it, with minimal oversight. The outcome is obvious.'
  },
  {
    id: 'lobbying',
    title: 'Political lobbying',
    incentive: 'A $1 million lobbying investment can yield $100 million in favorable legislation. Political access is the highest-return investment available.',
    result: 'The lobbying industry spends over $4 billion per year in the US alone. Corporations write legislation that their lobbyists hand to legislators. The return on lobbying investment dwarfs the return on productive investment.',
    prediction: 'When you create a system where political favors are worth billions, people will spend billions to obtain them. The incentive makes this inevitable.'
  },
  {
    id: 'war',
    title: 'Military expansion',
    incentive: 'The people who decide to go to war never fight in it. Defense contractors profit from it. Politicians who appear "strong on defense" win elections. The costs are externalized to soldiers, taxpayers, and foreign civilians.',
    result: 'The United States has been at war for the majority of its existence. The defense budget exceeds the next several countries combined. Wars are started based on false or exaggerated intelligence and continue long after any strategic justification has evaporated.',
    prediction: 'Separate the people who benefit from war from the people who bear its costs, and wars will be frequent and prolonged. This is basic incentive economics.'
  },
  {
    id: 'welfare',
    title: 'Permanent dependency',
    incentive: 'Politicians gain votes by providing benefits. Agencies gain budgets by having more recipients. Reducing dependency means reducing the political constituency and the agency\'s reason to exist.',
    result: 'Programs designed to be temporary become permanent. Eligibility requirements are structured to penalize earning more income. Trillions spent on poverty programs over decades with minimal reduction in poverty rates. The bureaucracy grows while the problem persists.',
    prediction: 'When the people running a program benefit from the problem continuing, the problem will continue. The incentive to solve it is weaker than the incentive to manage it.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.example-card { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.example-card:hover { border-color: var(--ochre); }
.example-card.expanded { border-color: var(--ochre); }
.example-header { display: flex; justify-content: space-between; align-items: center; padding: 0.85rem 1.1rem; }
.example-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.example-toggle { font-size: 1.2rem; color: var(--ochre); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.example-body { padding: 0 1.1rem 1.1rem; }
.example-body p { font-size: 0.85rem; line-height: 1.65; color: var(--ink-muted); margin: 0 0 0.75rem; }
.example-body p:last-child { margin-bottom: 0; }
.example-incentive strong, .example-result strong { color: var(--ink); }
.example-prediction { font-style: italic; color: var(--ink-faint) !important; }
</style>
VUEEOF

echo "  ✓ PredictableResults"

# ══════════════════════════════════════
# SCREEN 5: THE CONTRADICTION
# The mirror moment
# ══════════════════════════════════════

cat > src/components/experiences/exp04/TheContradiction.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The contradiction at the center</p>
    <h2 class="display-medium">The argument for concentrating coercive power requires you to believe two things at once.</h2>
    <Divider />

    <div class="contradictions">
      <div class="contradiction-pair">
        <div class="contradiction-box premise">
          <div class="contradiction-label">What you believe about people</div>
          <p>People are self-interested, short-sighted, and prone to abusing power when they have it.</p>
        </div>
        <div class="contradiction-vs">and yet</div>
        <div class="contradiction-box conclusion">
          <div class="contradiction-label">What the system assumes</div>
          <p>These same people, when given a monopoly on legal force, will use it wisely, restrain themselves voluntarily, and serve the public interest over their own.</p>
        </div>
      </div>
    </div>

    <p class="body-text-large">Voters are too ignorant to make good decisions about their own lives. But politicians, drawn from the same population, are wise enough to make decisions for everyone. People are too selfish to help each other voluntarily. But those same people become public servants the moment they win an election.</p>

    <ContentBlock variant="principle">
      <p>If human beings cannot be trusted to manage their own lives through voluntary cooperation, they certainly cannot be trusted to manage other people's lives through coercive authority. The flaws that make freedom dangerous make power catastrophic.</p>
    </ContentBlock>

    <p class="body-text">You don't need to accept a single claim about human goodness to reach this conclusion. You only need to apply your existing beliefs consistently.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.contradictions { margin: 2rem 0; }
.contradiction-pair { display: flex; flex-direction: column; gap: 0; }
.contradiction-box { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.contradiction-box.premise { background: var(--ochre-faint); border: 1.5px solid var(--ochre); border-bottom: none; border-radius: var(--radius) var(--radius) 0 0; }
.contradiction-box.conclusion { background: var(--concede-bg); border: 1.5px solid var(--concede-warm); border-top: none; border-radius: 0 0 var(--radius) var(--radius); }
.contradiction-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.premise .contradiction-label { color: var(--ochre); }
.conclusion .contradiction-label { color: var(--concede-warm); }
.contradiction-box p { margin: 0; font-size: 0.92rem; line-height: 1.6; }
.premise p { color: var(--ink); }
.conclusion p { color: var(--ink); }
.contradiction-vs { text-align: center; font-family: var(--serif); font-size: 0.85rem; font-style: italic; color: var(--ink-faint); padding: 0.4rem 0; background: var(--paper); position: relative; z-index: 1; }
</style>
VUEEOF

echo "  ✓ TheContradiction"

# ══════════════════════════════════════
# SCREEN 6: THE REFRAME
# The philosophy as the realist position
# ══════════════════════════════════════

cat > src/components/experiences/exp04/TheReframe.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The reframe</p>
    <h2 class="display-medium">The Philosophy of Human Respect is the position that takes human nature seriously.</h2>
    <Divider />

    <p class="body-text-large">The naive position is believing that the same species that produces corruption, regulatory capture, civil forfeiture, and permanent bureaucratic expansion will somehow behave differently when given more power.</p>

    <p class="body-text">The realist position is designing a system around what we actually know about people: they respond to incentives. So the question becomes — what incentive structure produces the best outcomes?</p>

    <div class="comparison">
      <div class="compare-block coercive">
        <div class="compare-label">Coercive systems</div>
        <p>Reward political maneuvering. Externalize costs to people who can't fight back. Concentrate power in the hands of whoever wins the contest to control it. Create a permanent war over who gets to use the machinery of force.</p>
      </div>
      <div class="compare-block voluntary">
        <div class="compare-label">Voluntary systems</div>
        <p>Reward people for serving others well enough that others choose to pay them. Internalize costs to the people who create them. Distribute power across millions of individual decisions. Replace the war for control with competition to earn trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>In voluntary systems, a bad actor can only harm the people who choose to interact with them. In coercive systems, a bad actor with political power can harm millions who never chose to be subject to their authority. The question is not whether bad actors exist. They do. The question is which system limits the damage they can do.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.comparison { margin: 2rem 0; display: flex; flex-direction: column; gap: 1rem; }
.compare-block { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.compare-block p { margin: 0; font-size: 0.9rem; line-height: 1.7; }
.compare-block.coercive { background: var(--concede-bg); border-left: 3px solid var(--concede-warm); }
.compare-block.coercive p { color: var(--ink-muted); }
.compare-block.voluntary { background: var(--insight-bg); border-left: 3px solid var(--insight-green); }
.compare-block.voluntary p { color: var(--ink-muted); }
.compare-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.coercive .compare-label { color: var(--concede-warm); }
.voluntary .compare-label { color: var(--insight-green); }
</style>
VUEEOF

echo "  ✓ TheReframe"

# ══════════════════════════════════════
# SCREEN 7: THE QUESTION — closing
# ══════════════════════════════════════

cat > src/components/experiences/exp04/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">Given what you know about how humans actually behave, which system would you design?</h2>
    <Divider />

    <p class="body-text-large">One where flawed people compete to control the machinery of force — and the losers live under the winners' rules.</p>

    <p class="body-text-large">Or one where flawed people compete to earn each other's trust — and no one has the authority to impose their will on everyone else.</p>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect is not a bet on human goodness. It is a system designed for human beings as they actually are — self-interested, imperfect, and responsive to incentives. It succeeds not by assuming the best in people, but by building a structure where even self-interest produces cooperation instead of exploitation.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Voluntary systems have failure modes too. Free riders. Information asymmetry. Coordination problems. The philosophy does not claim these disappear. It claims that a system where bad actors are limited by the people willing to associate with them produces better outcomes than a system where bad actors can seize the apparatus of legal force and direct it against everyone.</p>
    </ContentBlock>

    <NewsletterSignup variant="minimal" source="exp04_closing" headline="One question per week, applied to the real world." description="A short email examining the incentive structures behind real policies and institutions." button-text="Subscribe" />
    <JourneyNav current="exp04" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ TheQuestion (closing)"

# ══════════════════════════════════════
# ADD ROUTE
# ══════════════════════════════════════

if ! grep -q "human-nature" src/router/index.js 2>/dev/null; then
  sed -i '' "/path: '\/milestone'/i\\
  { path: '/experience/human-nature', name: 'exp04', component: () => import('@/pages/Experience04.vue') },
" src/router/index.js
  echo "  ✓ Route added"
else
  echo "  ✓ Route already exists"
fi

# ══════════════════════════════════════
# ADD ROUTE META
# ══════════════════════════════════════

if ! grep -q "exp04" src/router/meta.js 2>/dev/null; then
  sed -i '' "/milestone:/i\\
  exp04: {\\
    title: 'The Realist Objection — Human Respect',\\
    description: 'People are flawed and self-interested. That turns out to be the strongest argument against giving any of them coercive power over the rest.'\\
  },
" src/router/meta.js
  echo "  ✓ Route meta added"
else
  echo "  ✓ Route meta already exists"
fi

# ══════════════════════════════════════
# UPDATE JOURNEYNAV — add exp04 to the experience list
# ══════════════════════════════════════

# Add exp04 to the allExperiences array in JourneyNav
if ! grep -q "exp04" src/components/shared/JourneyNav.vue 2>/dev/null; then
  sed -i '' "/name: 'exp03'/a\\
  { name: 'exp04', title: 'The Realist Objection', desc: 'People are flawed. That is the strongest argument for voluntary cooperation over concentrated power.', revisitDesc: 'Revisit the incentive argument against coercive systems.', tier: 'foundation', order: 4 },
" src/components/shared/JourneyNav.vue
  echo "  ✓ JourneyNav updated"
else
  echo "  ✓ JourneyNav already has exp04"
fi

# Update pillar order numbers (shift by 1)
sed -i '' "s/tier: 'pillar', order: 4/tier: 'pillar', order: 5/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'pillar', order: 5/tier: 'pillar', order: 6/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'pillar', order: 6/tier: 'pillar', order: 7/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'pillar', order: 7/tier: 'pillar', order: 8/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'pillar', order: 8/tier: 'pillar', order: 9/" src/components/shared/JourneyNav.vue 2>/dev/null
# Fix practice orders too
sed -i '' "s/tier: 'practice', order: 9/tier: 'practice', order: 10/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'practice', order: 10/tier: 'practice', order: 11/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'practice', order: 11/tier: 'practice', order: 12/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'practice', order: 12/tier: 'practice', order: 13/" src/components/shared/JourneyNav.vue 2>/dev/null
sed -i '' "s/tier: 'practice', order: 13/tier: 'practice', order: 14/" src/components/shared/JourneyNav.vue 2>/dev/null

echo "  ✓ Experience order numbers updated"

echo ""
echo "✅ Experience 04: The Realist Objection — built!"
echo ""
echo "Route: /experience/human-nature"
echo "Position: Foundation tier, after Exp03 (before milestone and pillars)"
echo ""
echo "Screens:"
echo "  1. Opening: 'Nice philosophy, but people aren't that good.'"
echo "  2. HumanNature: Interactive — select observed human traits"
echo "  3. TheExperiment: Apply those traits to people with coercive power"
echo "  4. PredictableResults: 5 expandable examples (capture, forfeiture, lobbying, war, dependency)"
echo "  5. TheContradiction: The mirror — two beliefs that can't both be true"
echo "  6. TheReframe: Voluntary systems as the realist position"
echo "  7. TheQuestion: Closing with newsletter + JourneyNav"
echo ""
echo "Analytics captures:"
echo "  - human-nature-traits: which traits the visitor selected"
echo "  - Screen views for drop-off analysis"
echo "  - Completion tracking"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp04: the realist objection' && git push"
