#!/bin/bash
# Strengthen Pillars A and C
# Pillar A: Add "violence in your name" interactive screen
# Pillar C: Reframe around "what would you build" + interactive element
# Run from humanrespect-app/ root

set -e

echo "🔨 Strengthening Pillars A and C..."

# ══════════════════════════════════════
# PILLAR A: BODILY INTEGRITY
# Screen flow:
# 1. Opening (dark) — unchanged
# 2. TheMemory — recall feeling unsafe (keep, minor tighten)
# 3. TheCascade — consolidated fear→trust→cooperation (one screen)
# 4. InYourName — NEW interactive: who faces force on your behalf?
# 5. ConsentBoundary — the moral line (keep, minor tighten)
# 6. TheQuestion — closing (unchanged)
# ══════════════════════════════════════

# Update page to use new screen order
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
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarA/Opening.vue'
import TheMemory from '@/components/experiences/pillarA/TheMemory.vue'
import TheCascade from '@/components/experiences/pillarA/TheCascade.vue'
import InYourName from '@/components/experiences/pillarA/InYourName.vue'
import ConsentBoundary from '@/components/experiences/pillarA/ConsentBoundary.vue'
import TheQuestion from '@/components/experiences/pillarA/TheQuestion.vue'

const { trackScreenView, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheMemory, TheCascade, InYourName, ConsentBoundary, TheQuestion
]

const screenNames = [
  'opening', 'the-memory', 'the-cascade', 'in-your-name', 'consent-boundary', 'the-question'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('pillarA', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarA')
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

echo "  ✓ PillarA.vue updated"

# ── Consolidated TheCascade (was 2 screens, now 1) ──
cat > src/components/experiences/pillarA/TheCascade.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The chain reaction</p>
    <h2 class="display-medium">One act of violence breaks four things at once.</h2>
    <Divider />

    <div class="cascade">
      <div class="cascade-step">
        <div class="cascade-num">1</div>
        <div>
          <div class="cascade-title">The body</div>
          <p>Physical harm, or the credible threat of it. The nervous system shifts from growth mode to survival mode.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">2</div>
        <div>
          <div class="cascade-title">The mind</div>
          <p>Fear spreads beyond the victim. Witnesses, neighbors, and entire communities begin to operate from vigilance instead of openness.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">3</div>
        <div>
          <div class="cascade-title">Trust</div>
          <p>People withdraw from public spaces, stop helping strangers, avoid engagement. The invisible infrastructure of cooperation erodes.</p>
        </div>
      </div>
      <div class="cascade-arrow">↓</div>
      <div class="cascade-step">
        <div class="cascade-num">4</div>
        <div>
          <div class="cascade-title">Prosperity</div>
          <p>Without trust, cooperation costs more. Every interaction requires contracts, verification, protection. Innovation slows. Investment dries up. The economy of a community runs on trust, and violence drains the tank.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Societies with high levels of violence are invariably poor. The most prosperous societies are those where physical safety is the norm. The relationship is causal. Safety produces trust, trust produces cooperation, cooperation produces prosperity.</p>
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
.cascade { margin: 2rem 0; display: flex; flex-direction: column; gap: 0; }
.cascade-step { display: flex; gap: 1rem; align-items: flex-start; padding: 0.75rem 0; }
.cascade-num { flex-shrink: 0; width: 24px; height: 24px; border-radius: 50%; background: var(--ochre-faint); color: var(--ochre); font-family: var(--serif); font-size: 0.8rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.cascade-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.15rem; }
.cascade-step p { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
.cascade-arrow { text-align: center; color: var(--ink-faint); font-size: 0.8rem; padding: 0.15rem 0; margin-left: 8px; }
</style>
VUEEOF

echo "  ✓ Pillar A TheCascade (consolidated)"

# ── NEW: InYourName — interactive screen ──
cat > src/components/experiences/pillarA/InYourName.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The uncomfortable question</p>
    <h2 class="display-medium">Right now, who is being threatened with physical force on your behalf?</h2>
    <Divider />

    <p class="body-text">You would never personally harm any of these people. But the system you participate in does, every day, in your name. Check each situation where government agents use or threaten physical force to enforce a policy you accept.</p>

    <div class="situations">
      <button
        v-for="item in situations"
        :key="item.id"
        class="item-card"
        :class="{ selected: selected.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
          <span class="item-detail">{{ item.detail }}</span>
        </div>
      </button>
    </div>

    <div v-if="selected.length > 0" class="reflection">
      <ContentBlock variant="mirror">
        <p>You checked {{ selected.length }} situations. In each one, a person who has not harmed anyone else faces the threat of armed agents entering their home, restraining their body, and putting them in a cage. You would never do this to them personally. But you participate in a system that does it for you.</p>
      </ContentBlock>

      <p class="body-text">The philosophy doesn't claim these people are all blameless, or that every law is unjust. It asks a simpler question: for each of these situations, is the threat of bodily force truly necessary? Or could the same goal be achieved without it?</p>
    </div>

    <NavBar :can-go-back="true" :disable-continue="selected.length === 0" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selected = ref([])
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const situations = [
  { id: 'drug-user', label: 'A person using marijuana in their own home', detail: 'Faces arrest, prosecution, and imprisonment in most jurisdictions.' },
  { id: 'tax-refuser', label: 'A person who refuses to pay taxes', detail: 'Faces wage garnishment, asset seizure, and eventually armed agents at their door.' },
  { id: 'unlicensed-worker', label: 'A person braiding hair or selling food without a license', detail: 'Faces fines, forced closure, and arrest for operating without government permission.' },
  { id: 'raw-milk', label: 'A farmer selling raw milk to willing buyers', detail: 'In many states, faces raids by armed agents for a voluntary transaction between adults.' },
  { id: 'homeschool', label: 'A parent educating their child outside approved methods', detail: 'In some jurisdictions, faces fines, custody threats, and truancy enforcement.' },
  { id: 'building-code', label: 'A homeowner building a shed on their own property', detail: 'Without a permit, faces fines, forced demolition, and liens on their home.' },
  { id: 'immigrant', label: 'A person who crossed a border to work and feed their family', detail: 'Faces detention, separation from children, and deportation by armed agents.' },
  { id: 'gun-owner', label: 'A person possessing a firearm that violates a regulation', detail: 'Faces felony charges and imprisonment even with no intent to harm anyone.' },
]

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
  trackChoice('pillarA', 'in-your-name', selected.value.join(','))
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.situations { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--concede-warm); }
.item-card.selected { border-color: var(--concede-warm); background: var(--concede-bg); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--concede-warm); margin-top: 2px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--concede-warm); border-color: var(--concede-warm); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.item-detail { display: block; font-size: 0.72rem; color: var(--ink-faint); margin-top: 0.15rem; }
.reflection { margin-top: 1.5rem; }
</style>
VUEEOF

echo "  ✓ Pillar A InYourName (interactive)"

# Remove old TrustInfrastructure (consolidated into TheCascade)
rm -f src/components/experiences/pillarA/TrustInfrastructure.vue
echo "  ✓ Removed old TrustInfrastructure"

# ══════════════════════════════════════
# PILLAR C: MATERIAL INTEGRITY
# Reframed around "what would you build?"
# Screen flow:
# 1. Opening (dark) — reframed
# 2. WhatYouveBuilt — personal reflection on crystallized time (tighter)
# 3. WhatYouDidntBuild — NEW interactive: what insecurity prevented
# 4. FraudAndTrust — keep (unique content)
# 5. SecurityAndProsperity — reframed forward-looking
# 6. TheQuestion — closing (unchanged)
# ══════════════════════════════════════

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
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarC/Opening.vue'
import WhatYouveBuilt from '@/components/experiences/pillarC/WhatYouveBuilt.vue'
import WhatYouDidntBuild from '@/components/experiences/pillarC/WhatYouDidntBuild.vue'
import FraudAndTrust from '@/components/experiences/pillarC/FraudAndTrust.vue'
import SecurityAndProsperity from '@/components/experiences/pillarC/SecurityAndProsperity.vue'
import TheQuestion from '@/components/experiences/pillarC/TheQuestion.vue'

const { trackScreenView, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, WhatYouveBuilt, WhatYouDidntBuild, FraudAndTrust, SecurityAndProsperity, TheQuestion
]

const screenNames = [
  'opening', 'what-youve-built', 'what-you-didnt-build', 'fraud-and-trust', 'security', 'the-question'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('pillarC', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarC')
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

echo "  ✓ PillarC.vue updated"

# ── C: Reframed Opening ──
cat > src/components/experiences/pillarC/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · Material Integrity</span>
    <h1 class="display-large headline">What you built<br><em>is who you were.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Every object you own represents hours of your life. Every dollar saved represents mornings you got up and went to work. The cost of theft goes deeper than the object taken. And the cost of material insecurity extends to everything that never gets built.</p>
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

echo "  ✓ Pillar C Opening reframed"

# ── C: WhatYouveBuilt (replaces TheConnection, tighter) ──
cat > src/components/experiences/pillarC/WhatYouveBuilt.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">A personal inventory</p>
    <h2 class="display-medium">Think of something you worked hard to earn.</h2>
    <Divider />

    <p class="body-text-large">A home. A car. A savings account. A business. A tool you use every day. Hold it in your mind.</p>

    <p class="body-text">Now count the hours. Not the price tag. The mornings you got up when you didn't want to. The evenings you worked instead of resting. The years of discipline and patience that produced the money that became that thing.</p>

    <ScenarioBox label="The reframe">
      <p>That object is <strong>crystallized time</strong>. Your life converted into durable form. The chair required someone's hours. The dollar represents exchanged effort. The home represents years of mornings.</p>
      <p>Property bridges your past effort and your future possibilities. It stores what you've done so it can power what you'll do next.</p>
    </ScenarioBox>

    <p class="body-text">When someone takes your property without consent, they consume hours of your past and diminish the possibilities of your future. In a real sense, a theft of property is a theft of life.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
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
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Pillar C WhatYouveBuilt"

# ── C: WhatYouDidntBuild — NEW interactive screen ──
cat > src/components/experiences/pillarC/WhatYouDidntBuild.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hidden cost</p>
    <h2 class="display-medium">What have you not built because you weren't sure you could keep it?</h2>
    <Divider />

    <p class="body-text">The visible cost of theft is the thing taken. The invisible cost is everything that never gets created. When people can't trust that the products of their effort will remain theirs, they stop creating.</p>

    <p class="body-text">Have you ever held back because of material insecurity? Check any that apply.</p>

    <div class="items">
      <button
        v-for="item in items"
        :key="item.id"
        class="item-card"
        :class="{ selected: selected.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <span class="item-label">{{ item.label }}</span>
      </button>
    </div>

    <div v-if="selected.length > 0" class="reflection">
      <ContentBlock variant="mirror">
        <p>Each one of these represents something that could have existed but doesn't. A business that might have employed people. A risk that might have paid off. A contribution to the world that was never made. Multiply your list by every person who made the same calculation, and you begin to see the real cost of material insecurity.</p>
      </ContentBlock>
    </div>

    <ContentBlock variant="insight">
      <p>Economists call this "dead capital" and "regime uncertainty." When property is insecure, people invest less, build less, share less, and take fewer risks. The cost is invisible because you can't see what was never created. But it compounds across millions of people and entire generations.</p>
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
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selected = ref([])
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const items = [
  { id: 'business', label: 'A business I thought about starting but didn\'t' },
  { id: 'investment', label: 'An investment I avoided because I wasn\'t sure the rules would stay stable' },
  { id: 'property', label: 'A property or home I didn\'t buy because of tax or regulatory burden' },
  { id: 'career-risk', label: 'A career risk I didn\'t take because the safety net wasn\'t there' },
  { id: 'generosity', label: 'A charitable gift I didn\'t make because I wasn\'t financially secure enough' },
  { id: 'project', label: 'A creative project I abandoned because it wouldn\'t pay enough after taxes and fees' },
  { id: 'savings', label: 'Savings I didn\'t build because too much of my income was already spoken for' },
  { id: 'none', label: 'None of these apply to me' },
]

function toggle(id) {
  if (id === 'none') {
    selected.value = ['none']
  } else {
    selected.value = selected.value.filter(i => i !== 'none')
    const idx = selected.value.indexOf(id)
    if (idx === -1) selected.value.push(id)
    else selected.value.splice(idx, 1)
  }
  trackChoice('pillarC', 'what-you-didnt-build', selected.value.join(','))
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: center; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); transition: all 0.2s; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-label { flex: 1; font-size: 0.88rem; }
.reflection { margin-top: 1.5rem; }
</style>
VUEEOF

echo "  ✓ Pillar C WhatYouDidntBuild (interactive)"

# ── C: Reframed SecurityAndProsperity — forward-looking ──
cat > src/components/experiences/pillarC/SecurityAndProsperity.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The world that gets built</p>
    <h2 class="display-medium">What happens when people trust that they can keep what they build?</h2>
    <Divider />

    <p class="body-text-large">Material security changes behavior in predictable ways. When people trust that their property is safe, they act differently than when they don't.</p>

    <div class="contrast">
      <div class="contrast-block insecure">
        <div class="contrast-label">When property is insecure</div>
        <p>People conceal wealth instead of investing it. They avoid long-term planning. They become less generous, restrict cooperation, and increase defensive behavior. Innovation slows because the rewards of risk can be seized.</p>
      </div>
      <div class="contrast-block secure">
        <div class="contrast-label">When property is respected</div>
        <p>People plan for the future. They invest, build, create, share, and take risks. They are more generous, because secure people give more freely. The result: innovation, prosperity, and deepening social trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Societies with stronger property norms consistently experience higher GDP, better environmental stewardship, stronger innovation, and deeper levels of trust. Material integrity is what makes societies wealthy, not a luxury they can afford once they already are.</p>
    </ContentBlock>

    <p class="body-text">The things you identified on the previous screen that you didn't build? In a society with stronger material integrity, more of those things would exist. More businesses. More investments. More generosity. More risk-taking. More creation. The cost of material insecurity is measured in the world that doesn't get built.</p>

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
.contrast-block { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.contrast-block p { margin: 0; font-size: 0.9rem; line-height: 1.7; }
.contrast-block.insecure { background: var(--concede-bg); border-left: 3px solid var(--concede-warm); }
.contrast-block.insecure p { color: var(--concede-warm); }
.contrast-block.secure { background: var(--insight-bg); border-left: 3px solid var(--insight-green); }
.contrast-block.secure p { color: var(--insight-green); }
.contrast-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.insecure .contrast-label { color: var(--concede-warm); }
.secure .contrast-label { color: var(--insight-green); }
</style>
VUEEOF

echo "  ✓ Pillar C SecurityAndProsperity reframed"

# Clean up old files no longer imported
rm -f src/components/experiences/pillarC/TheConnection.vue
rm -f src/components/experiences/pillarC/TheftAsLifeTheft.vue
echo "  ✓ Cleaned up old Pillar C files"

echo ""
echo "✅ Pillars A and C strengthened!"
echo ""
echo "PILLAR A changes:"
echo "  • TheCascade: consolidated 2 screens (fear + trust) into 1 tighter cascade"
echo "  • InYourName: NEW interactive screen — 'who faces force on your behalf?'"
echo "    8 concrete situations (drug users, tax refusers, unlicensed workers...)"
echo "    Warm/concession colors for the uncomfortable realization"
echo "    Analytics tracks which situations people acknowledge"
echo "  • Removed TrustInfrastructure (absorbed into TheCascade)"
echo ""
echo "PILLAR C changes:"
echo "  • Opening: reframed to include 'what never gets built' angle"
echo "  • WhatYouveBuilt: tighter version of crystallized time (replaces TheConnection)"
echo "  • WhatYouDidntBuild: NEW interactive — 'what have you not built?'"
echo "    7 options + 'none' covering businesses, investments, projects not pursued"
echo "    Forward-looking: the cost of insecurity is measured in what doesn't exist"
echo "  • SecurityAndProsperity: reframed to reference the visitor's own answers"
echo "  • Removed TheConnection and TheftAsLifeTheft (content absorbed)"
echo ""
echo "TEST BUILD before pushing:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'pillars: strengthen A and C with interactive elements' && git push"
