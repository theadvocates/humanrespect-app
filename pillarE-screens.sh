#!/bin/bash
# Creates Pillar E: "Cooperation Is a Technology"
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/pillarE

echo "🏗️  Building Pillar E: Cooperation Is a Technology..."

# ══════════════════════════════════════
# ROUTE
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
    path: '/pillar/cooperation-is-a-technology',
    name: 'pillarE',
    component: () => import('@/pages/PillarE.vue')
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
# EXAMPLES DATA
# ══════════════════════════════════════

cat > src/components/experiences/pillarE/examplesData.js << 'JSEOF'
export const examples = [
  {
    id: 'knowledge',
    name: 'Wikipedia',
    what: 'The largest encyclopedia in human history',
    how: 'Entirely volunteer-written and donation-funded. No government mandate. No compulsory participation. 60+ million articles in 300+ languages.',
    assumption: '"You can\'t create reliable public knowledge without institutional funding and professional oversight."',
    reality: 'Voluntary contributors produce and maintain more accurate, more comprehensive, and more current information than any state-funded encyclopedia ever did.'
  },
  {
    id: 'software',
    name: 'Open-source software',
    what: 'The infrastructure that runs the internet',
    how: 'Linux, Apache, Python, Firefox, WordPress — created by volunteers and voluntary organizations. No one was forced to contribute. The result powers the majority of the world\'s servers.',
    assumption: '"Critical infrastructure requires centralized control and compulsory funding."',
    reality: 'The most reliable, secure, and innovative infrastructure on earth was built by people who chose to build it.'
  },
  {
    id: 'disaster',
    name: 'Volunteer disaster response',
    what: 'Faster and more effective than government in crisis',
    how: 'The Cajun Navy during Hurricane Harvey. Volunteer firefighters protecting 70% of US communities. Mutual aid networks during COVID. Community organizations consistently arrive before FEMA.',
    assumption: '"Only government can coordinate large-scale emergency response."',
    reality: 'Voluntary networks are consistently faster, more adaptive, and more personally responsive than bureaucratic agencies.'
  },
  {
    id: 'arbitration',
    name: 'Private arbitration',
    what: 'Dispute resolution without government courts',
    how: 'Billions of dollars in commercial disputes resolved annually through voluntary arbitration. Faster, cheaper, and more satisfactory to both parties than the court system.',
    assumption: '"Justice requires government courts backed by state power."',
    reality: 'When both parties voluntarily agree to a process, resolution is faster, less adversarial, and more likely to preserve relationships.'
  },
  {
    id: 'charity',
    name: 'Private philanthropy',
    what: 'Voluntary generosity at scale',
    how: 'Americans voluntarily donated $557 billion in 2023. Community foundations, mutual aid societies, GoFundMe campaigns, religious charities — all funded by choice, not compulsion.',
    assumption: '"Without forced redistribution, the poor would be abandoned."',
    reality: 'Voluntary generosity has existed in every culture in history and consistently grows when people feel economically secure and socially connected.'
  }
]

export const appliedIssues = [
  {
    id: 'education',
    label: 'Education',
    problem: 'Many children receive inadequate education, especially in disadvantaged communities.',
    forceSolution: 'Compulsory public schooling funded by property taxes.',
    voluntaryApproaches: [
      'Scholarship funds and community-sponsored tuition',
      'Homeschool cooperatives and microschools',
      'Free online learning platforms (Khan Academy, MIT OpenCourseWare)',
      'Apprenticeship programs funded by businesses who benefit',
      'Neighborhood learning pods with volunteer mentors'
    ]
  },
  {
    id: 'healthcare',
    label: 'Healthcare',
    problem: 'Healthcare is expensive and inaccessible for many people.',
    forceSolution: 'Government-mandated insurance funded by taxes.',
    voluntaryApproaches: [
      'Health-sharing ministries and mutual aid health cooperatives',
      'Direct primary care (monthly subscription, no insurance middleman)',
      'Community health centers funded by donations and user fees',
      'Medical mission organizations and free clinics',
      'Transparent pricing and cross-border competition'
    ]
  },
  {
    id: 'poverty',
    label: 'Poverty',
    problem: 'People fall into cycles of poverty that are difficult to escape.',
    forceSolution: 'Tax-funded welfare programs with eligibility requirements.',
    voluntaryApproaches: [
      'Mutual aid societies (historically provided insurance, healthcare, and support)',
      'Microfinance and community lending circles',
      'Job training programs funded by employers and philanthropists',
      'Religious and secular charity with personal relationships',
      'Removing regulatory barriers that prevent poor people from starting businesses'
    ]
  },
  {
    id: 'environment',
    label: 'Environment',
    problem: 'Industrial activity damages ecosystems and threatens public health.',
    forceSolution: 'Government regulations and penalties for pollution.',
    voluntaryApproaches: [
      'Land trusts and conservation easements (voluntary preservation)',
      'Consumer pressure and boycotts driving corporate change',
      'Private certification systems (organic, fair trade, B Corp)',
      'Common-law tort remedies — polluters pay damages to those they harm',
      'Community-owned renewable energy cooperatives'
    ]
  },
  {
    id: 'safety',
    label: 'Community safety',
    problem: 'Crime threatens people\'s safety and property.',
    forceSolution: 'Government police forces funded by taxes.',
    voluntaryApproaches: [
      'Neighborhood watch and community patrol programs',
      'Private security funded by neighborhood associations',
      'Restorative justice circles that repair harm rather than punish',
      'Mediation services for disputes before they escalate',
      'Community investment in root causes — opportunity, connection, purpose'
    ]
  }
]
JSEOF

echo "  ✓ examplesData.js"

# ══════════════════════════════════════
# PAGE ORCHESTRATOR
# ══════════════════════════════════════

cat > src/pages/PillarE.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @set-issue="handleIssue"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'

import Opening from '@/components/experiences/pillarE/Opening.vue'
import TheEvidence from '@/components/experiences/pillarE/TheEvidence.vue'
import WhyItWorks from '@/components/experiences/pillarE/WhyItWorks.vue'
import DesignYourOwn from '@/components/experiences/pillarE/DesignYourOwn.vue'
import VoluntaryAlternatives from '@/components/experiences/pillarE/VoluntaryAlternatives.vue'
import TheQuestion from '@/components/experiences/pillarE/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const chosenIssue = ref(null)

provide('chosenIssue', chosenIssue)

const screenComponents = [
  Opening, TheEvidence, WhyItWorks, DesignYourOwn, VoluntaryAlternatives, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${chosenIssue.value}`)

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

function handleIssue(id) { chosenIssue.value = id }
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

echo "  ✓ PillarE.vue"

# ══════════════════════════════════════
# SCREEN COMPONENTS
# ══════════════════════════════════════

# ── Opening ──
cat > src/components/experiences/pillarE/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · Voluntary Cooperation</span>
    <h1 class="display-large headline">
      Cooperation is<br><em>a technology.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      Voluntary cooperation isn't just morally superior to coercion. It's more
      effective. More adaptive. More innovative. And it's already solving
      problems that people assume require force — at enormous scale.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      See the evidence <span class="arrow">→</span>
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
.subtitle { font-family: var(--sans); font-size: 1rem; line-height: 1.8; color: rgba(240,235,227,0.65); max-width: 500px; margin: 0 auto; }
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening.vue"

# ── TheEvidence ──
cat > src/components/experiences/pillarE/TheEvidence.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Already happening</p>
    <h2 class="display-medium">Voluntary cooperation is solving "impossible" problems right now.</h2>
    <Divider />

    <p class="body-text">Each of these was once assumed to require compulsory funding, centralized control, or government mandates. Each one was solved by people who chose to cooperate.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card">
        <div class="example-header">
          <div class="example-name">{{ ex.name }}</div>
          <div class="example-what">{{ ex.what }}</div>
        </div>
        <p class="example-how">{{ ex.how }}</p>
        <div class="example-assumption">
          <span class="assumption-label">The assumption:</span>
          <span v-html="ex.assumption"></span>
        </div>
        <div class="example-reality">
          <span class="reality-label">The reality:</span>
          {{ ex.reality }}
        </div>
      </div>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { examples } from './examplesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }

.example-card {
  padding: 1.5rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
  box-shadow: var(--shadow-soft);
}

.example-header { margin-bottom: 0.75rem; }

.example-name {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
}

.example-what {
  font-size: 0.8rem;
  color: var(--ink-muted);
  margin-top: 0.1rem;
}

.example-how {
  font-size: 0.88rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0 0 0.75rem 0;
}

.example-assumption {
  font-size: 0.82rem;
  color: var(--concede-warm);
  line-height: 1.6;
  padding: 0.6rem 0.85rem;
  background: var(--concede-bg);
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.assumption-label {
  font-weight: 600;
  display: block;
  font-size: 0.7rem;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 0.2rem;
}

.example-reality {
  font-size: 0.82rem;
  color: var(--insight-green);
  line-height: 1.6;
  padding: 0.6rem 0.85rem;
  background: var(--insight-bg);
  border-radius: 4px;
}

.reality-label {
  font-weight: 600;
  display: block;
  font-size: 0.7rem;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 0.2rem;
}

@media (max-width: 480px) {
  .example-card { padding: 1.25rem; }
}
</style>
VUEEOF

echo "  ✓ TheEvidence.vue"

# ── WhyItWorks ──
cat > src/components/experiences/pillarE/WhyItWorks.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The mechanism</p>
    <h2 class="display-medium">Why voluntary cooperation outperforms coercion.</h2>
    <Divider />

    <p class="body-text-large">This isn't idealism. There are structural reasons why voluntary systems produce better outcomes than coercive ones.</p>

    <div class="mechanisms">
      <div class="mechanism">
        <div class="mechanism-name">Feedback loops</div>
        <p>Voluntary systems get immediate feedback. If a voluntary school is bad, families leave. If a voluntary charity wastes money, donors stop giving. Coercive systems insulate providers from consequences — bad government schools keep getting funded regardless.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Accountability</div>
        <p>When participation is voluntary, providers must earn trust continuously. When participation is compulsory, providers can afford to be unresponsive. This is why the DMV experience differs from the Apple Store experience.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Innovation pressure</div>
        <p>Competition between voluntary solutions drives constant improvement. Monopolies — whether corporate or governmental — stagnate. The reason open-source software evolves faster than government IT systems is the same reason markets outperform central planning.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Trust-building</div>
        <p>Coercion erodes trust. Cooperation builds it. Every successful voluntary interaction strengthens the social fabric. Every act of compulsion weakens it. Over time, this difference compounds dramatically.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Adaptation</div>
        <p>Voluntary systems are distributed and adaptive — thousands of approaches tested simultaneously, with successful ones spreading naturally. Coercive systems are centralized and rigid — one approach mandated for everyone, changed only through political battle.</p>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>Cooperation isn't just a moral preference. It's a technology for producing human flourishing — in the same category as language, markets, and communication networks. It works better because it's aligned with human nature rather than fighting against it.</p>
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

.mechanisms { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }

.mechanism {
  padding: 1.25rem 1.5rem;
  background: var(--cream);
  border-left: 3px solid var(--insight-green);
  border-radius: 0 var(--radius) var(--radius) 0;
}

.mechanism-name {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.4rem;
}

.mechanism p {
  font-size: 0.88rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

@media (max-width: 480px) {
  .mechanism { padding: 1rem 1.25rem; }
}
</style>
VUEEOF

echo "  ✓ WhyItWorks.vue"

# ── DesignYourOwn ──
cat > src/components/experiences/pillarE/DesignYourOwn.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your turn</p>
    <h2 class="display-medium">Pick a problem you care about.</h2>
    <Divider />

    <p class="body-text-large">The real test of any philosophy is whether it works when applied to the issues that matter to you. Choose one.</p>

    <div class="issues">
      <button
        v-for="issue in appliedIssues"
        :key="issue.id"
        class="issue-btn"
        :class="{ selected: chosen === issue.id }"
        @click="choose(issue.id)"
      >
        {{ issue.label }}
      </button>
    </div>

    <div v-if="chosenIssueData" class="issue-detail">
      <ScenarioBox label="The problem">
        <p>{{ chosenIssueData.problem }}</p>
      </ScenarioBox>

      <ContentBlock variant="mirror" label="The conventional approach (force)">
        <p>{{ chosenIssueData.forceSolution }}</p>
      </ContentBlock>

      <p class="body-text">Before we show you what voluntary alternatives look like, take a moment: can you think of a way to address this problem through persuasion and voluntary cooperation alone? No taxes. No mandates. No penalties. Just people choosing to help.</p>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosen"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { appliedIssues } from './examplesData.js'

const emit = defineEmits(['advance', 'back', 'set-issue'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const chosen = ref(null)
const chosenIssueData = computed(() => appliedIssues.find(i => i.id === chosen.value))

function choose(id) { chosen.value = id }

function emitAndAdvance() {
  emit('set-issue', chosen.value)
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.issues {
  margin: 2rem 0;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.issue-btn {
  padding: 0.65rem 1.25rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink-soft);
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}

.issue-btn:hover { border-color: var(--ochre); color: var(--ink); }
.issue-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }

.issue-detail { margin-top: 1rem; }
</style>
VUEEOF

echo "  ✓ DesignYourOwn.vue"

# ── VoluntaryAlternatives ──
cat > src/components/experiences/pillarE/VoluntaryAlternatives.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What already exists</p>
    <h2 class="display-medium">Voluntary approaches to {{ issueData?.label?.toLowerCase() }} — already working.</h2>
    <Divider />

    <p class="body-text-large">These aren't theoretical. Each of these approaches exists right now, somewhere in the world, producing real results without coercion.</p>

    <div v-if="issueData" class="alternatives">
      <div v-for="(approach, i) in issueData.voluntaryApproaches" :key="i" class="alternative-item">
        <span class="alt-number">{{ String(i + 1).padStart(2, '0') }}</span>
        <span class="alt-text">{{ approach }}</span>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Notice what these have in common: every participant chose to be there. Every dollar was given voluntarily. Every provider must earn continued support through results. And every solution can be improved, adapted, or replaced without a political battle.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Voluntary alternatives to {{ issueData?.label?.toLowerCase() }} are not yet as large-scale or well-funded as their government counterparts. This is partly because government programs crowd out voluntary alternatives — when people are already taxed for a service, they're less likely to fund it voluntarily too. The question isn't whether voluntary approaches are currently as big, but whether they <em>could</em> grow to meet the need if the compulsory alternatives were gradually phased out.</p>
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
import { appliedIssues } from './examplesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const chosenIssue = inject('chosenIssue', ref(null))
const issueData = computed(() => appliedIssues.find(i => i.id === chosenIssue.value))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.alternatives {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.alternative-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
}

.alt-number {
  flex-shrink: 0;
  font-family: var(--serif);
  font-size: 0.85rem;
  color: var(--ochre);
  margin-top: 0.1rem;
}

.alt-text {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.6;
}

@media (max-width: 480px) {
  .alternative-item { padding: 0.85rem 1rem; }
}
</style>
VUEEOF

echo "  ✓ VoluntaryAlternatives.vue"

# ── TheQuestion ──
cat > src/components/experiences/pillarE/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />

    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies. It resolves billions in disputes, funds hundreds of billions in charitable giving, and sustains communities across the globe.</p>

    <ContentBlock variant="principle">
      <p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p>
    </ContentBlock>

    <p class="body-text">Every social problem that seems to "require" government force was once solved — or is currently being solved — by people who chose to cooperate. The question isn't whether voluntary solutions are possible. It's whether we'll give them the space to grow.</p>

    <ContentBlock variant="insight">
      <p>The Philosophy of Human Respect doesn't claim that voluntary cooperation will solve every problem overnight. It claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity. And it asks: given the evidence, which trajectory do you want to be on?</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>Why time is the most fundamental human resource — and what coercion really costs.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>The question isn't what you value — it's how you propose to advance it.</template>
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
# UPDATE EXP03 BRIDGE — all pillars live
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

      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Voluntary cooperation isn't just morally superior to coercion — it's more effective. Real examples of people solving "impossible" problems without force.</template>
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

.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.foundation-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
</style>
VUEEOF

echo "  ✓ TheBridge.vue — all three pillars now live"

echo ""
echo "✅ Pillar E complete!"
echo ""
echo "Files created/updated:"
echo "  src/router/index.js (added /pillar/cooperation-is-a-technology)"
echo "  src/pages/PillarE.vue"
echo "  src/components/experiences/pillarE/examplesData.js"
echo "  src/components/experiences/pillarE/Opening.vue"
echo "  src/components/experiences/pillarE/TheEvidence.vue"
echo "  src/components/experiences/pillarE/WhyItWorks.vue"
echo "  src/components/experiences/pillarE/DesignYourOwn.vue"
echo "  src/components/experiences/pillarE/VoluntaryAlternatives.vue"
echo "  src/components/experiences/pillarE/TheQuestion.vue"
echo "  src/components/experiences/exp03/TheBridge.vue (all pillars live)"
echo ""
echo "Push with: git add . && git commit -m 'pillar E: cooperation is a technology' && git push"
