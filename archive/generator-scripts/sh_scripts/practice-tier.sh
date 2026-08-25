#!/bin/bash
# Creates all 5 Practice tier experiences
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/practice01
mkdir -p src/components/experiences/practice02
mkdir -p src/components/experiences/practice03
mkdir -p src/components/experiences/practice04
mkdir -p src/components/experiences/practice05

echo "🏗️  Building Practice Tier (5 experiences)..."

# ══════════════════════════════════════
# ROUTER — complete with all practices
# ══════════════════════════════════════

cat > src/router/index.js << 'JSEOF'
import { createRouter, createWebHistory } from 'vue-router'
import LandingPage from '@/pages/LandingPage.vue'

const routes = [
  { path: '/', name: 'home', component: LandingPage },
  { path: '/experience/the-question', name: 'exp01', component: () => import('@/pages/Experience01.vue') },
  { path: '/experience/the-objection', name: 'exp02', component: () => import('@/pages/Experience02.vue') },
  { path: '/experience/flourishing', name: 'exp03', component: () => import('@/pages/Experience03.vue') },
  { path: '/pillar/your-body-is-not-negotiable', name: 'pillarA', component: () => import('@/pages/PillarA.vue') },
  { path: '/pillar/your-time-is-your-life', name: 'pillarB', component: () => import('@/pages/PillarB.vue') },
  { path: '/pillar/what-you-built', name: 'pillarC', component: () => import('@/pages/PillarC.vue') },
  { path: '/pillar/the-method-is-the-message', name: 'pillarD', component: () => import('@/pages/PillarD.vue') },
  { path: '/pillar/cooperation-is-a-technology', name: 'pillarE', component: () => import('@/pages/PillarE.vue') },
  { path: '/practice/political-footprint', name: 'practice01', component: () => import('@/pages/Practice01.vue') },
  { path: '/practice/persuasion-practice', name: 'practice02', component: () => import('@/pages/Practice02.vue') },
  { path: '/practice/the-conversation', name: 'practice03', component: () => import('@/pages/Practice03.vue') },
  { path: '/practice/respect-audit', name: 'practice04', component: () => import('@/pages/Practice04.vue') },
  { path: '/practice/design-a-solution', name: 'practice05', component: () => import('@/pages/Practice05.vue') },
  { path: '/about', name: 'about', component: () => import('@/pages/AboutPage.vue') },
  { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('@/pages/NotFound.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0 } }
})

export default router
JSEOF

echo "  ✓ Router updated with all practices"

# ══════════════════════════════════════
# HELPER: Reusable page orchestrator factory
# Since all practice pages follow the same pattern,
# we generate them from a template function
# ══════════════════════════════════════

create_practice_page() {
  local NUM=$1
  local IMPORTS=$2
  local COMPONENTS=$3
  local COUNT=$4

  cat > "src/pages/Practice0${NUM}.vue" << VUEEOF
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
import { ref, computed, watch, onUnmounted } from 'vue'

${IMPORTS}

const TOTAL_SCREENS = ${COUNT}
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [${COMPONENTS}]

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
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF
}

# ══════════════════════════════════════════════════════════════
#
#   PRACTICE 01: YOUR POLITICAL FOOTPRINT
#
# ══════════════════════════════════════════════════════════════

create_practice_page 1 \
"import Opening from '@/components/experiences/practice01/Opening.vue'
import TheMapping from '@/components/experiences/practice01/TheMapping.vue'
import TheTotal from '@/components/experiences/practice01/TheTotal.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'" \
"Opening, TheMapping, TheTotal, TheReflection" \
4

echo "  ✓ Practice01.vue"

# ── Opening ──
cat > src/components/experiences/practice01/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Practice · Self-Examination</span>
    <h1 class="display-large headline">Your political<br><em>footprint.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Most of us support more coercion than we realize — not out of malice, but because it's invisible. This exercise makes it visible.</p>
    <button class="begin-btn" @click="$emit('advance')">Begin <span class="arrow">→</span></button>
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
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

# ── TheMapping ──
cat > src/components/experiences/practice01/TheMapping.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Mapping your support for force</p>
    <h2 class="display-medium">Which of these do you currently support?</h2>
    <Divider />
    <p class="body-text">No judgment. This isn't about guilt — it's about seeing clearly. Check each policy you support or benefit from.</p>

    <div class="items">
      <button v-for="item in items" :key="item.id" class="item-card" :class="{ selected: selected.includes(item.id) }" @click="toggle(item.id)">
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
          <span class="item-force">Force used: {{ item.force }}</span>
        </div>
      </button>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const items = [
  { id: 'tax-income', label: 'Income tax', force: 'Compulsory payment backed by imprisonment' },
  { id: 'tax-property', label: 'Property tax', force: 'Pay or lose your home' },
  { id: 'public-school', label: 'Public schools (tax-funded)', force: 'Compulsory funding regardless of use' },
  { id: 'social-security', label: 'Social Security', force: 'Mandatory participation, no opt-out' },
  { id: 'min-wage', label: 'Minimum wage laws', force: 'Criminalizes voluntary agreements below a threshold' },
  { id: 'drug-laws', label: 'Drug prohibition', force: 'Imprisonment for personal choices' },
  { id: 'licensing', label: 'Occupational licensing', force: 'Government permission required to work' },
  { id: 'zoning', label: 'Zoning laws', force: 'Restrictions on how you use your own property' },
  { id: 'military', label: 'Military funding', force: 'Compulsory funding of foreign operations' },
  { id: 'regulations', label: 'Business regulations', force: 'Comply or face fines, closure, imprisonment' },
]

const selected = ref([])
function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.85rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.25s ease; text-align: left; font-family: inherit; font-size: 0.9rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 20px; height: 20px; border: 1.5px solid var(--border-subtle); border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: var(--ochre); margin-top: 1px; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; }
.item-force { display: block; font-size: 0.75rem; color: var(--ink-faint); margin-top: 0.1rem; font-style: italic; }
</style>
VUEEOF

# ── TheTotal ──
cat > src/components/experiences/practice01/TheTotal.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What this reveals</p>
    <h2 class="display-medium">Every check mark is a place where you support using force against peaceful people.</h2>
    <Divider />

    <p class="body-text-large">This isn't meant to make you feel bad. It's meant to make the invisible <em>visible</em>. Most people don't think of these policies as "force" because the force is hidden behind bureaucratic language, payroll deductions, and the normalization of "that's just how things work."</p>

    <ContentBlock variant="mirror">
      <p>But behind every one of those policies is a simple reality: if someone refuses to comply, people with guns will eventually come to enforce it. That's what makes it force rather than cooperation. Not the intention behind it — the mechanism that backs it up.</p>
    </ContentBlock>

    <p class="body-text">The purpose of this exercise isn't to demand you oppose everything you checked. It's to see your political footprint clearly — the total amount of coercion you currently support — so you can make conscious choices about where you want it to shrink.</p>

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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

# ── TheReflection ──
cat > src/components/experiences/practice01/TheReflection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">You don't need to change everything at once. Pick one area where you currently support force and ask yourself: is there a voluntary alternative? Could this be done through persuasion, cooperation, and choice instead of compulsion?</p>

    <ContentBlock variant="insight">
      <p>The path from a coercive society to a cooperative one isn't a revolution. It's a million individual decisions to support persuasion over force, one issue at a time. Your political footprint shrinks one conscious choice at a time.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice02' }">
        <template #title>The Persuasion Practice</template>
        <template #desc>Take an issue you care about and draft a persuasion-only approach.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>See real voluntary alternatives that already work.</template>
      </PathCard>
    </div>
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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice 01: Political Footprint (4 screens)"

# ══════════════════════════════════════════════════════════════
#
#   PRACTICE 02: THE PERSUASION PRACTICE
#
# ══════════════════════════════════════════════════════════════

create_practice_page 2 \
"import Opening from '@/components/experiences/practice02/Opening.vue'
import ChooseYourIssue from '@/components/experiences/practice02/ChooseYourIssue.vue'
import DraftYourApproach from '@/components/experiences/practice02/DraftYourApproach.vue'
import TheChallenge from '@/components/experiences/practice02/TheChallenge.vue'" \
"Opening, ChooseYourIssue, DraftYourApproach, TheChallenge" \
4

echo "  ✓ Practice02.vue"

cat > src/components/experiences/practice02/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Practice · Persuasion</span>
    <h1 class="display-large headline">The persuasion<br><em>practice.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Take something you feel strongly about. Now advance it using zero force. No laws. No mandates. No taxes. Just persuasion, cooperation, and creativity.</p>
    <button class="begin-btn" @click="$emit('advance')">Begin <span class="arrow">→</span></button>
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
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

cat > src/components/experiences/practice02/ChooseYourIssue.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your issue</p>
    <h2 class="display-medium">What issue do you care most about?</h2>
    <Divider />
    <p class="body-text">It could be anything — poverty, education, climate, healthcare, community safety, moral standards, immigration. The more passionately you feel about it, the better this exercise works.</p>
    <textarea class="text-input" v-model="issue" placeholder="Describe the issue you care about most..." rows="4"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!issue.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const issue = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
VUEEOF

cat > src/components/experiences/practice02/DraftYourApproach.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The constraint</p>
    <h2 class="display-medium">Now solve it — with zero coercion.</h2>
    <Divider />
    <p class="body-text-large">No taxes. No regulations. No penalties. No government mandates. Only persuasion, voluntary cooperation, and creative problem-solving.</p>

    <ScenarioBox label="Your tools">
      <p><strong>Conversation</strong> — talking to people, sharing ideas, changing minds through dialogue.</p>
      <p><strong>Voluntary funding</strong> — donations, crowdfunding, subscriptions, membership fees.</p>
      <p><strong>Community organizing</strong> — bringing people together who share the goal.</p>
      <p><strong>Market solutions</strong> — building products or services that address the problem.</p>
      <p><strong>Leading by example</strong> — demonstrating the change you want to see.</p>
    </ScenarioBox>

    <textarea class="text-input" v-model="approach" placeholder="How would you address your issue using only these tools?" rows="6"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!approach.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const approach = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
VUEEOF

cat > src/components/experiences/practice02/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If it was, that's the point. We've been trained to reach for force as the default tool. "There ought to be a law" is the reflex. Designing voluntary solutions requires more creativity, more empathy, and more trust in other people.</p>
    <ContentBlock variant="insight">
      <p>But notice what you just did: you designed an approach that respects everyone involved. No one is forced. No one is threatened. Every participant chose to be there. Whatever you drafted, it's built on cooperation — and that means it's built on trust, which means it's built to last.</p>
    </ContentBlock>
    <ContentBlock variant="principle">
      <p>The next time you hear a political proposal, try this: strip out the force. Imagine the same goal pursued through persuasion alone. What would it take? What would it look like? And is it really impossible — or just unfamiliar?</p>
    </ContentBlock>
    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice03' }">
        <template #title>The Conversation</template>
        <template #desc>A framework for discussing Human Respect with someone who disagrees.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice01' }">
        <template #title>Your Political Footprint</template>
        <template #desc>Map where you currently support coercion in your life.</template>
      </PathCard>
    </div>
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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice 02: Persuasion Practice (4 screens)"

# ══════════════════════════════════════════════════════════════
#
#   PRACTICE 03: THE CONVERSATION
#
# ══════════════════════════════════════════════════════════════

create_practice_page 3 \
"import Opening from '@/components/experiences/practice03/Opening.vue'
import TheFramework from '@/components/experiences/practice03/TheFramework.vue'
import TheExamples from '@/components/experiences/practice03/TheExamples.vue'
import TheInvitation from '@/components/experiences/practice03/TheInvitation.vue'" \
"Opening, TheFramework, TheExamples, TheInvitation" \
4

echo "  ✓ Practice03.vue"

cat > src/components/experiences/practice03/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Practice · Communication</span>
    <h1 class="display-large headline">The<br><em>conversation.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">A framework for discussing the Philosophy of Human Respect with someone who disagrees with you politically — without arguing, converting, or losing the relationship.</p>
    <button class="begin-btn" @click="$emit('advance')">Begin <span class="arrow">→</span></button>
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
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

cat > src/components/experiences/practice03/TheFramework.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The four moves</p>
    <h2 class="display-medium">A conversation, not a debate.</h2>
    <Divider />
    <p class="body-text">The goal isn't to win. It's to plant a question they'll keep thinking about. Four moves, in order.</p>

    <div class="steps">
      <div class="step"><div class="step-num">1</div><div><div class="step-title">Affirm their values</div><p>"I think compassion for the poor is genuinely important" or "I agree that personal responsibility matters." Start where they are, not where you want them to be.</p></div></div>
      <div class="step"><div class="step-num">2</div><div><div class="step-title">Ask the method question</div><p>"We agree on the goal. I'm curious — do you think the best way to achieve it is through government force, or through voluntary cooperation?" Don't answer it for them. Let them sit with it.</p></div></div>
      <div class="step"><div class="step-num">3</div><div><div class="step-title">Introduce the personal test</div><p>"Would you personally do what you're asking the government to do? Would you go to your neighbor's house and take their money for this cause?" If they say no, ask why the government doing it feels different.</p></div></div>
      <div class="step"><div class="step-num">4</div><div><div class="step-title">Leave the question open</div><p>Don't push for agreement. Say: "I don't have all the answers either. But I think that question — force or persuasion — is worth thinking about." Then let it rest.</p></div></div>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.steps { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.step { display: flex; gap: 1rem; align-items: flex-start; }
.step-num { flex-shrink: 0; width: 28px; height: 28px; border-radius: 50%; background: var(--ochre-faint); display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 0.8rem; font-weight: 500; color: var(--ochre); margin-top: 2px; }
.step-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.3rem; }
.step p { font-size: 0.88rem; color: var(--ink-soft); line-height: 1.7; margin: 0; }
</style>
VUEEOF

cat > src/components/experiences/practice03/TheExamples.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What it sounds like</p>
    <h2 class="display-medium">Two examples — one with a progressive, one with a conservative.</h2>
    <Divider />

    <ScenarioBox label="With a progressive friend">
      <p><em>"I care about poverty too. Genuinely. The question I keep coming back to is whether forcing people to fund programs through taxes actually solves it better than encouraging voluntary cooperation. Like, what if instead of taxing people to fund welfare, we made it really easy to give — and really hard for bureaucracies to waste it?"</em></p>
    </ScenarioBox>

    <ScenarioBox label="With a conservative friend">
      <p><em>"I agree that moral standards matter. I just wonder — does legislating morality actually make people more moral? Or does it just make them compliant while resentful? What if the most powerful way to spread good values is to live them and persuade others — instead of forcing them?"</em></p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="What to expect">
      <p>Most people won't agree immediately. That's fine. You're not trying to convert them in one conversation. You're planting a question — force or persuasion? — that will come back to them every time they encounter a political issue. The seed grows on its own.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

cat > src/components/experiences/practice03/TheInvitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The most powerful tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">The most effective thing you can do isn't to explain the philosophy yourself. It's to send someone <strong>Experience 01</strong> — the original thought experiment — and let them discover the gap on their own.</p>
    <ContentBlock variant="insight">
      <p>A conclusion someone reaches themselves is a hundred times more powerful than one you handed them. The thought experiment is designed to create that self-discovery. Your job isn't to argue — it's to share the link and say: "I went through this five-minute thing. Curious what you'd get."</p>
    </ContentBlock>

    <div class="share-block">
      <p class="body-text" style="margin-bottom: 1rem;">Copy the link to share:</p>
      <button class="share-btn" @click="copyLink">{{ copied ? 'Copied!' : 'humanrespect.app → Copy link' }}</button>
    </div>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice04' }">
        <template #title>The Respect Audit</template>
        <template #desc>Track where you choose persuasion vs. force for 7 days.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice02' }">
        <template #title>The Persuasion Practice</template>
        <template #desc>Design a voluntary solution for an issue you care about.</template>
      </PathCard>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
const el = ref(null)
const copied = ref(false)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function copyLink() {
  navigator.clipboard.writeText('https://humanrespect.app').then(() => {
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  })
}
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.share-block { text-align: center; margin: 2rem 0; }
.share-btn { padding: 0.85rem 2rem; background: var(--ochre); color: white; border: none; border-radius: 100px; font-family: var(--sans); font-size: 0.9rem; cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.share-btn:hover { background: var(--ochre-light); transform: translateY(-1px); }
</style>
VUEEOF

echo "  ✓ Practice 03: The Conversation (4 screens)"

# ══════════════════════════════════════════════════════════════
#
#   PRACTICE 04: THE RESPECT AUDIT
#
# ══════════════════════════════════════════════════════════════

create_practice_page 4 \
"import Opening from '@/components/experiences/practice04/Opening.vue'
import HowItWorks from '@/components/experiences/practice04/HowItWorks.vue'
import DayOne from '@/components/experiences/practice04/DayOne.vue'
import TheCommitment from '@/components/experiences/practice04/TheCommitment.vue'" \
"Opening, HowItWorks, DayOne, TheCommitment" \
4

echo "  ✓ Practice04.vue"

cat > src/components/experiences/practice04/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Practice · Awareness</span>
    <h1 class="display-large headline">The respect<br><em>audit.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">For seven days, notice one moment each day where you chose persuasion over force — or where you were tempted to reach for force. That's it. Just notice.</p>
    <button class="begin-btn" @click="$emit('advance')">Begin <span class="arrow">→</span></button>
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
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

cat > src/components/experiences/practice04/HowItWorks.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The practice</p>
    <h2 class="display-medium">Seven days. One observation per day.</h2>
    <Divider />
    <p class="body-text-large">Each day, ask yourself one question before bed:</p>

    <ContentBlock variant="principle">
      <p>Today, was there a moment where I chose persuasion when I could have reached for force? Or a moment where I wished someone would be <em>forced</em> to do what I wanted?</p>
    </ContentBlock>

    <p class="body-text">Force doesn't just mean physical violence. It includes:</p>

    <ScenarioBox label="Forms of force in daily life">
      <p>Wishing a law would make someone behave differently. Wanting a rule to punish someone who annoyed you. Supporting a policy that takes money from people who didn't agree. Hoping authority would compel someone to change. Thinking "there ought to be a law."</p>
    </ScenarioBox>

    <p class="body-text">You don't need to change your behavior. Just <em>notice</em>. Awareness is the first step. The pattern becomes visible only when you start looking for it.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

cat > src/components/experiences/practice04/DayOne.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start now</p>
    <h2 class="display-medium">Your first observation — right now.</h2>
    <Divider />
    <p class="body-text-large">Think about <em>today</em>. Was there a moment — even a small one — where the question of force vs. persuasion was present?</p>
    <p class="body-text">Maybe a conversation about politics. A frustration with a coworker. A news story that made you angry. A parenting moment. A business decision. A thought about what "should" be required.</p>

    <textarea class="text-input" v-model="observation" placeholder="Describe the moment. What happened? Did you lean toward force or persuasion?" rows="5"></textarea>

    <ContentBlock v-if="observation.trim()" variant="insight">
      <p>That's day one. You noticed. Most people go their entire lives without seeing this pattern in their own thinking. You just started.</p>
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
const observation = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
VUEEOF

cat > src/components/experiences/practice04/TheCommitment.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play. You don't need to write it down (though it helps). You just need to notice.</p>

    <ContentBlock variant="insight">
      <p>By the end of seven days, you'll see the force/persuasion question everywhere — in conversations, in the news, in your own impulses. That's not the philosophy talking. That's your own observation, accumulated over a week of paying attention.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect isn't something you adopt in a moment. It's something you discover gradually, as you notice the pattern between force and flourishing in your own daily life.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice05' }">
        <template #title>Design a Voluntary Solution</template>
        <template #desc>Pick a real problem in your community and solve it without force.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice01' }">
        <template #title>Your Political Footprint</template>
        <template #desc>Map the coercion you currently support.</template>
      </PathCard>
    </div>
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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice 04: Respect Audit (4 screens)"

# ══════════════════════════════════════════════════════════════
#
#   PRACTICE 05: DESIGN A VOLUNTARY SOLUTION
#
# ══════════════════════════════════════════════════════════════

create_practice_page 5 \
"import Opening from '@/components/experiences/practice05/Opening.vue'
import IdentifyProblem from '@/components/experiences/practice05/IdentifyProblem.vue'
import DesignSolution from '@/components/experiences/practice05/DesignSolution.vue'
import TheChallenge from '@/components/experiences/practice05/TheChallenge.vue'" \
"Opening, IdentifyProblem, DesignSolution, TheChallenge" \
4

echo "  ✓ Practice05.vue"

cat > src/components/experiences/practice05/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Practice · Construction</span>
    <h1 class="display-large headline">Design a<br><em>voluntary solution.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Pick a real problem in your community — not a national issue, something local and tangible — and design a solution that uses zero coercion.</p>
    <button class="begin-btn" @click="$emit('advance')">Begin <span class="arrow">→</span></button>
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
.begin-btn { display: inline-block; margin-top: 3rem; padding: 1rem 3rem; background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light); border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500; cursor: pointer; transition: all 0.3s ease; -webkit-tap-highlight-color: transparent; }
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

cat > src/components/experiences/practice05/IdentifyProblem.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your community</p>
    <h2 class="display-medium">What's a real problem where you live?</h2>
    <Divider />
    <p class="body-text">Think local. A park that needs maintenance. A neighbor who needs help. A street that's unsafe. A school that's failing. Kids with nothing to do after school. Elderly people who are isolated. A food desert. A housing shortage.</p>
    <p class="body-text">Pick something specific enough to actually address — not "fix inequality" but "the playground on Elm Street is broken and kids have nowhere to play."</p>
    <textarea class="text-input" v-model="problem" placeholder="Describe a real problem in your community..." rows="4"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!problem.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const problem = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
VUEEOF

cat > src/components/experiences/practice05/DesignSolution.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your design</p>
    <h2 class="display-medium">Design a solution using only voluntary means.</h2>
    <Divider />
    <p class="body-text">Consider these questions as you design:</p>

    <div class="prompts">
      <div class="prompt"><strong>Who cares about this problem?</strong> Who else in your community would want to help solve it?</div>
      <div class="prompt"><strong>How would you fund it?</strong> Donations, crowdfunding, business sponsorship, membership fees, bake sales?</div>
      <div class="prompt"><strong>How would you organize it?</strong> A neighborhood group, a nonprofit, an informal coalition, a social media campaign?</div>
      <div class="prompt"><strong>How would you sustain it?</strong> What keeps people engaged and contributing over time?</div>
      <div class="prompt"><strong>What's the first step?</strong> Not the whole plan — just the first action you'd take this week.</div>
    </div>

    <textarea class="text-input" v-model="solution" placeholder="Describe your voluntary solution..." rows="6"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!solution.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const solution = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.prompts { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.75rem; }
.prompt { padding: 0.75rem 1rem; background: var(--cream); border-left: 2px solid var(--ochre); font-size: 0.88rem; color: var(--ink-soft); line-height: 1.6; border-radius: 0 var(--radius) var(--radius) 0; }
.prompt strong { color: var(--ink); }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
VUEEOF

cat > src/components/experiences/practice05/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real question</p>
    <h2 class="display-medium">Will you actually do it?</h2>
    <Divider />
    <p class="body-text-large">You just designed a voluntary solution to a real problem in your community. The philosophy says it can work. The evidence says it can work. The question is whether you'll take the first step.</p>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect isn't proven in arguments. It's proven in action — in the accumulated evidence of millions of people choosing cooperation over coercion, one problem at a time, one community at a time.</p>
    </ContentBlock>

    <ContentBlock variant="insight">
      <p>You don't need permission. You don't need a law. You don't need a government program. You need one conversation with one other person who cares about the same problem. Start there.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore the full philosophy</p>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Start from the beginning</template>
        <template #desc>The thought experiment that started everything.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What Flourishing Means</template>
        <template #desc>The empirical grounding of the philosophy.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>More examples of voluntary solutions already working.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice 05: Design a Voluntary Solution (4 screens)"

echo ""
echo "✅ Practice Tier complete! All 5 experiences built."
echo ""
echo "All practice URLs:"
echo "  /practice/political-footprint    (Practice 01)"
echo "  /practice/persuasion-practice    (Practice 02)"
echo "  /practice/the-conversation       (Practice 03)"
echo "  /practice/respect-audit          (Practice 04)"
echo "  /practice/design-a-solution      (Practice 05)"
echo ""
echo "Push with: git add . && git commit -m 'practice tier: all 5 experiences' && git push"
