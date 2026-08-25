#!/bin/bash
# New Experience 01: The Question (relationship-based, not property-based)
# Foundation reorder: The Question → Flourishing → The Objection
# Run from humanrespect-app/ root

set -e

echo "🏗️  Building new Experience 01 + reordering foundation..."

# ══════════════════════════════════════
# BACKUP OLD EXP01 SCREENS (don't delete — analytics reference them)
# ══════════════════════════════════════

mkdir -p src/components/experiences/exp01-legacy
for f in src/components/experiences/exp01/*.vue; do
  [ -f "$f" ] && cp "$f" "src/components/experiences/exp01-legacy/$(basename $f)"
done
echo "  ✓ Old Exp01 screens backed up to exp01-legacy/"

# ══════════════════════════════════════
# NEW EXPERIENCE 01 PAGE
# 8 screens: Opening, TheDisagreement, HowYouHandledIt,
# WouldYouForceIt, WhatYouAlreadyKnow, ThePivot,
# ThePrinciple, Invitation
# ══════════════════════════════════════

cat > src/pages/Experience01.vue << 'VUEEOF'
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
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp01/Opening.vue'
import TheDisagreement from '@/components/experiences/exp01/TheDisagreement.vue'
import HowYouHandledIt from '@/components/experiences/exp01/HowYouHandledIt.vue'
import WouldYouForceIt from '@/components/experiences/exp01/WouldYouForceIt.vue'
import WhatYouAlreadyKnow from '@/components/experiences/exp01/WhatYouAlreadyKnow.vue'
import ThePivot from '@/components/experiences/exp01/ThePivot.vue'
import ThePrinciple from '@/components/experiences/exp01/ThePrinciple.vue'
import Invitation from '@/components/experiences/exp01/Invitation.vue'

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 8
const currentScreen = ref(0)
const history = ref([0])
const selectedMethods = ref([])
const wouldForce = ref(null)
const whyNot = ref([])

provide('selectedMethods', selectedMethods)
provide('wouldForce', wouldForce)
provide('whyNot', whyNot)

const screenComponents = [
  Opening, TheDisagreement, HowYouHandledIt, WouldYouForceIt,
  WhatYouAlreadyKnow, ThePivot, ThePrinciple, Invitation
]

const screenNames = [
  'opening', 'the-disagreement', 'how-you-handled-it', 'would-you-force-it',
  'what-you-already-know', 'the-pivot', 'the-principle', 'invitation'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp01', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) {
    trackCompletion('exp01', {
      methods: selectedMethods.value,
      would_force: wouldForce.value,
      why_not: whyNot.value
    })
    journey.exp01.completed = true
    journey.exp01.completedAt = new Date().toISOString()
    journey.persist()
  }
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

echo "  ✓ Experience01.vue (new)"

# ══════════════════════════════════════
# SCREEN 1: OPENING
# ══════════════════════════════════════

cat > src/components/experiences/exp01/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 01 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">You already know<br><em>the answer.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">You use a moral principle every day that you've never put into words. You apply it in your closest relationships without thinking. This experience will help you see it.</p>
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
# SCREEN 2: THE DISAGREEMENT
# ══════════════════════════════════════

cat > src/components/experiences/exp01/TheDisagreement.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start with what you know</p>
    <h2 class="display-medium">Think about the last real disagreement you had with someone you care about.</h2>
    <Divider />

    <p class="body-text-large">Not a trivial argument about where to eat. A genuine difference about something that mattered. Maybe it was about money, or how to raise a child, or a decision that would affect both of your lives. A moment where you were certain you were right and they were equally certain they were.</p>

    <p class="body-text">Hold that disagreement in your mind. Remember how it felt. Remember what was at stake.</p>

    <ScenarioBox label="What makes this worth examining">
      <p>You had a real conflict with a real person. You cared about the outcome. You believed you were right. And you had to decide how to handle it.</p>
    </ScenarioBox>

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

echo "  ✓ TheDisagreement"

# ══════════════════════════════════════
# SCREEN 3: HOW YOU HANDLED IT — interactive
# ══════════════════════════════════════

cat > src/components/experiences/exp01/HowYouHandledIt.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your instinct</p>
    <h2 class="display-medium">How did you handle it?</h2>
    <Divider />

    <p class="body-text">Think about the disagreement you just recalled. What did you actually do? Select everything that applies.</p>

    <div class="methods">
      <button
        v-for="m in methods"
        :key="m.id"
        class="method-card"
        :class="{ selected: selectedMethods.includes(m.id) }"
        @click="toggle(m.id)"
      >
        <span class="method-check">{{ selectedMethods.includes(m.id) ? '✓' : '' }}</span>
        <span class="method-label">{{ m.label }}</span>
      </button>
    </div>

    <NavBar :can-go-back="true" :disable-continue="selectedMethods.length === 0" @back="$emit('back')" @continue="handleContinue" />
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
const selectedMethods = inject('selectedMethods')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const methods = [
  { id: 'talked', label: 'Talked it through — explained my perspective and listened to theirs' },
  { id: 'compromised', label: 'Found a compromise — neither got everything, both got enough' },
  { id: 'agreed-disagree', label: 'Agreed to disagree — accepted we see it differently' },
  { id: 'gave-in', label: 'Gave in to preserve the relationship — the connection mattered more' },
  { id: 'third-party', label: 'Brought in a neutral third party — asked someone we both trust' },
  { id: 'time', label: 'Gave it time — stepped away and came back to it later' },
  { id: 'persuaded', label: 'Made my case until they came around — through argument and evidence' },
  { id: 'forced', label: 'Used my authority or leverage to override them' },
]

function toggle(id) {
  const idx = selectedMethods.value.indexOf(id)
  if (idx === -1) selectedMethods.value.push(id)
  else selectedMethods.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('exp01', 'methods', selectedMethods.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.methods { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.method-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.method-card:hover { border-color: var(--ochre); }
.method-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.method-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.method-card.selected .method-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.method-label { flex: 1; font-size: 0.88rem; }
</style>
VUEEOF

echo "  ✓ HowYouHandledIt (interactive)"

# ══════════════════════════════════════
# SCREEN 4: WOULD YOU FORCE IT — interactive
# ══════════════════════════════════════

cat > src/components/experiences/exp01/WouldYouForceIt.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The thought experiment</p>
    <h2 class="display-medium">Now imagine you had access to someone with the authority to simply force the other person to comply.</h2>
    <Divider />

    <p class="body-text-large">No conversation needed. No compromise. Just a call, and someone with real power would make the other person do what you wanted. They'd face penalties if they refused.</p>

    <p class="body-text">In that disagreement you were just thinking about — would you have used it?</p>

    <div class="choices">
      <button class="choice-btn" :class="{ selected: wouldForce === 'no' }" @click="choose('no')">
        No.
      </button>
      <button class="choice-btn" :class="{ selected: wouldForce === 'yes' }" @click="choose('yes')">
        Yes, I would have.
      </button>
    </div>

    <div v-if="wouldForce === 'no'" class="followup stagger" ref="followupEl">
      <p class="body-text" style="margin-top: 1.5rem;">Why not? Select everything that rings true.</p>

      <div class="reasons">
        <button
          v-for="r in reasons"
          :key="r.id"
          class="reason-card"
          :class="{ selected: whyNot.includes(r.id) }"
          @click="toggleReason(r.id)"
        >
          <span class="reason-check">{{ whyNot.includes(r.id) ? '✓' : '' }}</span>
          <span class="reason-label">{{ r.label }}</span>
        </button>
      </div>
    </div>

    <div v-if="wouldForce === 'yes'" class="followup">
      <ContentBlock variant="mirror">
        <p>That's honest. Hold onto that answer. The philosophy has something specific to say about what happens when force becomes the go-to method for resolving disagreements, even when the person using it believes they're right.</p>
      </ContentBlock>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!wouldForce || (wouldForce === 'no' && whyNot.length === 0)"
      @back="$emit('back')"
      @continue="handleContinue"
    />
  </div>
</template>

<script setup>
import { ref, inject, nextTick, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const followupEl = ref(null)
const wouldForce = inject('wouldForce')
const whyNot = inject('whyNot')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const reasons = [
  { id: 'relationship', label: 'It would have damaged the relationship' },
  { id: 'resentment', label: 'They would have resented me' },
  { id: 'belief', label: 'It wouldn\'t have changed what they actually believe' },
  { id: 'respect', label: 'It feels wrong to override someone I respect' },
  { id: 'cost', label: 'The long-term cost isn\'t worth the short-term win' },
  { id: 'wrong', label: 'Using force on someone who hasn\'t harmed me is simply wrong' },
]

function choose(value) {
  wouldForce.value = value
  trackChoice('exp01', 'would-force', value)
  if (value === 'no') {
    nextTick(() => {
      if (followupEl.value) followupEl.value.classList.add('animate')
    })
  }
}

function toggleReason(id) {
  const idx = whyNot.value.indexOf(id)
  if (idx === -1) whyNot.value.push(id)
  else whyNot.value.splice(idx, 1)
}

function handleContinue() {
  if (wouldForce.value === 'no') {
    trackChoice('exp01', 'why-not', whyNot.value.join(','))
  }
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 1.5rem 0; display: flex; gap: 0.75rem; }
.choice-btn { flex: 1; padding: 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.choice-btn:hover { border-color: var(--ochre); }
.choice-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.reasons { margin: 1rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.reason-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.7rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.85rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.reason-card:hover { border-color: var(--ochre); }
.reason-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.reason-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 1px; transition: all 0.2s; }
.reason-card.selected .reason-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.reason-label { flex: 1; }
</style>
VUEEOF

echo "  ✓ WouldYouForceIt (interactive)"

# ══════════════════════════════════════
# SCREEN 5: WHAT YOU ALREADY KNOW
# ══════════════════════════════════════

cat > src/components/experiences/exp01/WhatYouAlreadyKnow.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you just demonstrated</p>
    <h2 class="display-medium">{{ wouldForce === 'yes' ? 'You chose force. Most people don\'t.' : 'You already know that force doesn\'t work.' }}</h2>
    <Divider />

    <template v-if="wouldForce === 'no'">
      <p class="body-text-large">You were confident you were right. The stakes were real. And you still chose persuasion. Look at the reasons you gave:</p>

      <div class="your-reasons">
        <div v-for="r in selectedReasons" :key="r.id" class="reason-item">
          <span class="reason-dot"></span>
          <span>{{ r.label }}</span>
        </div>
      </div>

      <p class="body-text">Every one of these is a statement about what happens to human beings when force replaces persuasion. Relationships break. Resentment grows. Beliefs don't change. Trust erodes. The long-term costs outweigh the short-term gains.</p>

      <ContentBlock variant="insight">
        <p>You didn't learn this from a philosophy book. You learned it from living among other human beings. You've run this experiment thousands of times — in your family, your friendships, your workplace — and you've arrived at the same conclusion every time: persuasion builds. Force diminishes.</p>
      </ContentBlock>
    </template>

    <template v-else>
      <p class="body-text-large">Most people, when they think honestly about a specific person they care about, choose persuasion over force. The relationship matters too much. The resentment isn't worth it. The compliance isn't the same as agreement.</p>

      <p class="body-text">Your answer is worth examining, though. What was it about this particular disagreement that made force feel justified? Was it the urgency of the situation? The certainty that you were right? The belief that the other person's resistance was harmful?</p>

      <ContentBlock variant="mirror">
        <p>Hold onto those reasons. They're the same reasons people give for using political force: urgency, certainty, and the belief that resistance to the right answer is itself a form of harm. The question the philosophy raises is whether those reasons produce good outcomes — for the person being forced, and for the relationship between you.</p>
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

defineEmits(['advance', 'back'])
const el = ref(null)
const wouldForce = inject('wouldForce')
const whyNot = inject('whyNot')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allReasons = [
  { id: 'relationship', label: 'It would have damaged the relationship' },
  { id: 'resentment', label: 'They would have resented me' },
  { id: 'belief', label: 'It wouldn\'t have changed what they actually believe' },
  { id: 'cost', label: 'The long-term cost isn\'t worth the short-term win' },
  { id: 'respect', label: 'It feels wrong to override someone I respect' },
  { id: 'wrong', label: 'Using force on someone who hasn\'t harmed me is simply wrong' },
]

const selectedReasons = computed(() =>
  allReasons.filter(r => whyNot.value.includes(r.id))
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.your-reasons { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.reason-item { display: flex; align-items: flex-start; gap: 0.75rem; font-size: 0.92rem; color: var(--ink); line-height: 1.5; }
.reason-dot { flex-shrink: 0; width: 8px; height: 8px; border-radius: 50%; background: var(--ochre); margin-top: 6px; }
</style>
VUEEOF

echo "  ✓ WhatYouAlreadyKnow"

# ══════════════════════════════════════
# SCREEN 6: THE PIVOT
# ══════════════════════════════════════

cat > src/components/experiences/exp01/ThePivot.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now scale it up</p>
    <h2 class="display-medium">When millions of people disagree about healthcare, education, drug policy, and immigration, the system we've built to resolve those disagreements uses force.</h2>
    <Divider />

    <p class="body-text-large">Pass a law. Compel compliance. Fine or imprison those who refuse. The people on the receiving end of that force are human beings — every bit as complex, as dignified, and as resentful of being overridden as the person you were thinking about a moment ago.</p>

    <ContentBlock variant="mirror">
      <p>In your personal life, you chose persuasion because you understand what force does to people and relationships. In collective life, you participate in a system that uses force on millions of people who never agreed to it — and expects cooperation in return.</p>
    </ContentBlock>

    <p class="body-text">The disagreements are real. The stakes are real. The people who disagree with you about policy are as convinced they're right as you are. And the method you already know works best in your personal life — persuasion, compromise, voluntary cooperation — is the one method the political system doesn't use.</p>

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

echo "  ✓ ThePivot"

# ══════════════════════════════════════
# SCREEN 7: THE PRINCIPLE
# ══════════════════════════════════════

cat > src/components/experiences/exp01/ThePrinciple.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern has a name</p>
    <h2 class="display-medium">The Principle of Human Respect</h2>
    <Divider />

    <p class="body-text-large">You didn't need a philosophy to tell you that force damages relationships, erodes trust, and produces compliance instead of cooperation. You already knew. You demonstrate it every day.</p>

    <p class="body-text">The Philosophy of Human Respect simply observes that this pattern scales. What's true between two people is true between two million.</p>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>

    <p class="body-text">This holds whether the force comes from a controlling partner, an authoritarian boss, a neighborhood bully, or a democratic government. The mechanism changes. The effect on the person being forced does not.</p>

    <p class="body-text">The next experience explores the evidence for this — not from political theory, but from your own life. The conditions that were present when you were at your best, and the violations that were present when you were at your worst.</p>

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

echo "  ✓ ThePrinciple"

# ══════════════════════════════════════
# SCREEN 8: INVITATION
# ══════════════════════════════════════

cat > src/components/experiences/exp01/Invitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />

    <p class="body-text-large">If persuasion works better than force in your closest relationships — if you already know this from a lifetime of experience — then why do we build our collective institutions on force?</p>

    <ContentBlock variant="insight">
      <p>This question doesn't get answered in five minutes. It changes how you see every political argument, every policy debate, every disagreement about how society should work. The next experience will show you the evidence — from your own life — for why force reliably diminishes flourishing and cooperation reliably builds it.</p>
    </ContentBlock>

    <JourneyNav current="exp01" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Invitation"

# ══════════════════════════════════════
# REORDER FOUNDATION IN JOURNEYNAV
# exp01 (1) → exp03 (2) → exp02 (3)
# Already done in the JourneyNav rewrite from reorganize-tiers.sh
# but we need to swap exp02 and exp03 order values
# ══════════════════════════════════════

# The JourneyNav was already rewritten by reorganize-tiers.sh
# We need to update the order so exp03 comes before exp02

sed -i '' "s/{ name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection or revisit your original one.', tier: 'foundation', order: 2 },/{ name: 'exp03', title: 'What Flourishing Means', desc: 'The empirical grounding for the principle, traced through your own life experience.', revisitDesc: 'Revisit the Three Domains framework.', tier: 'foundation', order: 2 },/" src/components/shared/JourneyNav.vue

sed -i '' "s/{ name: 'exp03', title: 'What Flourishing Means', desc: 'Discover the empirical grounding for the principle, from your own life experience.', revisitDesc: 'Revisit the Three Domains framework.', tier: 'foundation', order: 3 },/{ name: 'exp02', title: 'The Objection', desc: 'Test the philosophy against your strongest pushback. It gets steelmanned and honestly conceded.', revisitDesc: 'Try a different objection or revisit your original one.', tier: 'foundation', order: 3 },/" src/components/shared/JourneyNav.vue

echo "  ✓ Foundation reordered: Question → Flourishing → Objection"

# ══════════════════════════════════════
# UPDATE YOUR JOURNEY PAGE — swap exp02/exp03 order
# ══════════════════════════════════════

sed -i '' "s/{ name: 'exp01', title: 'The Question', tier: 'foundation', order: 1, desc: 'A thought experiment revealing the gap between personal and political morality.' },/{ name: 'exp01', title: 'The Question', tier: 'foundation', order: 1, desc: 'You already know that force damages relationships. The question is why we abandon that principle at scale.' },/" src/pages/YourJourney.vue

# Swap exp02 and exp03 order in YourJourney
sed -i '' "s/{ name: 'exp02', title: 'The Objection', tier: 'foundation', order: 2/{ name: 'exp03', title: 'What Flourishing Means', tier: 'foundation', order: 2/" src/pages/YourJourney.vue
sed -i '' "s/{ name: 'exp03', title: 'What Flourishing Means', tier: 'foundation', order: 3/{ name: 'exp02', title: 'The Objection', tier: 'foundation', order: 3/" src/pages/YourJourney.vue

echo "  ✓ YourJourney page reordered"

# ══════════════════════════════════════
# UPDATE MILESTONE — new discovery #1
# ══════════════════════════════════════

sed -i '' "s/You hold one moral standard for personal life and a different one for politics. Most people do. Now you've seen it./You already knew that force damages relationships. You chose persuasion in your own life. The question is why we abandon that principle at scale./" src/pages/MilestonePage.vue
sed -i '' "s/You apply the same moral standard to personal and political life. You're already living by the principle most people haven't noticed./You recognized that the principle you live by in personal relationships applies to collective life too./" src/pages/MilestonePage.vue
sed -i '' "s/You examined your own moral reasoning and found a pattern worth understanding./You examined how you handle real disagreements and discovered what you already know about force and persuasion./" src/pages/MilestonePage.vue

# Swap discovery 02 and 03 labels in milestone
sed -i '' "s/The objection<\/div>/The grounding<\/div>/" src/pages/MilestonePage.vue
sed -i '' "s/The grounding<\/div>/The objection<\/div>/2" src/pages/MilestonePage.vue

echo "  ✓ Milestone updated for new Exp01"

# ══════════════════════════════════════
# UPDATE ROUTE META for new Exp01
# ══════════════════════════════════════

sed -i '' "s/A five-minute thought experiment that reveals the gap between your personal morality and your political beliefs./You already know that force damages relationships. This experience helps you see the principle you live by — and why we abandon it at scale./" src/router/meta.js

echo "  ✓ Route meta updated"

# ══════════════════════════════════════
# CLEAN UP — remove old screen files no longer imported
# ══════════════════════════════════════

rm -f src/components/experiences/exp01/CommonGround.vue
rm -f src/components/experiences/exp01/Scenario.vue
rm -f src/components/experiences/exp01/PersonalChoice.vue
rm -f src/components/experiences/exp01/PoliticalChoice.vue
rm -f src/components/experiences/exp01/Mirror.vue
rm -f src/components/experiences/exp01/WhyTheGap.vue

echo "  ✓ Old screens removed (backed up in exp01-legacy/)"

echo ""
echo "✅ New Experience 01 + foundation reorder complete!"
echo ""
echo "New Exp01 screens (8):"
echo "  0. Opening: 'You already know the answer'"
echo "  1. TheDisagreement: Think about a real disagreement"
echo "  2. HowYouHandledIt: 🎯 Select methods (8 options)"
echo "  3. WouldYouForceIt: 🎯 Would you use force? + 🎯 Why not? (6 reasons)"
echo "  4. WhatYouAlreadyKnow: Your reasons reflected back (🔀 adapts to yes/no)"
echo "  5. ThePivot: Scale it up to collective disagreements"
echo "  6. ThePrinciple: The Flourishing Principle"
echo "  7. Invitation: JourneyNav → next experience"
echo ""
echo "Foundation sequence:"
echo "  1. The Question (new — relationship-based, not property-based)"
echo "  2. What Flourishing Means (moved up — empirical grounding)"
echo "  3. The Objection (moved down — test with full context)"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp01: new relationship-based opening + foundation reorder' && git push"
