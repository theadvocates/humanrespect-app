#!/bin/bash
# Creates Pillar A: "Your Body Is Not Negotiable" (Bodily Integrity)
# and Pillar C: "What You Built Is Who You Were" (Material Integrity)
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/pillarA
mkdir -p src/components/experiences/pillarC

echo "🏗️  Building Pillars A + C..."

# ══════════════════════════════════════
# ROUTER — all pillars
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
    path: '/pillar/your-body-is-not-negotiable',
    name: 'pillarA',
    component: () => import('@/pages/PillarA.vue')
  },
  {
    path: '/pillar/your-time-is-your-life',
    name: 'pillarB',
    component: () => import('@/pages/PillarB.vue')
  },
  {
    path: '/pillar/what-you-built',
    name: 'pillarC',
    component: () => import('@/pages/PillarC.vue')
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

echo "  ✓ Router updated with all pillars"

# ══════════════════════════════════════════════════════════════
#
#   PILLAR A: "YOUR BODY IS NOT NEGOTIABLE"
#
# ══════════════════════════════════════════════════════════════

cat > src/pages/PillarA.vue << 'VUEEOF'
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

import Opening from '@/components/experiences/pillarA/Opening.vue'
import TheMemory from '@/components/experiences/pillarA/TheMemory.vue'
import TheCascade from '@/components/experiences/pillarA/TheCascade.vue'
import TrustInfrastructure from '@/components/experiences/pillarA/TrustInfrastructure.vue'
import ConsentBoundary from '@/components/experiences/pillarA/ConsentBoundary.vue'
import TheQuestion from '@/components/experiences/pillarA/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheMemory, TheCascade, TrustInfrastructure, ConsentBoundary, TheQuestion
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

echo "  ✓ PillarA.vue"

# ── A: Opening ──
cat > src/components/experiences/pillarA/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · Bodily Integrity</span>
    <h1 class="display-large headline">Your body is<br><em>not negotiable.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Before you can dream, create, build, cooperate, or love — you must be safe in your own skin. Bodily integrity is the first domain of human flourishing, and the most viscerally understood.</p>
    <button class="begin-btn" @click="$emit('advance')">Continue <span class="arrow">→</span></button>
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

echo "  ✓ A: Opening.vue"

# ── A: TheMemory ──
cat > src/components/experiences/pillarA/TheMemory.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your own experience</p>
    <h2 class="display-medium">Recall a time you felt physically unsafe.</h2>
    <Divider />
    <p class="body-text-large">Not necessarily violence — even the <em>credible possibility</em> of harm. A dark street. A threatening person. A moment where your body told you something was wrong.</p>
    <p class="body-text">You don't need to share the details. Just hold that memory and notice what happened to your thinking.</p>

    <ScenarioBox label="What your brain did">
      <p>When the amygdala senses threat, it triggers a cascade: cortisol floods the system, the prefrontal cortex — the part responsible for creativity, empathy, planning, and problem-solving — goes partially offline. Your world narrows to the immediate threat.</p>
      <p>This isn't weakness. It's biology. The nervous system is designed to prioritize survival over flourishing. But the cost is real: in that state, you cannot create, cooperate, plan, or connect. You can only react.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>This is why bodily safety isn't just one nice thing among many. It is the precondition for all other forms of flourishing. Without it, the brain literally cannot enter the states that support growth, creativity, trust, or meaning.</p>
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

echo "  ✓ A: TheMemory.vue"

# ── A: TheCascade ──
cat > src/components/experiences/pillarA/TheCascade.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The social cascade</p>
    <h2 class="display-medium">Violence doesn't just break bones. It breaks trust.</h2>
    <Divider />
    <p class="body-text-large">A single act of aggression ripples outward through an entire community. Understanding this cascade reveals why bodily integrity is a social issue, not just a personal one.</p>

    <div class="cascade">
      <div class="cascade-step">
        <div class="cascade-num">1</div>
        <div>
          <div class="cascade-title">Violence occurs</div>
          <p>A person is harmed — or credibly threatened with harm.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">2</div>
        <div>
          <div class="cascade-title">Fear spreads</div>
          <p>Not just the victim — witnesses, neighbors, and the wider community begin to feel unsafe. Chronic vigilance replaces relaxed openness.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">3</div>
        <div>
          <div class="cascade-title">Trust collapses</div>
          <p>People withdraw from public spaces, stop helping strangers, lock doors, avoid engagement. The invisible infrastructure of cooperation erodes.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">4</div>
        <div>
          <div class="cascade-title">Cooperation declines</div>
          <p>Without trust, voluntary cooperation becomes rare. People stop sharing resources, investing in shared goods, or working together on common problems.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">5</div>
        <div>
          <div class="cascade-title">Prosperity stagnates</div>
          <p>Without cooperation, innovation slows, economic activity contracts, and the community's capacity to solve problems diminishes. Everyone is poorer — materially and socially.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>This is why societies with high levels of violence are invariably poor, while the most prosperous societies are those where physical safety is the norm. The relationship isn't coincidental — it's causal. Safety produces trust, trust produces cooperation, cooperation produces prosperity.</p>
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
.cascade { margin: 2rem 0; }
.cascade-step { display: flex; gap: 1rem; align-items: flex-start; }
.cascade-num { flex-shrink: 0; width: 28px; height: 28px; border-radius: 50%; background: var(--ochre-faint); display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 0.8rem; font-weight: 500; color: var(--ochre); margin-top: 2px; }
.cascade-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.cascade-step p { font-size: 0.88rem; color: var(--ink-soft); line-height: 1.6; margin: 0; }
.cascade-arrow { text-align: center; color: var(--ink-faint); font-size: 0.85rem; padding: 0.4rem 0; padding-left: 8px; }
</style>
VUEEOF

echo "  ✓ A: TheCascade.vue"

# ── A: TrustInfrastructure ──
cat > src/components/experiences/pillarA/TrustInfrastructure.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The invisible infrastructure</p>
    <h2 class="display-medium">Trust is the most valuable thing a society produces.</h2>
    <Divider />

    <p class="body-text-large">Trust is invisible — like oxygen. You don't notice it until it's gone. But every exchange, relationship, agreement, and institution depends on it.</p>

    <p class="body-text">In high-trust environments, people share openly, communities self-organize, social innovation accelerates, conflict shrinks, and prosperity becomes possible. In low-trust environments, every interaction carries friction — suspicion, verification, protection, litigation.</p>

    <ContentBlock variant="insight">
      <p>Trust reduces the <em>cost</em> of cooperation. When you trust the people around you, collaboration is effortless. When you don't, every joint action requires contracts, enforcement, surveillance, and overhead. This is why high-trust societies are wealthier — not because they have more resources, but because cooperation is cheaper.</p>
    </ContentBlock>

    <p class="body-text">And trust cannot coexist with violence. A single act of aggression can destroy relationships, families, neighborhoods, or entire communities. Violence doesn't just break bones — it breaks the invisible infrastructure that makes cooperation possible.</p>

    <ContentBlock variant="principle">
      <p>The absence of violence is not a neutral state. It is a positive good — the precondition for curiosity, play, experimentation, growth, and the pursuit of a meaningful life. Bodily integrity is not merely moral. It is generative. It produces possibilities.</p>
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

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ A: TrustInfrastructure.vue"

# ── A: ConsentBoundary ──
cat > src/components/experiences/pillarA/ConsentBoundary.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The moral boundary</p>
    <h2 class="display-medium">"My body is mine, and only I decide what happens to it."</h2>
    <Divider />

    <p class="body-text-large">Consent is the moral language of bodily integrity. It draws the line between legitimate interaction and violation.</p>

    <p class="body-text">Consent is meaningful only when it is voluntary, informed, revocable, and free from coercion. Without these conditions, "consent" is just compliance wearing a mask.</p>

    <ScenarioBox label="Where this leads">
      <p>This principle — that your body belongs to you and no one may use it without your genuine consent — is the one moral claim that virtually every human being accepts intuitively.</p>
      <p>Children understand it before they understand government: <em>"Don't hit me. That's my body."</em></p>
      <p>The Philosophy of Human Respect simply asks: if this principle is true for individuals, does it stop being true when the one violating it wears a uniform, holds an office, or acts on behalf of a majority?</p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="The honest tension">
      <p>Protecting bodily integrity sometimes requires the use of defensive force. Stopping an attacker, restraining a violent person, defending against invasion — these are uses of force that the philosophy permits, because they respond to a violation already initiated by someone else. The line isn't between "force" and "no force." It's between <em>initiated</em> force and <em>defensive</em> force.</p>
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

echo "  ✓ A: ConsentBoundary.vue"

# ── A: TheQuestion ──
cat > src/components/experiences/pillarA/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If physical safety is the precondition for flourishing...</h2>
    <Divider />

    <ContentBlock variant="principle">
      <p>...what does that mean for institutions whose primary tool is the threat of force?</p>
    </ContentBlock>

    <p class="body-text-large">Every law is ultimately backed by the threat of physical enforcement. Every tax carries the implicit promise: comply, or men with guns will come to your door. Every regulation rests on the willingness to cage those who disobey.</p>

    <p class="body-text">This isn't a radical claim. It's a description of how government functions. The question is whether that constant background hum of threatened force — even when rarely carried out — suppresses the very flourishing it claims to protect.</p>

    <ContentBlock variant="insight">
      <p>A society aligned with Human Respect must design systems that protect bodies and restore safety <em>without</em> becoming a source of the fear they're meant to prevent. Protection through voluntary cooperation, community accountability, and restorative justice — rather than through the threat of state violence.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarC' }">
        <template #title>What You Built Is Who You Were</template>
        <template #desc>Property as crystallized time — the second domain of human integrity.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The third domain — and the most fundamental of all.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Values aren't the problem. The method is.</template>
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

echo "  ✓ A: TheQuestion.vue"

# ══════════════════════════════════════════════════════════════
#
#   PILLAR C: "WHAT YOU BUILT IS WHO YOU WERE"
#
# ══════════════════════════════════════════════════════════════

cat > src/pages/PillarC.vue << 'VUEEOF'
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

import Opening from '@/components/experiences/pillarC/Opening.vue'
import TheConnection from '@/components/experiences/pillarC/TheConnection.vue'
import TheftAsLifeTheft from '@/components/experiences/pillarC/TheftAsLifeTheft.vue'
import FraudAndTrust from '@/components/experiences/pillarC/FraudAndTrust.vue'
import SecurityAndProsperity from '@/components/experiences/pillarC/SecurityAndProsperity.vue'
import TheQuestion from '@/components/experiences/pillarC/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheConnection, TheftAsLifeTheft, FraudAndTrust, SecurityAndProsperity, TheQuestion
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

echo "  ✓ PillarC.vue"

# ── C: Opening ──
cat > src/components/experiences/pillarC/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · Material Integrity</span>
    <h1 class="display-large headline">What you built<br><em>is who you were.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Your property isn't stuff. It's the physical form of hours, days, and years of your life — effort and creativity made durable. Understanding this changes how you see every act of theft, fraud, and forced redistribution.</p>
    <button class="begin-btn" @click="$emit('advance')">Continue <span class="arrow">→</span></button>
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

echo "  ✓ C: Opening.vue"

# ── C: TheConnection ──
cat > src/components/experiences/pillarC/TheConnection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The connection you haven't made</p>
    <h2 class="display-medium">Think of something you worked hard to earn.</h2>
    <Divider />

    <p class="body-text-large">A home. A car. A savings account. A business. A tool you use every day. Hold it in your mind.</p>

    <p class="body-text">Now ask yourself: how many <em>hours</em> of your life did that thing cost? Not the price tag — the hours. The mornings you got up when you didn't want to. The evenings you worked instead of resting. The years of discipline, patience, and effort that produced the money that became that thing.</p>

    <ScenarioBox label="The reframe">
      <p>That object isn't just a possession. It's <strong>crystallized time</strong> — your life converted into durable form. The chair required someone's hours. The dollar represents exchanged effort. The home represents years of mornings.</p>
      <p>Property is the bridge between your past effort and your future possibilities. It stores what you've done so it can power what you'll do next.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>This is why property isn't about materialism. It's about respecting the time — the irreplaceable life-hours — that someone invested to create, earn, or build what they have.</p>
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

echo "  ✓ C: TheConnection.vue"

# ── C: TheftAsLifeTheft ──
cat > src/components/experiences/pillarC/TheftAsLifeTheft.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What theft really is</p>
    <h2 class="display-medium">Theft destroys the bridge between past effort and future flourishing.</h2>
    <Divider />

    <p class="body-text-large">When people think of theft, they imagine the loss of things. But the real harm occurs deeper.</p>

    <p class="body-text">Theft sends a devastating message to the victim: the time you spent working doesn't matter. Your plans for tomorrow don't matter. Your autonomy over your own life doesn't matter.</p>

    <ContentBlock variant="mirror">
      <p>This is why even small acts of theft feel violating — out of proportion to the material value lost. It's not about the thing. It's about the implicit claim that someone else has a right to the hours of your life you invested in earning it.</p>
    </ContentBlock>

    <p class="body-text">And this is why, in every culture across history, theft has been condemned — not because societies coincidentally agree, but because the violation of material integrity predictably disrupts flourishing for individuals and communities alike.</p>

    <ContentBlock variant="insight">
      <p>Property as crystallized time gives us an <em>existential</em> grounding for why theft is wrong — not a legalistic or ideological one. Taking someone's property without consent is consuming their past and diminishing their future. It is, in a real sense, a theft of life.</p>
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

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ C: TheftAsLifeTheft.vue"

# ── C: FraudAndTrust ──
cat > src/components/experiences/pillarC/FraudAndTrust.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hidden violation</p>
    <h2 class="display-medium">Fraud is theft by deception — and it breaks something deeper than a bank account.</h2>
    <Divider />

    <p class="body-text-large">Fraud steals more than resources. It steals time spent in trust, cognitive attention misdirected by lies, and the opportunity cost of false belief. But its deepest damage is to the infrastructure of cooperation itself.</p>

    <p class="body-text">Every act of fraud is parasitism on trust. The scammer exploits the fact that most people operate honestly — and in doing so, makes honest operation more dangerous for everyone. When trust collapses, the cost of every interaction rises: more contracts, more lawyers, more verification, more suspicion.</p>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Fraud is one area where even the Philosophy of Human Respect acknowledges the difficulty of purely voluntary solutions. Detecting and preventing fraud requires information, investigation, and sometimes enforcement. The philosophy argues that these functions should be as voluntary and non-coercive as possible — private certification, reputation systems, voluntary arbitration — but acknowledges that protecting people from deception is one of the harder problems in a non-coercive society.</p>
    </ContentBlock>

    <p class="body-text">What doesn't change is the principle: fraud violates material integrity, damages flourishing, and erodes the trust that makes cooperation possible. A society aligned with Human Respect takes fraud seriously — not as a government prerogative, but as a threat to the social fabric that every community has an interest in preventing.</p>

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

echo "  ✓ C: FraudAndTrust.vue"

# ── C: SecurityAndProsperity ──
cat > src/components/experiences/pillarC/SecurityAndProsperity.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The quiet engine</p>
    <h2 class="display-medium">Material security is what makes everything else possible.</h2>
    <Divider />

    <p class="body-text-large">When people can't trust that their possessions will remain theirs, something predictable happens.</p>

    <div class="contrast">
      <div class="contrast-block insecure">
        <div class="contrast-label">When property is insecure</div>
        <p>People conceal wealth instead of investing it. They avoid long-term planning. They become less generous, restrict cooperation, reduce innovation, and increase defensive behavior. The result: economic stagnation, social fragmentation, and the breakdown of mutual trust.</p>
      </div>
      <div class="contrast-block secure">
        <div class="contrast-label">When property is respected</div>
        <p>People plan for the future. They invest, build, create, share, and take risks. They're more generous — because secure people give more freely than insecure ones. The result: innovation, prosperity, and deepening social trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Economists have documented this consistently: societies with stronger property norms experience higher GDP, better environmental stewardship, stronger innovation, and deeper levels of trust. Material integrity is not a luxury of wealthy societies — it is what <em>makes</em> societies wealthy.</p>
    </ContentBlock>

    <p class="body-text">Material security is the quiet engine of flourishing. Most people don't think about it — like the foundation of a house, it's invisible when it's working. But remove it, and everything built on top collapses.</p>

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
.contrast { margin: 2rem 0; display: flex; flex-direction: column; gap: 1rem; }
.contrast-block { padding: 1.5rem; border-radius: var(--radius); border: 1.5px solid var(--border-subtle); }
.contrast-block.insecure { background: var(--concede-bg); border-color: var(--concede-warm); }
.contrast-block.secure { background: var(--insight-bg); border-color: var(--insight-green); }
.contrast-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; margin-bottom: 0.5rem; }
.insecure .contrast-label { color: var(--concede-warm); }
.secure .contrast-label { color: var(--insight-green); }
.contrast-block p { font-size: 0.9rem; color: var(--ink-soft); line-height: 1.7; margin: 0; }
@media (max-width: 480px) { .contrast-block { padding: 1.25rem; } }
</style>
VUEEOF

echo "  ✓ C: SecurityAndProsperity.vue"

# ── C: TheQuestion ──
cat > src/components/experiences/pillarC/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />

    <ContentBlock variant="principle">
      <p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p>
    </ContentBlock>

    <p class="body-text-large">This isn't a gotcha. It's a genuine question that the Philosophy of Human Respect takes seriously. If every dollar you earned represents hours of your life, then taking those dollars without your individual consent is taking your life-hours. The mechanism — whether it's a thief, a scammer, or a tax collector — doesn't change the effect on the person whose time was consumed.</p>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>The philosophy doesn't claim that transitioning to voluntary funding is simple or painless. Many people depend on services funded by compulsory taxation, and pulling the rug would cause real harm. The argument is <em>directional</em>: we should be moving toward more voluntary funding and less compulsory taking, not because taxation is identical to street theft, but because both involve the same fundamental act — consuming someone's life-hours without their individual consent.</p>
    </ContentBlock>

    <p class="body-text">The three domains are now complete. Your body, your resources, and your time — each one essential for flourishing, each one violated by a different form of coercion, and each one deserving of respect.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">The complete Three Domains</p>
      <PathCard :to="{ name: 'pillarA' }">
        <template #title>Bodily Integrity</template>
        <template #desc>Respect the Body: Do not harm. The precondition for all flourishing.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Temporal Integrity</template>
        <template #desc>Respect Time: Do not coerce. The most fundamental human resource.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Values aren't the problem. The method is.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarE' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Real evidence that voluntary solutions work.</template>
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

echo "  ✓ C: TheQuestion.vue"

echo ""
echo "✅ Pillars A + C complete!"
echo ""
echo "All Five Pillars are now built:"
echo "  /pillar/your-body-is-not-negotiable     (Pillar A: Bodily Integrity)"
echo "  /pillar/your-time-is-your-life           (Pillar B: Temporal Integrity)"
echo "  /pillar/what-you-built                   (Pillar C: Material Integrity)"
echo "  /pillar/the-method-is-the-message        (Pillar D: Human Respect Method)"
echo "  /pillar/cooperation-is-a-technology      (Pillar E: Voluntary Cooperation)"
echo ""
echo "Push with: git add . && git commit -m 'pillars A+C: complete three domains' && git push"
