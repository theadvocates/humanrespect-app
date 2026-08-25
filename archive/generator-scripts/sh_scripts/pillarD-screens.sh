#!/bin/bash
# Creates Pillar D: "The Method Is the Message" — Values vs. Methods
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/pillarD

echo "🏗️  Building Pillar D: The Method Is the Message..."

# ══════════════════════════════════════
# ROUTE — update router
# ══════════════════════════════════════

cat > src/router/index.js << 'JSEOF'
import { createRouter, createWebHistory } from 'vue-router'
import LandingPage from '@/pages/LandingPage.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: LandingPage
  },
  {
    path: '/experience/the-question',
    name: 'exp01',
    component: () => import('@/pages/Experience01.vue')
  },
  {
    path: '/experience/the-objection',
    name: 'exp02',
    component: () => import('@/pages/Experience02.vue')
  },
  {
    path: '/experience/flourishing',
    name: 'exp03',
    component: () => import('@/pages/Experience03.vue')
  },
  {
    path: '/pillar/your-time-is-your-life',
    name: 'pillarB',
    component: () => import('@/pages/PillarB.vue')
  },
  {
    path: '/pillar/the-method-is-the-message',
    name: 'pillarD',
    component: () => import('@/pages/PillarD.vue')
  },
  {
    path: '/about',
    name: 'about',
    component: () => import('@/pages/AboutPage.vue')
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/pages/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
JSEOF

echo "  ✓ Router updated"

# ══════════════════════════════════════
# VALUES DATA
# ══════════════════════════════════════

cat > src/components/experiences/pillarD/valuesData.js << 'JSEOF'
export const values = [
  {
    id: 'compassion',
    label: 'Compassion for the disadvantaged',
    desc: 'Society should help those who are struggling.',
    lean: 'progressive'
  },
  {
    id: 'equality',
    label: 'Equality of opportunity',
    desc: 'Everyone deserves a fair chance regardless of background.',
    lean: 'progressive'
  },
  {
    id: 'environment',
    label: 'Environmental stewardship',
    desc: 'We have a responsibility to protect the natural world.',
    lean: 'progressive'
  },
  {
    id: 'inclusion',
    label: 'Inclusion and diversity',
    desc: 'All people should be welcomed and respected.',
    lean: 'progressive'
  },
  {
    id: 'responsibility',
    label: 'Personal responsibility',
    desc: 'Individuals should bear the consequences of their choices.',
    lean: 'conservative'
  },
  {
    id: 'family',
    label: 'Strong families and communities',
    desc: 'Stable families are the foundation of a healthy society.',
    lean: 'conservative'
  },
  {
    id: 'tradition',
    label: 'Respect for tradition and heritage',
    desc: 'Time-tested institutions and customs carry wisdom.',
    lean: 'conservative'
  },
  {
    id: 'enterprise',
    label: 'Free enterprise and hard work',
    desc: 'People should be rewarded for effort and ingenuity.',
    lean: 'conservative'
  }
]

export const issues = [
  {
    id: 'poverty',
    label: 'Reducing poverty',
    forceOption: 'Tax the wealthy to fund anti-poverty programs',
    persuadeOption: 'Encourage voluntary charity, mutual aid, and economic opportunity',
    lean: 'progressive'
  },
  {
    id: 'education',
    label: 'Improving education',
    forceOption: 'Mandate public schooling funded by compulsory taxes',
    persuadeOption: 'Let families choose and fund education through voluntary means',
    lean: 'progressive'
  },
  {
    id: 'drugs',
    label: 'Reducing drug abuse',
    forceOption: 'Criminalize drug use and punish offenders',
    persuadeOption: 'Fund voluntary treatment programs and address root causes through community support',
    lean: 'conservative'
  },
  {
    id: 'morality',
    label: 'Maintaining moral standards',
    forceOption: 'Legislate moral behavior and punish violations',
    persuadeOption: 'Lead by example, teach values in families and communities, persuade through culture',
    lean: 'conservative'
  }
]
JSEOF

echo "  ✓ valuesData.js"

# ══════════════════════════════════════
# PAGE ORCHESTRATOR
# ══════════════════════════════════════

cat > src/pages/PillarD.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
          @set-values="handleValues"
          @set-methods="handleMethods"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'

import Opening from '@/components/experiences/pillarD/Opening.vue'
import YourValues from '@/components/experiences/pillarD/YourValues.vue'
import TheMethodQuestion from '@/components/experiences/pillarD/TheMethodQuestion.vue'
import TheMirror from '@/components/experiences/pillarD/TheMirror.vue'
import TheReframe from '@/components/experiences/pillarD/TheReframe.vue'
import TheQuestion from '@/components/experiences/pillarD/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const selectedValues = ref([])
const methodAnswers = ref({})

provide('selectedValues', selectedValues)
provide('methodAnswers', methodAnswers)

const screenComponents = [
  Opening, YourValues, TheMethodQuestion, TheMirror, TheReframe, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function handleValues(vals) { selectedValues.value = vals }
function handleMethods(methods) { methodAnswers.value = methods }
</script>

<style scoped>
.exp-app {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1.5rem;
  transition: background 0.6s ease, color 0.6s ease;
  background: var(--paper);
}
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ PillarD.vue"

# ══════════════════════════════════════
# SCREEN COMPONENTS
# ══════════════════════════════════════

# ── Opening ──
cat > src/components/experiences/pillarD/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · The Human Respect Method</span>
    <h1 class="display-large headline">
      Your values aren't<br><em>the problem.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      Progressive or conservative, your deepest values are genuine expressions of
      what you believe makes life good. The question the Philosophy of Human Respect
      asks isn't <em>what</em> you value — it's how you propose to advance it.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Continue <span class="arrow">→</span>
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
.overline {
  font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--ochre-light); margin-bottom: 2rem; display: block;
}
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle {
  font-family: var(--sans); font-size: 1rem; line-height: 1.8;
  color: rgba(240,235,227,0.65); max-width: 500px; margin: 0 auto;
}
.subtitle em { color: rgba(240,235,227,0.8); }
.begin-btn {
  display: inline-block; margin-top: 3rem; padding: 1rem 3rem;
  background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light);
  border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500;
  cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em;
  -webkit-tap-highlight-color: transparent;
}
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening.vue"

# ── YourValues ──
cat > src/components/experiences/pillarD/YourValues.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you care about</p>
    <h2 class="display-medium">Which of these values resonate with you?</h2>
    <Divider />
    <p class="body-text">There are no wrong answers. All of these are genuine, positive values that guide real people's lives. Select the ones that feel most important to you.</p>

    <div class="values-grid">
      <button
        v-for="v in allValues"
        :key="v.id"
        class="value-card"
        :class="{ selected: selected.includes(v.id) }"
        @click="toggle(v.id)"
      >
        <span class="value-check">{{ selected.includes(v.id) ? '✓' : '' }}</span>
        <div class="value-content">
          <span class="value-label">{{ v.label }}</span>
          <span class="value-desc">{{ v.desc }}</span>
        </div>
      </button>
    </div>

    <ContentBlock v-if="selected.length >= 2" variant="insight">
      <p v-if="hasBoth">You selected values from both progressive and conservative traditions. That's not a contradiction — it's human. Most people hold a mix.</p>
      <p v-else-if="leansProg">Your values lean progressive. That's a genuine expression of what you believe matters. The next question isn't about <em>whether</em> these values are right — it's about <em>how</em> to advance them.</p>
      <p v-else>Your values lean conservative. That's a genuine expression of what you believe matters. The next question isn't about <em>whether</em> these values are right — it's about <em>how</em> to advance them.</p>
    </ContentBlock>

    <NavBar
      :can-go-back="true"
      :disable-continue="selected.length < 2"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { values as allValues } from './valuesData.js'

const emit = defineEmits(['advance', 'back', 'set-values'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selected = ref([])

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
}

const progCount = computed(() => selected.value.filter(id => allValues.find(v => v.id === id)?.lean === 'progressive').length)
const consCount = computed(() => selected.value.filter(id => allValues.find(v => v.id === id)?.lean === 'conservative').length)
const hasBoth = computed(() => progCount.value > 0 && consCount.value > 0)
const leansProg = computed(() => progCount.value > consCount.value)

function emitAndAdvance() {
  emit('set-values', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.values-grid {
  margin: 2rem 0 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.value-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 1rem 1.25rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.value-card:hover { border-color: var(--ochre); box-shadow: var(--shadow-hover); }
.value-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }

.value-check {
  flex-shrink: 0;
  width: 22px; height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.75rem; color: var(--ochre);
  transition: all 0.2s ease; margin-top: 1px;
}

.value-card.selected .value-check {
  background: var(--ochre); border-color: var(--ochre); color: white;
}

.value-content { flex: 1; }
.value-label { display: block; font-weight: 500; color: var(--ink); }
.value-desc { display: block; font-size: 0.8rem; color: var(--ink-muted); margin-top: 0.15rem; }

@media (max-width: 480px) {
  .value-card { padding: 0.85rem 1rem; font-size: 0.9rem; }
}
</style>
VUEEOF

echo "  ✓ YourValues.vue"

# ── TheMethodQuestion ──
cat > src/components/experiences/pillarD/TheMethodQuestion.vue << 'VUEEOF'
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
VUEEOF

echo "  ✓ TheMethodQuestion.vue"

# ── TheMirror ──
cat > src/components/experiences/pillarD/TheMirror.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What your answers reveal</p>
    <h2 class="display-medium">{{ headline }}</h2>
    <Divider />

    <!-- ALL PERSUASION -->
    <template v-if="allPersuasion">
      <ContentBlock variant="insight">
        <p>You chose persuasion for every issue. You already apply the Human Respect Method consistently — you believe society should advance its goals through voluntary cooperation, not force.</p>
      </ContentBlock>
      <p class="body-text-large">This puts you in a minority. Most people choose persuasion for issues where they disagree with the forced approach — and force for issues they care most about. You've avoided that trap.</p>
    </template>

    <!-- ALL FORCE -->
    <template v-else-if="allForce">
      <ContentBlock variant="mirror">
        <p>You chose force for every issue. You believe government compulsion is the right tool for advancing social goals — across the board.</p>
      </ContentBlock>
      <p class="body-text-large">This is at least consistent. But consider: every issue where you chose force, someone who disagrees with your approach is also having force applied to them. They're being compelled to fund and comply with priorities they didn't choose. How would you feel if their priorities — not yours — were the ones being enforced?</p>
    </template>

    <!-- MIXED (most common) -->
    <template v-else>
      <ContentBlock variant="mirror">
        <p>Look at the pattern in your answers.</p>
        <p v-for="issue in mixedResults" :key="issue.id" style="margin-top: 0.5rem;">
          <strong>{{ issue.label }}:</strong> you chose {{ issue.answer === 'force' ? 'force' : 'persuasion' }}
        </p>
      </ContentBlock>

      <p class="body-text-large">{{ mixedInsight }}</p>

      <ContentBlock variant="insight">
        <p>This is the pattern the Philosophy of Human Respect is designed to reveal. Most people want <em>their</em> values advanced by whatever means necessary — and <em>other people's</em> values advanced only through persuasion. But you can't have it both ways. If you claim the right to force your priorities on others, you've given them the right to force theirs on you.</p>
      </ContentBlock>
    </template>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { issues as allIssues } from './valuesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const methodAnswers = inject('methodAnswers', ref({}))

const forceCount = computed(() => Object.values(methodAnswers.value).filter(v => v === 'force').length)
const persuadeCount = computed(() => Object.values(methodAnswers.value).filter(v => v === 'persuade').length)
const allPersuasion = computed(() => forceCount.value === 0)
const allForce = computed(() => persuadeCount.value === 0)

const headline = computed(() => {
  if (allPersuasion.value) return 'You\'re already consistent.'
  if (allForce.value) return 'You trust force across the board.'
  return 'You chose force for some — and persuasion for others.'
})

const mixedResults = computed(() => {
  return allIssues.map(issue => ({
    id: issue.id,
    label: issue.label,
    answer: methodAnswers.value[issue.id]
  }))
})

const mixedInsight = computed(() => {
  const forceIssues = allIssues.filter(i => methodAnswers.value[i.id] === 'force')
  const persuadeIssues = allIssues.filter(i => methodAnswers.value[i.id] === 'persuade')

  if (forceIssues.every(i => i.lean === 'progressive') && persuadeIssues.every(i => i.lean === 'conservative')) {
    return 'You chose force for progressive goals and persuasion for conservative ones. In other words: you want the government to enforce the values you agree with, but not the ones you don\'t.'
  }
  if (forceIssues.every(i => i.lean === 'conservative') && persuadeIssues.every(i => i.lean === 'progressive')) {
    return 'You chose force for conservative goals and persuasion for progressive ones. In other words: you want the government to enforce the values you agree with, but not the ones you don\'t.'
  }
  return 'Notice which issues you chose force for and which you chose persuasion. Is there a pattern? Most people choose force for the goals they care about most — and persuasion for the goals they\'re less invested in.'
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ TheMirror.vue"

# ── TheReframe ──
cat > src/components/experiences/pillarD/TheReframe.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The shift</p>
    <h2 class="display-medium">What if everyone committed to persuasion — regardless of their values?</h2>
    <Divider />

    <p class="body-text-large">Imagine two societies. Same people. Same values. Same diversity of opinion. The only difference is the <em>method</em>.</p>

    <div class="comparison">
      <div class="society society-force">
        <div class="society-label">Society A: Force</div>
        <p>Everyone tries to capture political power and use it to impose their values on everyone else. Elections become winner-take-all battles. Whoever wins forces the losers to fund and follow policies they oppose.</p>
        <div class="society-result">Result: Permanent conflict. Resentment. Culture wars. Every election is an existential threat. Trust erodes. Cooperation collapses.</div>
      </div>

      <div class="society society-persuade">
        <div class="society-label">Society B: Persuasion</div>
        <p>Everyone holds their values just as deeply — but commits to advancing them only through conversation, example, voluntary cooperation, and creative problem-solving. No one forces anyone.</p>
        <div class="society-result">Result: Diversity without conflict. People with different values coexist, learn from each other, and cooperate on shared goals. Trust grows. Innovation flourishes.</div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>The values stay exactly the same. Only the method changes. And that single change — from force to persuasion — transforms a conflict machine into a cooperation machine.</p>
    </ContentBlock>

    <p class="body-text">This is the core insight of the Human Respect Method: the moral legitimacy of a social system depends not on the values it promotes, but on the methods it uses. You can hold any values and still commit to advancing them through persuasion alone.</p>

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

.comparison {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.society {
  padding: 1.5rem;
  border-radius: var(--radius);
  border: 1.5px solid var(--border-subtle);
}

.society-force {
  background: var(--concede-bg);
  border-color: var(--concede-warm);
}

.society-persuade {
  background: var(--insight-bg);
  border-color: var(--insight-green);
}

.society-label {
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.society-force .society-label { color: var(--concede-warm); }
.society-persuade .society-label { color: var(--insight-green); }

.society p {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--ink-soft);
  margin: 0;
}

.society-result {
  margin-top: 0.75rem;
  font-size: 0.85rem;
  font-style: italic;
}

.society-force .society-result { color: var(--concede-warm); }
.society-persuade .society-result { color: var(--insight-green); }

@media (max-width: 480px) {
  .society { padding: 1.25rem; }
}
</style>
VUEEOF

echo "  ✓ TheReframe.vue"

# ── TheQuestion ──
cat > src/components/experiences/pillarD/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />

    <p class="body-text-large">Not because your values don't matter. Not because the issues aren't urgent. But because the method matters as much as the goal — and because a world of mutual persuasion produces more flourishing than a world of mutual coercion.</p>

    <ContentBlock variant="principle">
      <p>Can you hold your deepest values while committing never to force them on another person? And if you can — what would that actually look like in your life, your community, and your politics?</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>This is hard. Genuinely hard. When you care deeply about an issue — poverty, education, moral standards, the environment — the temptation to use force is powerful. "If only we could make everyone do the right thing." But the Philosophy of Human Respect asks you to trust that persuasion, voluntary cooperation, and creative problem-solving will produce better outcomes than coercion — even for the causes you care about most.</p>
    </ContentBlock>

    <p class="body-text">The political wars of our era are not really about values. They're about method. And the moment enough people commit to persuasion over force, the war ends — not because everyone agrees, but because no one is trying to compel agreement anymore.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>Why time is the most fundamental human resource — and what that means for every form of coercion.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What Flourishing Actually Means</template>
        <template #desc>The six pillars of well-being and three domains of human integrity.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>The Original Question</template>
        <template #desc>Where it all started — the thought experiment that reveals the gap.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ TheQuestion.vue"

# ══════════════════════════════════════
# UPDATE EXP03 BRIDGE — link to Pillar D
# ══════════════════════════════════════

cat > src/components/experiences/exp03/TheBridge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">You now have the complete framework.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div>
          <div class="foundation-title">The gap</div>
          <p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div>
          <div class="foundation-title">The objection</div>
          <p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div>
          <div class="foundation-title">The grounding</div>
          <p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time. Coercion violates all three.</p>
        </div>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">From here, the philosophy goes deeper. Each dimension has implications that reshape how you think about justice, economics, community, and the role of institutions in human life.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Go deeper</p>

      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The philosophy's most original insight: time is the irreplaceable substance of life, and every form of coercion is ultimately a theft of time.</template>
      </PathCard>

      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Your values aren't the problem — progressive or conservative, they're both genuine. The question is whether you advance them through persuasion or force.</template>
      </PathCard>

      <PathCard :to="{ name: 'home' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Voluntary cooperation isn't just morally superior to coercion — it's more effective. Real examples of people solving "impossible" problems without force. Coming soon.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Or revisit</p>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Experience 01: The Question</template>
        <template #desc>The thought experiment that started it all.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>Experience 02: The Objection</template>
        <template #desc>Your strongest pushback, honestly examined.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.foundation-summary {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.foundation-item {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.foundation-number {
  flex-shrink: 0;
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--ochre);
  margin-top: 0.15rem;
}

.foundation-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.2rem;
}

.foundation-desc {
  font-size: 0.88rem;
  color: var(--ink-muted);
  line-height: 1.6;
  margin: 0;
}
</style>
VUEEOF

echo "  ✓ TheBridge.vue updated with Pillar B + D links"

echo ""
echo "✅ Pillar D complete!"
echo ""
echo "Files created/updated:"
echo "  src/router/index.js (added /pillar/the-method-is-the-message)"
echo "  src/pages/PillarD.vue"
echo "  src/components/experiences/pillarD/valuesData.js"
echo "  src/components/experiences/pillarD/Opening.vue"
echo "  src/components/experiences/pillarD/YourValues.vue"
echo "  src/components/experiences/pillarD/TheMethodQuestion.vue"
echo "  src/components/experiences/pillarD/TheMirror.vue"
echo "  src/components/experiences/pillarD/TheReframe.vue"
echo "  src/components/experiences/pillarD/TheQuestion.vue"
echo "  src/components/experiences/exp03/TheBridge.vue (updated)"
echo ""
echo "Push with: git add . && git commit -m 'pillar D: the method is the message' && git push"
