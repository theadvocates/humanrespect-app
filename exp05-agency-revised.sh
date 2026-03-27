#!/bin/bash
# Revised Experience 05: Human Agency
# Three interactive moments, no duplication with Practice01 or Exp02
# Run from humanrespect-app/ root
# NOTE: Run this INSTEAD of exp05-agency.sh (replaces those files)

set -e

echo "🏗️  Building revised Experience 05: Human Agency..."

mkdir -p src/components/experiences/exp05

# ══════════════════════════════════════
# PAGE COMPONENT — 7 screens
# ══════════════════════════════════════

cat > src/pages/Experience05.vue << 'VUEEOF'
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

import Opening from '@/components/experiences/exp05/Opening.vue'
import TheHire from '@/components/experiences/exp05/TheHire.vue'
import TheVote from '@/components/experiences/exp05/TheVote.vue'
import TraceTheChain from '@/components/experiences/exp05/TraceTheChain.vue'
import TheDefenses from '@/components/experiences/exp05/TheDefenses.vue'
import TranslateThePolicy from '@/components/experiences/exp05/TranslateThePolicy.vue'
import TheQuestion from '@/components/experiences/exp05/TheQuestion.vue'

const { trackScreenView, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 7
const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, TheHire, TheVote, TraceTheChain,
  TheDefenses, TranslateThePolicy, TheQuestion
]

const screenNames = [
  'opening', 'the-hire', 'the-vote', 'trace-the-chain',
  'the-defenses', 'translate-the-policy', 'the-question'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('exp05', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('exp05')
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

echo "  ✓ Experience05.vue"

# ══════════════════════════════════════
# SCREEN 1: OPENING (unchanged)
# ══════════════════════════════════════

cat > src/components/experiences/exp05/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 05 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">Human<br><em>agency.</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">If you hire someone to break into your neighbor's house and take their money, who is responsible for the theft? You are. The person you hired is your agent. You are the principal. The moral weight falls on both of you — but it begins with you.</p>
    <button class="begin-btn" @click="$emit('advance')">
      Where this leads <span class="arrow">→</span>
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
# SCREEN 2: THE HIRE (interactive, unchanged)
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TheHire.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">A principle you already accept</p>
    <h2 class="display-medium">In each of these situations, who bears moral responsibility?</h2>
    <Divider />

    <div class="scenarios">
      <div v-for="s in scenarios" :key="s.id" class="scenario">
        <div class="scenario-setup">{{ s.setup }}</div>
        <div class="scenario-choices">
          <button
            v-for="opt in s.options"
            :key="opt.id"
            class="choice-btn"
            :class="{ selected: answers[s.id] === opt.id }"
            @click="choose(s.id, opt.id)"
          >{{ opt.label }}</button>
        </div>
        <p v-if="answers[s.id]" class="scenario-note">{{ s.note }}</p>
      </div>
    </div>

    <div v-if="allAnswered">
      <ContentBlock variant="principle">
        <p>In every legal system and moral tradition people take seriously, the person who authorizes an action shares responsibility for it. Hiring someone to steal makes you a thief. Hiring someone to commit violence makes you complicit. The intermediary doesn't absorb your moral responsibility. It transfers through them.</p>
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

const scenarios = [
  {
    id: 'theft',
    setup: 'You pay someone $500 to break into your neighbor\'s house and take their television.',
    options: [
      { id: 'you', label: 'You are responsible' },
      { id: 'them', label: 'Only the person you hired' },
      { id: 'both', label: 'Both of you' }
    ],
    note: 'Every court in every country would hold you responsible. You are the principal. The person you hired is your agent.'
  },
  {
    id: 'violence',
    setup: 'You pay a private enforcer to threaten a business owner into giving you a percentage of their revenue.',
    options: [
      { id: 'you', label: 'You are responsible' },
      { id: 'them', label: 'Only the enforcer' },
      { id: 'both', label: 'Both of you' }
    ],
    note: 'This is extortion. You ordered it. The enforcer carried it out. The law and common morality hold you both accountable.'
  },
  {
    id: 'group',
    setup: 'You and nine friends vote 6-4 to hire someone to take money from the four who voted no.',
    options: [
      { id: 'six', label: 'The six who voted yes' },
      { id: 'hired', label: 'Only the person hired' },
      { id: 'all', label: 'No one — it was a majority vote' }
    ],
    note: 'A vote doesn\'t change the nature of the act. Six people authorized taking money from four. The moral weight falls on those who voted for it.'
  }
]

const allAnswered = computed(() => Object.keys(answers.value).length === scenarios.length)

function choose(scenarioId, optionId) {
  answers.value[scenarioId] = optionId
  trackChoice('exp05', 'hire-' + scenarioId, optionId)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.scenarios { margin: 2rem 0; display: flex; flex-direction: column; gap: 2rem; }
.scenario-setup { font-family: var(--serif); font-size: 0.95rem; line-height: 1.6; color: var(--ink); margin-bottom: 0.75rem; padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.scenario-choices { display: flex; flex-wrap: wrap; gap: 0.4rem; }
.choice-btn { padding: 0.55rem 1rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.78rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.choice-btn:hover { border-color: var(--ochre); }
.choice-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
.scenario-note { font-size: 0.8rem; color: var(--ink-faint); font-style: italic; margin-top: 0.5rem; line-height: 1.55; }
</style>
VUEEOF

echo "  ✓ TheHire (interactive)"

# ══════════════════════════════════════
# SCREEN 3: THE VOTE (unchanged)
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TheVote.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">What changes when the intermediary is a government?</h2>
    <Divider />

    <p class="body-text-large">You just established that hiring someone to take, threaten, or coerce makes you morally responsible for the taking, the threatening, and the coercing. The intermediary doesn't absorb the moral weight.</p>

    <ScenarioBox label="The parallel">
      <p>When you vote for a politician who promises to tax your neighbor, regulate your neighbor's business, or imprison your neighbor for choices you disapprove of, you are hiring an agent to act on your behalf.</p>
      <p>The politician is the intermediary. The police are the enforcement mechanism. But you — the voter — are the principal. You authorized it.</p>
    </ScenarioBox>

    <p class="body-text">The mechanism is more complex. The chain of authority is longer. The language is more polished. But the structure is identical: one person authorizes force against another person's body, property, or time, carried out by an agent.</p>

    <ContentBlock variant="mirror">
      <p>In Experience 01, you saw that most people wouldn't personally take James's money but would vote for a politician to do it. Now the question is sharper: if hiring a private individual to take James's money makes you responsible for the theft, does hiring a public official to do the same thing make you any less responsible?</p>
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

echo "  ✓ TheVote"

# ══════════════════════════════════════
# SCREEN 4: TRACE THE CHAIN — interactive
# Pick a policy, then build the enforcement chain step by step
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TraceTheChain.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Trace the chain</p>
    <h2 class="display-medium">Pick a policy. Then follow the enforcement chain to the end.</h2>
    <Divider />

    <p class="body-text">Most political language hides the chain between a vote and the force it produces. Pick one policy and we'll walk through it together.</p>

    <div class="policy-choices">
      <button
        v-for="p in policies"
        :key="p.id"
        class="policy-btn"
        :class="{ selected: chosenPolicy === p.id }"
        @click="choosePolicy(p.id)"
      >{{ p.label }}</button>
    </div>

    <div v-if="chosenPolicy" class="chain">
      <div
        v-for="(step, idx) in currentChain"
        :key="idx"
        class="chain-step"
        :class="{ revealed: revealedSteps > idx }"
      >
        <div class="chain-num">{{ idx + 1 }}</div>
        <div class="chain-content">
          <div class="chain-actor">{{ step.actor }}</div>
          <p class="chain-action">{{ step.action }}</p>
        </div>
      </div>

      <button
        v-if="revealedSteps < currentChain.length"
        class="reveal-btn"
        @click="revealNext"
      >
        Then what happens? <span class="arrow">→</span>
      </button>

      <div v-if="revealedSteps >= currentChain.length" class="chain-complete">
        <ContentBlock variant="mirror">
          <p>That is the full chain. It begins with a voter and ends with an armed agent at someone's door. Every link in the chain exists because the link before it authorized it. And the first link — the one that set the entire chain in motion — is the vote.</p>
        </ContentBlock>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosenPolicy || revealedSteps < currentChain.length"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
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
const chosenPolicy = ref(null)
const revealedSteps = ref(0)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const policies = [
  { id: 'income-tax', label: 'Income tax' },
  { id: 'drug-prohibition', label: 'Drug prohibition' },
  { id: 'licensing', label: 'Occupational licensing' },
  { id: 'property-tax', label: 'Property tax' },
]

const chains = {
  'income-tax': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to fund programs through income taxation.' },
    { actor: 'The legislature', action: 'Passes a tax law requiring citizens to surrender a percentage of their earnings.' },
    { actor: 'The IRS', action: 'Sends a notice to your neighbor demanding payment.' },
    { actor: 'Your neighbor', action: 'Believes the amount is unjust and declines to pay.' },
    { actor: 'The IRS', action: 'Sends increasingly threatening letters. Imposes penalties. Garnishes wages. Places liens on property.' },
    { actor: 'Your neighbor', action: 'Still refuses. Has broken no law except declining to surrender their earnings.' },
    { actor: 'Federal agents', action: 'Arrive at your neighbor\'s home. Armed. They seize property, freeze bank accounts, or arrest your neighbor and transport them to a cage.' },
  ],
  'drug-prohibition': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who supports criminalizing drug possession.' },
    { actor: 'The legislature', action: 'Passes a law making possession of certain substances a felony.' },
    { actor: 'Police', action: 'Identify your neighbor as a suspected user based on a tip, surveillance, or a traffic stop.' },
    { actor: 'A judge', action: 'Issues a warrant based on probable cause of possession.' },
    { actor: 'A SWAT team', action: 'Breaks down your neighbor\'s door, often before dawn. Weapons drawn. Flash grenades deployed.' },
    { actor: 'Your neighbor', action: 'Is handcuffed, processed, and transported to jail. Their only action was consuming a substance in their own home.' },
    { actor: 'The court system', action: 'Prosecutes your neighbor. If convicted, they spend years in a cell. Their career, family, and future are permanently damaged.' },
  ],
  'licensing': [
    { actor: 'You (the voter)', action: 'Support laws requiring government licenses to practice certain professions.' },
    { actor: 'The legislature', action: 'Passes a law requiring a license to braid hair, arrange flowers, or practice interior design.' },
    { actor: 'A licensing board', action: 'Requires hundreds of hours of training, thousands of dollars in fees, and passing an exam — often written by existing practitioners who benefit from limiting competition.' },
    { actor: 'Your neighbor', action: 'Starts a small business without the license because they can\'t afford the fees or the time away from earning income.' },
    { actor: 'An inspector', action: 'Discovers the unlicensed business. Issues a cease-and-desist order and a fine.' },
    { actor: 'Your neighbor', action: 'Continues working because this is how they feed their family.' },
    { actor: 'Law enforcement', action: 'Arrives to enforce the court order. Your neighbor is arrested for the crime of working without government permission.' },
  ],
  'property-tax': [
    { actor: 'You (the voter)', action: 'Vote for local officials who fund public services through property taxation.' },
    { actor: 'The county', action: 'Assesses your neighbor\'s home at a value and sends an annual tax bill.' },
    { actor: 'Your neighbor', action: 'An elderly person on a fixed income. They own their home outright — no mortgage. But they can\'t afford the tax bill.' },
    { actor: 'The county', action: 'Adds penalties and interest. Places a lien on the property.' },
    { actor: 'Your neighbor', action: 'Still cannot pay. They have lived in this home for 40 years.' },
    { actor: 'The county', action: 'Initiates a tax sale. The home your neighbor spent a lifetime paying for is auctioned to satisfy a debt to the government.' },
    { actor: 'Your neighbor', action: 'Is evicted from the home they built their life in. If they refuse to leave, armed deputies will remove them.' },
  ]
}

const currentChain = computed(() => chains[chosenPolicy.value] || [])

function choosePolicy(id) {
  chosenPolicy.value = id
  revealedSteps.value = 1
  trackChoice('exp05', 'chain-policy', id)
}

function revealNext() {
  if (revealedSteps.value < currentChain.value.length) {
    revealedSteps.value++
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.policy-choices { margin: 1.5rem 0; display: flex; flex-wrap: wrap; gap: 0.5rem; }
.policy-btn { padding: 0.6rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.policy-btn:hover { border-color: var(--ochre); }
.policy-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }

.chain { margin: 2rem 0; }
.chain-step { display: flex; gap: 1rem; align-items: flex-start; padding: 0.75rem 0; opacity: 0; transform: translateY(8px); transition: opacity 0.4s ease, transform 0.4s ease; }
.chain-step.revealed { opacity: 1; transform: translateY(0); }
.chain-num { flex-shrink: 0; width: 24px; height: 24px; border-radius: 50%; background: var(--ochre-faint); color: var(--ochre); font-family: var(--serif); font-size: 0.75rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.chain-actor { font-family: var(--serif); font-size: 0.88rem; font-weight: 500; color: var(--ink); margin-bottom: 0.1rem; }
.chain-action { font-size: 0.82rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.reveal-btn { display: block; margin: 1.5rem auto; padding: 0.7rem 1.5rem; background: transparent; border: 1.5px solid var(--ochre); border-radius: 100px; font-family: var(--serif); font-size: 0.88rem; color: var(--ochre); cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.reveal-btn:hover { background: var(--ochre-faint); }
.reveal-btn .arrow { display: inline-block; transition: transform 0.2s ease; }
.reveal-btn:hover .arrow { transform: translateX(3px); }

.chain-complete { margin-top: 1.5rem; }
</style>
VUEEOF

echo "  ✓ TraceTheChain (interactive)"

# ══════════════════════════════════════
# SCREEN 5: THE DEFENSES (trimmed — only new arguments)
# Removed "the majority agreed" (covered in Exp02)
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TheDefenses.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The defenses</p>
    <h2 class="display-medium">Three things people say to avoid this conclusion.</h2>
    <Divider />

    <div class="defenses">
      <div v-for="d in defenses" :key="d.id" class="defense" :class="{ expanded: expanded === d.id }" @click="toggleExpand(d.id)">
        <div class="defense-header">
          <div class="defense-claim">{{ d.claim }}</div>
          <div class="defense-toggle">{{ expanded === d.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === d.id" class="defense-body">
          <p class="defense-response">{{ d.response }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="concession" label="The honest complexity">
      <p>Moral responsibility in a democracy exists on a spectrum. You didn't design the system. You were born into it. You may have voted against the specific policy. The philosophy acknowledges this. But it insists that the spectrum runs from "fully responsible" to "complicit by participation" — not from "responsible" to "innocent." Living within a coercive system and benefiting from it doesn't make you evil. But it doesn't make you uninvolved.</p>
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

const defenses = [
  {
    id: 'just-voting',
    claim: '"I was just voting. That\'s different from personally doing it."',
    response: 'Hiring a hitman is "just making a phone call." Commissioning a theft is "just writing a check." The directness of the action doesn\'t determine the moral weight. What matters is whether you authorized the outcome. When you vote for a policy knowing it will be enforced through the threat of imprisonment, you authorize that enforcement. The ballot is the authorization.'
  },
  {
    id: 'had-to',
    claim: '"I didn\'t have a choice — these are the only options on the ballot."',
    response: 'A constrained choice is still a choice. When you choose between two candidates who both support coercive policies, you are choosing which form of force to authorize — not whether to authorize force at all. The system constrains your options, but the constraint doesn\'t erase your agency. A person who pulls a lever because a gun is at their head has reduced responsibility. A person who pulls a lever because the other levers are slightly worse does not.'
  },
  {
    id: 'common-good',
    claim: '"I was voting for the common good."',
    response: 'The person who hires someone to steal also believes they have a good reason — maybe they intend to give the money to charity. Every act of coercion in history has been justified by its beneficiaries. Good intentions don\'t transform the nature of the act. They explain why you authorized it. They don\'t change what you authorized.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.defenses { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.defense { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.defense:hover { border-color: var(--concede-warm); }
.defense.expanded { border-color: var(--concede-warm); }
.defense-header { display: flex; justify-content: space-between; align-items: flex-start; padding: 0.85rem 1.1rem; gap: 0.75rem; }
.defense-claim { font-family: var(--serif); font-size: 0.92rem; font-weight: 500; color: var(--ink); font-style: italic; }
.defense-toggle { font-size: 1.2rem; color: var(--concede-warm); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.defense-body { padding: 0 1.1rem 1.1rem; }
.defense-response { font-size: 0.85rem; line-height: 1.7; color: var(--ink-muted); margin: 0; }
</style>
VUEEOF

echo "  ✓ TheDefenses (trimmed)"

# ══════════════════════════════════════
# SCREEN 6: TRANSLATE THE POLICY — interactive
# Visitor picks the most accurate translation
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TranslateThePolicy.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Translate the language</p>
    <h2 class="display-medium">Political language obscures what you're actually authorizing. Translate it.</h2>
    <Divider />

    <p class="body-text">For each statement, choose the translation that most accurately describes the force being authorized.</p>

    <div class="translations">
      <div v-for="(t, idx) in translations" :key="t.id" class="translation-block">
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
        <p>The language of politics is engineered to sound reasonable. "Funding public services." "Protecting consumers." "Ensuring compliance." Behind every one of these phrases is a chain of authorization that ends with armed agents and a cage. The philosophy asks you to see through the language to the force underneath — not to make you angry, but to make you honest about what you're choosing.</p>
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
      { id: 'b', text: 'I authorize armed agents to take money from people who would rather spend it differently, and to penalize medical professionals who practice outside approved boundaries.', correct: true },
      { id: 'c', text: 'I believe healthcare is a human right.', correct: false },
    ],
    actual: 'I authorize the seizure of earnings from every working person to fund a system designed by political actors, and I authorize penalties — including fines and imprisonment — against anyone who provides or obtains healthcare outside the approved system.'
  },
  {
    id: 'borders',
    sanitized: 'I support strong borders.',
    options: [
      { id: 'a', text: 'I want to protect our country and culture.', correct: false },
      { id: 'b', text: 'I authorize armed agents to detain, cage, and deport people whose only action was crossing a line drawn by a government to work and feed their families.', correct: true },
      { id: 'c', text: 'I believe nations have a right to self-determination.', correct: false },
    ],
    actual: 'I authorize armed agents to patrol borders, detain people in facilities, separate families, and forcibly transport human beings to places they fled — for the act of moving across a line on a map without government permission.'
  },
  {
    id: 'education',
    sanitized: 'I support public education.',
    options: [
      { id: 'a', text: 'I want every child to have access to learning.', correct: false },
      { id: 'b', text: 'I authorize compulsory funding from all property owners regardless of whether they have children, and I authorize truancy enforcement against parents who educate their children outside the approved system.', correct: true },
      { id: 'c', text: 'I believe education is the foundation of democracy.', correct: false },
    ],
    actual: 'I authorize the seizure of property from every homeowner to fund schools they may never use, designed by political actors and administered by bureaucracies. I authorize the state to dictate how children are educated and to threaten parents with fines or custody action if they choose differently.'
  },
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
.translation-block { }
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
VUEEOF

echo "  ✓ TranslateThePolicy (interactive)"

# ══════════════════════════════════════
# SCREEN 7: THE QUESTION (closing, unchanged)
# ══════════════════════════════════════

cat > src/components/experiences/exp05/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">What are you willing to authorize?</h2>
    <Divider />

    <p class="body-text-large">Every political position is an answer to this question. Every vote is an act of authorization. The philosophy asks you to see it clearly and choose deliberately.</p>

    <ContentBlock variant="principle">
      <p>If you would not personally walk up to your neighbor and take their money, threaten their freedom, or cage them for their choices, then voting for someone else to do it does not change the moral weight. It changes the distance.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="What the philosophy does not ask">
      <p>It does not ask you to stop participating in democracy. It does not ask you to feel guilty for past votes. It asks you to carry one question into every political decision you make from now on: "Am I willing to authorize force against a peaceful person for this?" If the answer is yes, own it with open eyes. If the answer is no, find another way.</p>
    </ContentBlock>

    <NewsletterSignup variant="minimal" source="exp05_closing" headline="One question per week, applied to real policy." description="A short email translating a real political proposal into the force it authorizes. No spin. Just the chain of authority, made visible." button-text="Subscribe" />
    <JourneyNav current="exp05" />
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

# Clean up old files that may exist from first version
rm -f src/components/experiences/exp05/TheLedger.vue
rm -f src/components/experiences/exp05/WhatAgencyAsks.vue

echo ""
echo "✅ Experience 05: Human Agency (revised) — built!"
echo ""
echo "Three interactive moments:"
echo "  Screen 2 — TheHire: pick who bears responsibility (3 scenarios)"
echo "  Screen 4 — TraceTheChain: pick a policy, reveal enforcement chain step by step"
echo "  Screen 6 — TranslateThePolicy: quiz — pick the accurate force translation"
echo ""
echo "Zero duplication with Practice01 or Exp02."
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp05: human agency (revised, 3 interactive)' && git push"
