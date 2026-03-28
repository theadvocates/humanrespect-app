#!/bin/bash
# Revised Experience 02: The Objection
# New objections grounded in flourishing (not libertarian economics)
# 5 interactive moments across 8 screens
# Run from humanrespect-app/ root

set -e

echo "🏗️  Building revised Experience 02: The Objection..."

mkdir -p src/components/experiences/exp02

# ══════════════════════════════════════
# OBJECTION DATA — completely rewritten
# ══════════════════════════════════════

cat > src/components/experiences/exp02/objectionData.js << 'JSEOF'
export const objections = {
  'doesnt-scale': {
    title: '"That works in relationships, but not in a society of millions."',
    subtitle: 'Persuasion requires trust. Strangers don\'t have it.',
    steelman: 'Personal relationships involve people who know and care about each other. Society involves millions of strangers with competing interests. Persuasion works with your spouse because you share a life. It doesn\'t work with strangers because there\'s no relationship to preserve. Large-scale cooperation requires rules, and rules require enforcement. That\'s not a flaw in the system — it\'s the only way complex societies can function.',
    response: [
      'Look at the reasons you gave for rejecting force in your own life. Most of them weren\'t about the relationship. They were about what force <em>does to human beings</em>: it breeds resentment, it doesn\'t change beliefs, the long-term costs outweigh the short-term gains. Those effects don\'t require intimacy. They\'re features of human nature. A stranger forced to comply is just as resentful and just as unchanged in their beliefs as someone you love.',
      'The flourishing conditions you identified from your own life — safety, autonomy, connection, opportunity — don\'t have a scale threshold. A policy that violates someone\'s autonomy doesn\'t become less damaging to their flourishing because it was enacted by a large legislature rather than imposed by a single bully. The effect on the person being forced is the same.',
      'Cooperation itself is what scales. Language scaled from small groups to global communication. Markets scaled from village barter to worldwide commerce. Standards of behavior scaled from tribal custom to international norms. Every one of these was a technology of voluntary coordination that people said couldn\'t work beyond a small group — until it did.',
      'The real scaling problem runs in the other direction. Force scales <em>badly</em>. The larger the group, the less the enforcers know about the people they\'re coercing, the less feedback they receive, and the more damage they do per mistake. A parent who forces a child to eat vegetables may be wrong, but the harm is contained. A government forcing a nutrition policy on millions produces cascading unintended consequences — because the people making the rules are strangers to the people living under them.'
    ],
    concession: 'Voluntary cooperation at scale requires something coercion doesn\'t: trust between strangers. Building that trust is genuinely harder than passing a law. The philosophy doesn\'t claim the transition is simple. It claims that the alternative — forcing strangers to comply with rules they didn\'t choose — produces the very mistrust that makes cooperation seem impossible. Trust is built by cooperating. It is eroded by coercing.',
    question: 'You wouldn\'t use force on someone you know because you understand what it does to them. What makes you confident it does something different to someone you don\'t know?'
  },

  'too-urgent': {
    title: '"People are suffering right now. They can\'t wait for voluntary action."',
    subtitle: 'Urgency demands guaranteed response, not hopeful cooperation.',
    steelman: 'A child is hungry right now. A person is dying of a treatable disease right now. A family lost their home right now. You can philosophize about voluntary cooperation, but these people can\'t wait for someone to be persuaded to help. Compulsory systems exist because urgent suffering demands guaranteed, immediate response. Leaving it to voluntary action means accepting that some people will simply not be helped.',
    response: [
      'This objection carries real moral weight, and the philosophy takes it seriously. But notice the assumption underneath it: that the only way to guarantee help is to force people to provide it. This assumes that human beings, left free, will not respond to suffering. That assumption is worth testing.',
      'When disaster strikes — hurricanes, earthquakes, floods — voluntary response is not slow. It is often faster and more effective than government mobilization. After Hurricane Katrina, volunteer boat rescuers reached stranded families while FEMA was still processing paperwork. After earthquakes, neighbors pull each other from rubble before emergency services arrive. The impulse to help is not something governments created. It is something human beings do.',
      'Now apply the flourishing framework you just worked through. When help is compelled — extracted from some to be given to others through force — what happens to the people on both ends? The person taxed loses autonomy over their resources. The person helped receives aid delivered by a system that has no relationship with them and no incentive to care about their dignity. Contrast this with voluntary help: a community that <em>chooses</em> to support its members creates connection, preserves dignity, and strengthens the social bonds that prevent future crises. Compulsory systems address the symptom. Voluntary systems address the symptom <em>and</em> build the conditions for flourishing.',
      'There is a deeper cost most people don\'t see. When government assumes responsibility for the vulnerable, communities atrophy. Neighbors stop knowing each other. Mutual aid networks dissolve. The very capacity for voluntary response weakens. Then, when the compulsory system fails — as it inevitably does for some — there is nothing left to catch the person who falls.'
    ],
    concession: 'This is where the philosophy must be most honest. During any transition from compulsory to voluntary systems, there is a real risk that some people who currently receive help would experience disruption. The philosophy cannot promise zero casualties. What it can say is this: compulsory systems produce their own suffering — dependency, loss of dignity, bureaucratic indifference, the erosion of community bonds. A system that guarantees a floor may also enforce a ceiling. The question is not whether voluntary systems are perfect. It\'s whether they produce better trajectories for human flourishing than systems built on force.',
    question: 'If you saw a neighbor in crisis, would you help — or would you wait for a government program? If you would help, why do you assume other people wouldn\'t?'
  },

  'force-built-this': {
    title: '"Force built the stability that made your flourishing possible."',
    subtitle: 'You\'re flourishing because of government, not in spite of it.',
    steelman: 'The best period of your life didn\'t happen in a vacuum. It happened inside a society with enforceable laws, public infrastructure, courts, police, and institutions — all funded and maintained through compulsory taxation. The safety, autonomy, and opportunity you identified weren\'t gifts of nature. They were products of a system built on democratic force. You\'re flourishing because of coercive institutions, not in spite of them.',
    response: [
      'This is a serious argument, and it deserves a careful answer. The philosophy does not claim that every outcome produced by government is bad. It claims that the <em>method</em> of force systematically undermines the conditions for flourishing — even when individual outcomes appear positive.',
      'Consider the flourishing conditions you identified: safety, autonomy, connection, competence, purpose, opportunity. Now ask: did coercive institutions <em>create</em> these, or did they emerge in spite of coercion? Safety exists in your neighborhood primarily because your neighbors choose not to harm each other — not because police are on every corner. Your autonomy exists because you\'ve carved out a life within a system that limits your autonomy in dozens of ways you\'ve learned to navigate around. The stability you experience comes largely from the voluntary cooperation of millions of people — showing up to work, honoring agreements, treating strangers with basic decency — with government enforcement filling gaps where voluntary norms have broken down.',
      'The Guide makes a distinction worth sitting with: the trust that makes cooperation possible is built by voluntary behavior, not by enforcement. A neighborhood where people don\'t steal because they respect each other is fundamentally different from one where people don\'t steal because they fear punishment. The first produces genuine trust. The second produces compliance that evaporates the moment enforcement weakens.',
      'There is also a survivorship bias in this argument. You see the stability that compulsory systems produced. You don\'t see the flourishing they prevented — the businesses never started because of regulatory barriers, the communities never formed because zoning laws blocked them, the mutual aid networks that dissolved because government programs replaced them, the innovations never attempted because the cost of compliance was too high. The visible benefits of force are easy to credit. The invisible costs are easy to ignore.'
    ],
    concession: 'The philosophy acknowledges that some compulsory institutions have produced outcomes that voluntary systems haven\'t yet replicated at the same scale. The claim is not that everything government does could have been done better voluntarily yesterday. The claim is that the direction matters: every expansion of voluntary cooperation has historically produced more flourishing than the coercive system it replaced. And every expansion of coercion has produced diminishing returns and increasing unintended harm.',
    question: 'Think about your best period again. How much of what made it good was provided by the government — and how much was built by you and the people around you, through voluntary effort, voluntary relationships, and voluntary commitment?'
  },

  'power-vacuum': {
    title: '"Without enforcement, the powerful will exploit the weak."',
    subtitle: 'Remove government force and worse force fills the vacuum.',
    steelman: 'History is clear: when centralized authority weakens, the powerful fill the vacuum. Warlords, monopolists, slaveholders, feudal lords. Government force isn\'t perfect, but it\'s the best tool humanity has developed for protecting ordinary people from predatory power. Remove it, and the vulnerable suffer most. Your philosophy sounds like freedom for the strong and abandonment of the weak.',
    response: [
      'This objection assumes that government force and private exploitation are the only two options — that without the first, you inevitably get the second. But look at the flourishing framework. The conditions you identified — safety, autonomy, connection — are damaged by <em>both</em> government coercion and private exploitation. The question isn\'t which form of force to accept. It\'s whether there are ways to protect the vulnerable that don\'t require creating an institution with a monopoly on force.',
      'Consider the pattern: every institution created to protect the vulnerable eventually becomes a tool of the powerful. Regulatory agencies are captured by the industries they regulate. Tax systems are shaped by those who can afford lobbyists. Zoning boards serve property developers. Military power is deployed for commercial interests. The institution you\'re relying on to protect the weak is the institution the strong have the greatest incentive and ability to control.',
      'Now consider what <em>actually</em> protects the vulnerable in your own life. When someone in your community is in trouble, what helps them? Government programs, sometimes. But more often: neighbors, friends, family, religious communities, mutual aid networks, charitable organizations. These are voluntary institutions built on trust and connection — and they serve the vulnerable precisely because no one is forced to participate. The people who show up are the people who care. The help they provide preserves dignity because it comes from genuine concern, not bureaucratic obligation.',
      'The philosophy\'s claim is not that the vulnerable don\'t need protection. It\'s that concentrated coercive power is the wrong tool for providing it — because the same concentration of power that can protect can also exploit, and historically does. The alternative is distributed, voluntary, trust-based protection: communities that take care of their own because they\'ve chosen to. This requires stronger social bonds, not weaker ones. More cooperation, not less. But it doesn\'t require anyone to hold a monopoly on force.'
    ],
    concession: 'This is the hardest question the philosophy faces. In the immediate absence of enforcement, some people with power would exploit others. The philosophy doesn\'t deny this. It argues that the solution — concentrating coercive power in one institution and hoping the right people control it — has a worse track record than its defenders acknowledge. But the philosophy must also be honest that voluntary protection requires strong communities, high social trust, and robust mutual aid systems. Building those takes time. During the transition, some people would be more vulnerable than they are today. That cost is real, and any honest philosophy must name it.',
    question: 'The institution you trust to protect the vulnerable has the power to imprison, seize property, and deploy armed agents. Who protects the vulnerable from <em>it</em>?'
  }
}
JSEOF

echo "  ✓ objectionData.js (completely rewritten)"

# ══════════════════════════════════════
# PAGE COMPONENT — 8 screens
# ══════════════════════════════════════

cat > src/pages/Experience02.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @choose-objection="handleObjectionChoice"
          @restart-with="restartWith"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted } from 'vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import YourVerdict from '@/components/experiences/exp02/YourVerdict.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 8
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response,
  Concession, TheQuestion, YourVerdict, WhereNext
]

const screenNames = [
  'opening', 'choose-objection', 'steelman', 'response',
  'concession', 'the-question', 'your-verdict', 'where-next'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02?.chosenObjection || 'none'}`)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp02', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) {
    trackCompletion('exp02')
    if (!journey.exp02) journey.exp02 = {}
    journey.exp02.completed = true
    journey.exp02.completedAt = new Date().toISOString()
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

function handleObjectionChoice(key) {
  if (!journey.exp02) journey.exp02 = {}
  journey.exp02.chosenObjection = key
  trackChoice('exp02', 'objection', key)
  journey.persist()
}

function restartWith(key) {
  handleObjectionChoice(key)
  currentScreen.value = 2
  history.value = [0, 1, 2]
  window.scrollTo(0, 0)
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

echo "  ✓ Experience02.vue"

# ══════════════════════════════════════
# SCREEN 1: OPENING
# ══════════════════════════════════════

cat > src/components/experiences/exp02/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 03 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">You have a <em>"but..."</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">You've seen the principle in your own relationships. You've confirmed it against your own flourishing. But you're not convinced it applies to the real world — with its complexity, its urgency, and its imperfect people. Good. A philosophy that can't survive your strongest objection isn't worth your time.</p>
    <button class="begin-btn" @click="$emit('advance')">
      Choose your objection <span class="arrow">→</span>
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

echo "  ✓ Opening"

# ══════════════════════════════════════
# SCREEN 2: CHOOSE OBJECTION — interactive
# ══════════════════════════════════════

cat > src/components/experiences/exp02/ChooseObjection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your strongest pushback</p>
    <h2 class="display-medium">Which of these is closest to what you're thinking?</h2>
    <Divider />
    <p class="body-text">Pick the one that feels most true to you — the objection you'd make if we were having this conversation in person.</p>

    <div class="choices">
      <button
        v-for="(obj, key) in allObjections"
        :key="key"
        class="objection-card"
        :class="{ selected: chosen === key }"
        @click="choose(key)"
      >
        <div class="objection-title">{{ obj.title }}</div>
        <div class="objection-subtitle">{{ obj.subtitle }}</div>
      </button>
    </div>

    <NavBar :can-go-back="true" :disable-continue="!chosen" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { objections as allObjections } from './objectionData.js'

const emit = defineEmits(['advance', 'back', 'choose-objection'])
const el = ref(null)
const chosen = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(key) {
  chosen.value = key
  emit('choose-objection', key)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.objection-card { width: 100%; text-align: left; padding: 1rem 1.25rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.objection-card:hover { border-color: var(--ochre); }
.objection-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.objection-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); line-height: 1.4; }
.objection-subtitle { font-size: 0.78rem; color: var(--ink-faint); margin-top: 0.2rem; }
</style>
VUEEOF

echo "  ✓ ChooseObjection (interactive)"

# ══════════════════════════════════════
# SCREEN 3: STEELMAN — interactive fairness check
# ══════════════════════════════════════

cat > src/components/experiences/exp02/Steelman.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Taking your objection seriously</p>
    <h2 class="display-medium">{{ obj.title }}</h2>
    <Divider />

    <p class="body-text-large">Before responding, we need to state your objection in its strongest form. Not a caricature. The real argument, as a thoughtful person would make it.</p>

    <ContentBlock variant="mirror" label="Your objection, at its strongest">
      <p>{{ obj.steelman }}</p>
    </ContentBlock>

    <p class="body-text" style="margin-top: 1.5rem;">Is this a fair representation of your concern?</p>

    <div class="fairness-options">
      <button
        v-for="opt in fairnessOptions"
        :key="opt.id"
        class="fairness-btn"
        :class="{ selected: fairness === opt.id }"
        @click="chooseFairness(opt.id)"
      >{{ opt.label }}</button>
    </div>

    <div v-if="fairness === 'missing'" class="strengthen">
      <p class="body-text" style="margin-top: 1rem;">What's missing? In your own words, what would make this objection stronger?</p>
      <textarea v-model="strengthening" class="strengthen-input" placeholder="The part this misses is..." rows="3"></textarea>
    </div>

    <div v-if="fairness === 'stronger'" class="strengthen">
      <p class="body-text" style="margin-top: 1rem;">What's the stronger version?</p>
      <textarea v-model="strengthening" class="strengthen-input" placeholder="My real objection is..." rows="3"></textarea>
    </div>

    <p v-if="fairness" class="body-text" style="margin-top: 1.5rem; font-style: italic; color: var(--ink-faint);">We're going to engage with the strongest version of this objection — because that's the only version worth responding to.</p>

    <NavBar :can-go-back="true" :disable-continue="!fairness" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const fairness = ref(null)
const strengthening = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const fairnessOptions = [
  { id: 'fair', label: 'Yes, this captures it' },
  { id: 'missing', label: 'Close, but missing something' },
  { id: 'stronger', label: 'My real objection is stronger than this' },
]

function chooseFairness(id) {
  fairness.value = id
  trackChoice('exp02', 'steelman-fairness', id)
}

function handleContinue() {
  if (strengthening.value.trim()) {
    trackChoice('exp02', 'steelman-strengthened', 'provided')
  }
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.fairness-options { margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.4rem; }
.fairness-btn { padding: 0.55rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.fairness-btn:hover { border-color: var(--ochre); }
.fairness-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
.strengthen-input { width: 100%; margin-top: 0.5rem; padding: 0.85rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.88rem; line-height: 1.6; color: var(--ink); resize: vertical; }
.strengthen-input:focus { outline: none; border-color: var(--ochre); }
</style>
VUEEOF

echo "  ✓ Steelman (interactive fairness check)"

# ══════════════════════════════════════
# SCREEN 4: RESPONSE — interactive paragraph-by-paragraph
# ══════════════════════════════════════

cat > src/components/experiences/exp02/Response.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The response</p>
    <h2 class="display-medium">Here's what the philosophy says back.</h2>
    <Divider />

    <div class="response-flow">
      <div v-for="(para, idx) in obj.response" :key="idx" class="response-block" :class="{ visible: idx <= currentPara }">
        <div class="response-para" v-html="para"></div>

        <div v-if="idx === currentPara && idx < obj.response.length - 1" class="reaction-row">
          <p class="reaction-prompt">Does this address your concern?</p>
          <div class="reaction-options">
            <button
              v-for="r in reactions"
              :key="r.id"
              class="reaction-btn"
              :class="{ selected: paraReactions[idx] === r.id }"
              @click="react(idx, r.id)"
            >{{ r.label }}</button>
          </div>
        </div>

        <div v-if="idx === currentPara && idx === obj.response.length - 1" class="reaction-row">
          <p class="reaction-prompt">Having read the full response:</p>
          <div class="reaction-options">
            <button
              v-for="r in reactions"
              :key="r.id"
              class="reaction-btn"
              :class="{ selected: paraReactions[idx] === r.id }"
              @click="react(idx, r.id)"
            >{{ r.label }}</button>
          </div>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!allReacted"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const currentPara = ref(0)
const paraReactions = ref({})
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const reactions = [
  { id: 'yes', label: 'Yes, that helps' },
  { id: 'partially', label: 'Partially' },
  { id: 'no', label: 'No, that misses the point' },
]

const allReacted = computed(() => {
  return Object.keys(paraReactions.value).length >= obj.value.response.length
})

function react(idx, reactionId) {
  paraReactions.value[idx] = reactionId
  trackChoice('exp02', `response-para-${idx}`, reactionId)

  if (idx < obj.value.response.length - 1) {
    nextTick(() => {
      currentPara.value = idx + 1
      setTimeout(() => {
        const blocks = document.querySelectorAll('.response-block')
        const nextBlock = blocks[idx + 1]
        if (nextBlock) nextBlock.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }, 100)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.response-flow { margin: 1.5rem 0; }
.response-block { margin-bottom: 1.5rem; opacity: 0; transform: translateY(8px); transition: opacity 0.4s ease, transform 0.4s ease; }
.response-block.visible { opacity: 1; transform: translateY(0); }
.response-para { font-size: 0.92rem; line-height: 1.75; color: var(--ink-muted); padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.response-para :deep(em) { color: var(--ink); font-style: italic; }

.reaction-row { margin-top: 0.75rem; }
.reaction-prompt { font-size: 0.78rem; color: var(--ink-faint); margin-bottom: 0.4rem; }
.reaction-options { display: flex; flex-wrap: wrap; gap: 0.35rem; }
.reaction-btn { padding: 0.4rem 0.85rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.75rem; color: var(--ink-faint); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.reaction-btn:hover { border-color: var(--ochre); }
.reaction-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
</style>
VUEEOF

echo "  ✓ Response (interactive paragraph-by-paragraph)"

# ══════════════════════════════════════
# SCREEN 5: CONCESSION — interactive credibility check
# ══════════════════════════════════════

cat > src/components/experiences/exp02/Concession.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">What honesty requires</p>
    <h2 class="display-medium">What the philosophy can't claim.</h2>
    <Divider />

    <p class="body-text-large">A philosophy that only gives you the strong parts of its argument and hides the difficult parts isn't trustworthy. So here's what intellectual honesty requires us to say.</p>

    <ContentBlock variant="concession" label="The honest concession">
      <p v-html="obj.concession"></p>
    </ContentBlock>

    <p class="body-text" style="margin-top: 1.5rem;">Does this honesty make the philosophy more or less credible to you?</p>

    <div class="credibility-options">
      <button
        v-for="opt in credibilityOptions"
        :key="opt.id"
        class="cred-btn"
        :class="{ selected: credibility === opt.id }"
        @click="chooseCredibility(opt.id)"
      >{{ opt.label }}</button>
    </div>

    <p v-if="credibility" class="body-text" style="margin-top: 1rem; font-style: italic; color: var(--ink-faint);">
      <template v-if="credibility === 'more'">Most people find that honesty about limits builds more trust than confident claims of perfection.</template>
      <template v-else-if="credibility === 'less'">That's a legitimate response. If the gap between what the philosophy promises and what it can deliver is too wide, the principle may not be worth the risk.</template>
      <template v-else>Fair enough. The concession doesn't change the core argument — it just marks its boundaries.</template>
    </p>

    <NavBar :can-go-back="true" :disable-continue="!credibility" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const credibility = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const credibilityOptions = [
  { id: 'more', label: 'More credible — honesty matters' },
  { id: 'less', label: 'Less credible — the gap is too big' },
  { id: 'same', label: 'Doesn\'t change my view' },
]

function chooseCredibility(id) {
  credibility.value = id
  trackChoice('exp02', 'concession-credibility', id)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.credibility-options { margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.4rem; }
.cred-btn { padding: 0.55rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.cred-btn:hover { border-color: var(--ochre); }
.cred-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
</style>
VUEEOF

echo "  ✓ Concession (interactive credibility check)"

# ══════════════════════════════════════
# SCREEN 6: THE QUESTION
# ══════════════════════════════════════

cat > src/components/experiences/exp02/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">We don't end with an answer. We end with a question.</h2>
    <Divider />

    <p class="body-text-large">You came in with an objection. You've seen it taken seriously, responded to, and the limits of that response honestly acknowledged. Now there's a question left.</p>

    <ContentBlock variant="principle">
      <p v-html="obj.question"></p>
    </ContentBlock>

    <p class="body-text">This isn't rhetorical. It's a question worth sitting with — maybe for a few days. The philosophy doesn't ask you to accept it today. It asks you to carry the question and see if the world starts looking different.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ TheQuestion"

# ══════════════════════════════════════
# SCREEN 7: YOUR VERDICT — interactive
# ══════════════════════════════════════

cat > src/components/experiences/exp02/YourVerdict.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your assessment</p>
    <h2 class="display-medium">Did the response address your objection?</h2>
    <Divider />

    <p class="body-text">Be honest. This isn't a test — it's information that helps us understand where the philosophy's arguments are strong and where they need work.</p>

    <div class="verdict-options">
      <button
        v-for="v in verdictOptions"
        :key="v.id"
        class="verdict-btn"
        :class="{ selected: verdict === v.id }"
        @click="chooseVerdict(v.id)"
      >
        <div class="verdict-label">{{ v.label }}</div>
        <div class="verdict-desc">{{ v.desc }}</div>
      </button>
    </div>

    <div v-if="verdict" class="verdict-response">
      <p v-if="verdict === 'addressed'" class="body-text" style="font-style: italic; color: var(--insight-green);">That's worth noting. The next experiences explore the implications — what the principle means for your body, your time, your resources, and how you relate to political systems.</p>
      <p v-else-if="verdict === 'partial'" class="body-text" style="font-style: italic; color: var(--ochre);">Partial is honest. The philosophy doesn't claim to have airtight answers to every objection. It claims to have a better framework than the alternative. The parts that didn't land are worth carrying as open questions.</p>
      <p v-else class="body-text" style="font-style: italic; color: var(--concede-warm);">That's important feedback. If the response didn't address your concern, the philosophy has work to do on this front. You might find that a different objection path resonates differently — or you might find that this is a genuine limit of the framework.</p>
    </div>

    <NavBar :can-go-back="true" :disable-continue="!verdict" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const verdict = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const verdictOptions = [
  { id: 'addressed', label: 'Yes, it addressed my concern', desc: 'The response engaged with the real objection and the reasoning holds.' },
  { id: 'partial', label: 'Partially', desc: 'Some parts landed. Others didn\'t. I\'m not fully convinced.' },
  { id: 'not-addressed', label: 'No, it missed the point', desc: 'The response didn\'t engage with what actually concerns me.' },
]

function chooseVerdict(id) {
  verdict.value = id
  trackChoice('exp02', 'verdict', id)
  if (!journey.exp02) journey.exp02 = {}
  journey.exp02.verdict = id
  journey.persist()
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.verdict-options { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.verdict-btn { width: 100%; text-align: left; padding: 1rem 1.25rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.verdict-btn:hover { border-color: var(--ochre); }
.verdict-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.verdict-label { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.verdict-desc { font-size: 0.78rem; color: var(--ink-faint); margin-top: 0.15rem; }
.verdict-response { margin-top: 1rem; }
</style>
VUEEOF

echo "  ✓ YourVerdict (interactive)"

# ══════════════════════════════════════
# SCREEN 8: WHERE NEXT
# ══════════════════════════════════════

cat > src/components/experiences/exp02/WhereNext.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">Three discoveries, from your own reasoning.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div>
          <div class="foundation-title">The method</div>
          <p class="foundation-desc">You already choose persuasion over force in your closest relationships — because you know what force does to people.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div>
          <div class="foundation-title">The evidence</div>
          <p class="foundation-desc">Your own flourishing confirmed it: safety, autonomy, and opportunity are the conditions. Violations of body, resources, and time are what destroys them.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div>
          <div class="foundation-title">The stress test</div>
          <p class="foundation-desc">You chose your strongest objection and saw it engaged with honestly — including the limits of the response.</p>
        </div>
      </div>
    </div>

    <p class="body-text">You can explore another objection, or continue deeper into the philosophy.</p>

    <div v-if="otherObjections.length > 0" class="other-objections">
      <p class="caption" style="margin-bottom: 0.75rem;">Try a different objection</p>
      <div class="other-list">
        <button
          v-for="key in otherObjections"
          :key="key"
          class="other-btn"
          @click="$emit('restart-with', key)"
        >{{ allObjections[key].title }}</button>
      </div>
    </div>

    <PathCard :to="{ name: 'milestone' }" :recommended="true">
      <template #title>See your foundation summary</template>
      <template #desc>A personalized summary of what you discovered, and where the philosophy goes from here.</template>
    </PathCard>

    <JourneyNav current="exp02" next-label="Continue your journey" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const otherObjections = computed(() =>
  Object.keys(allObjections).filter(k => k !== journey.exp02?.chosenObjection)
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.15rem; }
.foundation-desc { font-size: 0.85rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.other-objections { margin: 2rem 0; }
.other-list { display: flex; flex-direction: column; gap: 0.4rem; margin-bottom: 1.5rem; }
.other-btn { width: 100%; text-align: left; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--serif); font-size: 0.88rem; color: var(--ink); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.other-btn:hover { border-color: var(--ochre); background: var(--ochre-faint); }
</style>
VUEEOF

echo "  ✓ WhereNext"

echo ""
echo "✅ Experience 02: The Objection — completely revised!"
echo ""
echo "New objection paths (flourishing-grounded):"
echo "  1. 'That doesn't scale' — human nature, not economics"
echo "  2. 'Too urgent for voluntary action' — Cajun Navy, dignity, community atrophy"
echo "  3. 'Force built your flourishing' — survivorship bias, voluntary vs. coerced trust"
echo "  4. 'The powerful exploit the weak' — regulatory capture, distributed protection"
echo ""
echo "5 interactive moments:"
echo "  Screen 2: Choose objection (4 options)"
echo "  Screen 3: Steelman fairness check + optional strengthening"
echo "  Screen 4: Paragraph-by-paragraph response reactions"
echo "  Screen 5: Concession credibility assessment"
echo "  Screen 7: Final verdict (addressed / partial / not addressed)"
echo ""
echo "8 screens total. No passive stretch longer than 1 screen."
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp02: new flourishing-grounded objections + 5 interactive moments' && git push"
