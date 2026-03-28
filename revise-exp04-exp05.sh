#!/bin/bash
# Revised Exp04 (The Realist) + Exp05 (Human Agency)
# - Exp04: examples reframed as flourishing failures, not public choice economics
# - Exp05: politically balanced, references new Exp01, no James/Sarah
# Run from humanrespect-app/ root

set -e

echo "🏗️  Revising Exp04 + Exp05..."

# ══════════════════════════════════════════════════════════
#
#   EXP04 — THE REALIST OBJECTION
#   Only PredictableResults needs rewriting
#   Opening, HumanNature, TheExperiment, TheContradiction,
#   TheReframe, TheQuestion are all strong — keeping them
#   except TheExperiment which needs emoji removal
#
# ══════════════════════════════════════════════════════════

# ── TheExperiment — remove emoji, clean up ──

cat > src/components/experiences/exp04/TheExperiment.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">Take everything you just said about human nature. Now give those humans a specific set of tools.</h2>
    <Divider />

    <div class="tools-list">
      <div class="tool-item">
        <p>The legal authority to take anyone's money or property</p>
      </div>
      <div class="tool-item">
        <p>The power to put people in cages for disobeying</p>
      </div>
      <div class="tool-item">
        <p>A monopoly on the legitimate use of violence</p>
      </div>
      <div class="tool-item">
        <p>The ability to write the rules everyone else must follow</p>
      </div>
      <div class="tool-item">
        <p>Legal immunity for most of what they do with these tools</p>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">You said people {{ topTraitSummary }}. What do you predict happens when those same people get these tools?</p>

    <ContentBlock variant="mirror">
      <p>You don't need this philosophy to answer that. Your own observations about human nature already predict exactly what happens. The question is whether you've applied those observations consistently.</p>
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
.tools-list { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.tool-item { padding: 0.85rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); }
.tool-item p { margin: 0; font-size: 0.92rem; line-height: 1.55; color: var(--ink); }
</style>
VUEEOF

echo "  ✓ Exp04 TheExperiment (cleaned up)"

# ── PredictableResults — completely rewritten ──
# Each example now maps to a Domain of Human Integrity
# Examples span political identities
# Human stories, not economic analyses

cat > src/components/experiences/exp04/PredictableResults.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The results</p>
    <h2 class="display-medium">When you give flawed humans coercive power over other humans, the damage follows the same pattern every time.</h2>
    <Divider />

    <p class="body-text">Each of these is a story about one of the three domains of integrity you identified in your own life — body, resources, or time. In every case, the people with power did exactly what your model of human nature predicts.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card" :class="{ expanded: expanded === ex.id }" @click="toggleExpand(ex.id)">
        <div class="example-header">
          <div>
            <div class="example-title">{{ ex.title }}</div>
            <div class="example-domain">{{ ex.domain }}</div>
          </div>
          <div class="example-toggle">{{ expanded === ex.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === ex.id" class="example-body">
          <p class="example-story">{{ ex.story }}</p>
          <p class="example-mechanism">{{ ex.mechanism }}</p>
          <p class="example-prediction">{{ ex.prediction }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>These are not failures of bad people. They are the predictable consequences of the incentive structure itself. Give any group of humans the power to write rules for others, take their property, or restrict their freedom — with minimal personal cost for getting it wrong — and these outcomes follow as reliably as water flows downhill.</p>
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
    id: 'mandatory-min',
    title: 'The judge who couldn\'t judge',
    domain: 'Bodily integrity',
    story: 'A first-time offender, a young father who made a single terrible decision, stands before a judge. The judge has read the case. She knows the circumstances — the man\'s addiction, his children, his employer who wants him back. She knows that a short sentence with treatment would give him a real chance. But her hands are tied. A mandatory minimum, written by legislators who never met this man and never will, requires her to sentence him to fifteen years.',
    mechanism: 'The people who wrote the sentencing law will never see its consequences. They wrote it to appear "tough on crime" before an election. The judge who sees the human cost has no power to change it. The man\'s children will grow up without a father — not because justice required it, but because the incentives of the people who wrote the law had nothing to do with justice.',
    prediction: 'Separate the people who write the rules from the people who live under them, and the rules will serve the rule-writers. This is what you said about human nature. Applied consistently, it predicts exactly this.'
  },
  {
    id: 'seized-home',
    title: 'The house that wasn\'t for sale',
    domain: 'Material integrity',
    story: 'A woman has lived in her house for forty years. She raised her children there. Her husband died there. The city decides her neighborhood would generate more tax revenue as a shopping center. They invoke eminent domain — the legal power to take private property for "public use." She doesn\'t want to sell. The amount they offer doesn\'t cover a comparable home. It doesn\'t matter. The city takes her house, demolishes it, and hands the land to a private developer. The shopping center is never built. The lot sits empty for a decade.',
    mechanism: 'The developer who lobbied for the project had everything to gain and nothing to lose. The city officials who approved it would benefit from higher tax revenue projections. The woman who lost her home had no leverage against either. Her property — forty years of her life made physical — was taken by people who had the legal power to do it and the political incentive to use it.',
    prediction: 'You said people favor their own group and act in their own interest. The developer and the politicians were in the same group. The homeowner was not.'
  },
  {
    id: 'family-separation',
    title: 'The children who needed protection from their protectors',
    domain: 'Bodily integrity + connection',
    story: 'A mother lets her nine-year-old walk three blocks to a park in a safe neighborhood. A stranger calls the police. Child protective services investigates. The children are temporarily removed while the case is processed. The mother — who has never harmed her children — spends four months navigating a bureaucratic system designed to protect children, fighting to get her own children back. During those months, the children live with strangers.',
    mechanism: 'The caseworker followed protocol. The protocol was written by people who face consequences for under-reacting (a child harmed on their watch) but not for over-reacting (a family destroyed by excessive intervention). The incentive structure guarantees over-intervention — because the bureaucrat\'s career is at risk if they miss something, but no one\'s career is at risk if they tear apart a healthy family.',
    prediction: 'You said people prioritize short-term rewards over long-term consequences. For the caseworker, the short-term reward is protecting their own career. The long-term consequence — a family traumatized, children who learn that authority figures can take them from their parents at any moment — falls on someone else entirely.'
  },
  {
    id: 'cant-help',
    title: 'The volunteers who were told to stop helping',
    domain: 'Temporal integrity + cooperation',
    story: 'A hurricane devastates a coastal city. Within hours, hundreds of people with boats drive to the area and start pulling families out of flooded homes. Then official emergency management arrives and orders the volunteer rescuers to stop. They don\'t have proper credentials. Their boats haven\'t been inspected. They haven\'t completed the required safety training. While the paperwork is sorted out, people wait on rooftops.',
    mechanism: 'The emergency management officials aren\'t malicious. They\'re following rules designed by people who prioritized institutional liability over human lives. The rules exist to protect the agency from lawsuits, not to protect the people drowning. When the incentive is "don\'t let anything happen that could be blamed on us," the rational response is to prevent anyone from acting without authorization — even when unauthorized action is saving lives.',
    prediction: 'You said good intentions frequently produce bad outcomes when the incentives are wrong. The people who wrote the emergency management regulations genuinely intended to ensure safe, coordinated rescue. The result was a system that stopped the fastest, most effective help from reaching the people who needed it.'
  },
  {
    id: 'poverty-trap',
    title: 'The woman who couldn\'t afford to earn more',
    domain: 'Temporal integrity + autonomy',
    story: 'A single mother on government assistance gets a job offer that would pay $2,400 more per year than her current income. She does the math. The raise would cost her $4,100 in lost benefits — housing subsidy, childcare assistance, food support. Taking the job would make her family poorer. So she turns it down. She\'s not lazy. She\'s trapped by a system that penalizes the very steps that would move her toward independence.',
    mechanism: 'The programs were designed by people who would never personally experience their structure. No legislator has ever had to calculate whether a raise would trigger a benefits cliff that leaves their children hungry. The perverse incentive — that earning more means losing more — exists because the people who designed it bear no cost when it fails. Their metric is "number of people served," not "number of people who escaped the need for service."',
    prediction: 'You said people who gain power tend to use it to benefit themselves. The agencies that administer these programs grow their budgets based on the number of recipients. A program that successfully moved everyone to independence would eliminate its own funding. The institutional incentive is to manage poverty, not end it.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.example-card { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.example-card:hover { border-color: var(--ochre); }
.example-card.expanded { border-color: var(--ochre); }
.example-header { display: flex; justify-content: space-between; align-items: flex-start; padding: 0.85rem 1.1rem; gap: 0.75rem; }
.example-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.example-domain { font-size: 0.7rem; color: var(--ochre); letter-spacing: 0.05em; margin-top: 0.15rem; }
.example-toggle { font-size: 1.2rem; color: var(--ochre); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.example-body { padding: 0 1.1rem 1.1rem; }
.example-body p { font-size: 0.85rem; line-height: 1.7; color: var(--ink-muted); margin: 0 0 0.85rem; }
.example-body p:last-child { margin-bottom: 0; }
.example-story { color: var(--ink) !important; }
.example-mechanism { }
.example-prediction { font-style: italic; color: var(--ink-faint) !important; }
</style>
VUEEOF

echo "  ✓ Exp04 PredictableResults (rewritten — human stories, three domains)"

# ══════════════════════════════════════════════════════════
#
#   EXP05 — HUMAN AGENCY
#   Revise: TheVote (remove James reference)
#           TraceTheChain (politically balanced policies)
#           TranslateThePolicy (balanced across spectrum)
#
# ══════════════════════════════════════════════════════════

# ── TheVote — rewritten for new Exp01 ──

cat > src/components/experiences/exp05/TheVote.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">What changes when the intermediary is a government?</h2>
    <Divider />

    <p class="body-text-large">You just established that hiring someone to take, threaten, or coerce makes you morally responsible for the taking, the threatening, and the coercing. The intermediary doesn't absorb the moral weight.</p>

    <ScenarioBox label="The parallel">
      <p>When you vote for a politician who promises to tax your neighbor, regulate how your neighbor earns a living, or imprison your neighbor for choices you disapprove of, you are hiring an agent to act on your behalf.</p>
      <p>The politician is the intermediary. The police are the enforcement mechanism. But you — the voter — are the principal. You authorized it.</p>
    </ScenarioBox>

    <p class="body-text">The mechanism is more complex. The chain of authority is longer. The language is more polished. But the structure is identical: one person authorizes force against another person's body, property, or time, carried out by an agent.</p>

    <ContentBlock variant="mirror">
      <p>In Experience 01, you recognized that you wouldn't use force to resolve a disagreement with someone you care about — because you know what force does to people. When you vote for a policy that will be enforced through the threat of fines, seizure, or imprisonment, you are authorizing that same force against people every bit as real as the person you were thinking about. The distance doesn't change the effect. It changes how easily you can look away.</p>
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

echo "  ✓ Exp05 TheVote (new Exp01 reference)"

# ── TraceTheChain — politically balanced ──

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
          <p>That is the full chain. It begins with a vote and ends with armed agents and a cage. Every link exists because the link before it authorized it. The first link — the one that set the entire chain in motion — is a person who believed they were choosing something good.</p>
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
  { id: 'gun-regulation', label: 'Firearm restrictions' },
  { id: 'environmental', label: 'Environmental regulation' },
]

const chains = {
  'income-tax': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to fund programs through income taxation.' },
    { actor: 'The legislature', action: 'Passes a tax law requiring citizens to surrender a percentage of their earnings.' },
    { actor: 'The IRS', action: 'Sends a notice to your neighbor demanding payment.' },
    { actor: 'Your neighbor', action: 'Believes the amount is unjust and declines to pay.' },
    { actor: 'The IRS', action: 'Sends threatening letters. Imposes penalties. Garnishes wages. Places liens on property.' },
    { actor: 'Your neighbor', action: 'Still refuses. They haven\'t harmed anyone. They simply declined to surrender their earnings.' },
    { actor: 'Federal agents', action: 'Arrive at your neighbor\'s home. Armed. They seize property, freeze bank accounts, or arrest your neighbor and put them in a cell.' },
  ],
  'drug-prohibition': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who supports criminalizing drug possession.' },
    { actor: 'The legislature', action: 'Passes a law making possession of certain substances a felony.' },
    { actor: 'Police', action: 'Identify your neighbor as a suspected user based on a tip or a traffic stop.' },
    { actor: 'A judge', action: 'Issues a warrant based on probable cause.' },
    { actor: 'A SWAT team', action: 'Breaks down your neighbor\'s door before dawn. Weapons drawn. Flash grenades deployed. Children screaming.' },
    { actor: 'Your neighbor', action: 'Is handcuffed on the floor of their own home. Their only action was consuming a substance in private.' },
    { actor: 'The court system', action: 'Prosecutes. Mandatory minimum: five years. Their career, their family, their children\'s stability — destroyed. For a choice that harmed no one but themselves.' },
  ],
  'gun-regulation': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to ban certain firearms.' },
    { actor: 'The legislature', action: 'Passes a law requiring owners of newly prohibited weapons to surrender them.' },
    { actor: 'The government', action: 'Sends notices to registered owners: turn in your firearms by the deadline or face felony charges.' },
    { actor: 'Your neighbor', action: 'A lifelong hunter and target shooter. Has never committed a crime. Believes the ban violates a fundamental right. Refuses to comply.' },
    { actor: 'Law enforcement', action: 'Obtains a warrant. Arrives at your neighbor\'s home to execute a search and seizure.' },
    { actor: 'Your neighbor', action: 'Faces a choice: surrender property they\'ve owned legally for decades, or resist agents with guns who have come to take their guns.' },
    { actor: 'The situation', action: 'Armed agents enforcing a policy against an armed citizen who has harmed no one. The potential for violence is embedded in the design of the policy itself.' },
  ],
  'environmental': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises stricter environmental protections.' },
    { actor: 'A regulatory agency', action: 'Issues new rules classifying a portion of your neighbor\'s land as protected wetland. They cannot build, farm, or develop it.' },
    { actor: 'Your neighbor', action: 'A small farmer who bought this land with thirty years of savings. The protected portion is 60% of their property. They weren\'t consulted. They received no compensation.' },
    { actor: 'Your neighbor', action: 'Plants crops on the restricted portion because their family depends on the income. They are not polluting. They are farming land they own.' },
    { actor: 'The agency', action: 'Issues a cease-and-desist order and a fine of $75,000 per day of violation.' },
    { actor: 'Your neighbor', action: 'Cannot afford the fine. Cannot afford a lawyer to fight it. Cannot sell the now-worthless land.' },
    { actor: 'Federal agents', action: 'Arrive to enforce the order. Your neighbor\'s life savings, their land, and potentially their freedom are taken — for farming their own property.' },
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

echo "  ✓ Exp05 TraceTheChain (politically balanced)"

# ── TranslateThePolicy — balanced across spectrum ──

cat > src/components/experiences/exp05/TranslateThePolicy.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Translate the language</p>
    <h2 class="display-medium">Political language obscures what you're actually authorizing. Translate it.</h2>
    <Divider />

    <p class="body-text">Each of these statements sounds reasonable. For each one, choose the translation that most accurately describes the force being authorized. These span the political spectrum deliberately — the philosophy doesn't take sides.</p>

    <div class="translations">
      <div v-for="t in translations" :key="t.id" class="translation-block">
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
        <p>Notice that these translations cut across the political spectrum. Progressive policies use force. Conservative policies use force. The philosophy doesn't ask you to abandon your values. It asks you to see the method clearly — and then decide whether that method is consistent with what you know about how force affects human beings.</p>
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
      { id: 'b', text: 'I authorize the seizure of earnings from every working person and penalties against anyone who provides or obtains care outside the approved system.', correct: true },
      { id: 'c', text: 'I believe healthcare is a human right that society should guarantee.', correct: false },
    ],
    actual: 'I authorize armed agents to take a portion of every working person\'s earnings to fund a system designed by political actors. I authorize fines and imprisonment for anyone who provides medical care outside approved channels — including a doctor who charges less than the approved rate, or a patient who buys medication from abroad.'
  },
  {
    id: 'drug-war',
    sanitized: 'I support the war on drugs.',
    options: [
      { id: 'a', text: 'I want to protect communities from the damage of addiction.', correct: false },
      { id: 'b', text: 'I authorize armed raids on homes, imprisonment of people for possessing substances, and the destruction of families — for choices that directly harmed no one else.', correct: true },
      { id: 'c', text: 'I believe certain substances are too dangerous to allow.', correct: false },
    ],
    actual: 'I authorize armed agents to break into homes, cage human beings for years, and permanently destroy their employability, their families, and their futures — for the act of consuming a substance in private. I authorize this knowing that enforcement falls disproportionately on the poorest and most marginalized communities.'
  },
  {
    id: 'rent-control',
    sanitized: 'I support rent control.',
    options: [
      { id: 'a', text: 'I want housing to be affordable for working families.', correct: false },
      { id: 'b', text: 'I authorize the government to dictate what a property owner may charge for the use of their own building, with fines and legal action against anyone who asks for more.', correct: true },
      { id: 'c', text: 'I believe landlords shouldn\'t be able to exploit tenants.', correct: false },
    ],
    actual: 'I authorize the government to override voluntary agreements between property owners and tenants. If a landlord charges more than the approved rate — even if a tenant willingly agrees to pay it — I authorize fines, legal proceedings, and ultimately armed enforcement against the owner. The long-term result, documented across every city that has tried it: housing shortages, deteriorating buildings, and a black market that hurts the people the policy was meant to protect.'
  },
  {
    id: 'mandatory-min',
    sanitized: 'I support mandatory minimum sentences.',
    options: [
      { id: 'a', text: 'I want consistent justice that doesn\'t depend on which judge you get.', correct: false },
      { id: 'b', text: 'I authorize the removal of judicial discretion, requiring judges to cage people for predetermined periods regardless of circumstances, remorse, or likelihood of rehabilitation.', correct: true },
      { id: 'c', text: 'I believe criminals need to face real consequences.', correct: false },
    ],
    actual: 'I authorize legislators who will never meet the defendant to predetermine the sentence. I remove the power of the one person in the system who actually sees the human being — the judge — to exercise judgment. I authorize caging a first-time offender for the same duration as a career criminal, destroying families and producing people more likely to reoffend, because the system that was supposed to rehabilitate them did nothing but warehouse them.'
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
VUEEOF

echo "  ✓ Exp05 TranslateThePolicy (balanced across spectrum)"

echo ""
echo "✅ Exp04 + Exp05 revised!"
echo ""
echo "EXP04 changes:"
echo "  TheExperiment: removed emoji, cleaner prose"
echo "  PredictableResults: completely rewritten"
echo "    - 'The judge who couldn't judge' (mandatory minimums → bodily integrity)"
echo "    - 'The house that wasn't for sale' (eminent domain → material integrity)"
echo "    - 'The children who needed protection from their protectors' (CPS → bodily + connection)"
echo "    - 'The volunteers who were told to stop helping' (disaster response → temporal + cooperation)"
echo "    - 'The woman who couldn't afford to earn more' (benefits cliff → temporal + autonomy)"
echo "    Each maps to a domain of integrity. Each is a human story."
echo "    Each ends by connecting back to the visitor's own human nature observations."
echo ""
echo "EXP05 changes:"
echo "  TheVote: references new Exp01 (relationships, not James/Sarah)"
echo "  TraceTheChain: 4 policies balanced across spectrum"
echo "    - Income tax (universal)"
echo "    - Drug prohibition (progressive-recognized harm)"
echo "    - Firearm restrictions (conservative-recognized overreach)"
echo "    - Environmental regulation (conservative-recognized overreach)"
echo "  TranslateThePolicy: 4 policies balanced across spectrum"
echo "    - Universal healthcare (progressive → force)"
echo "    - War on drugs (conservative → force)"
echo "    - Rent control (progressive → force)"
echo "    - Mandatory minimums (conservative → force)"
echo "    Closing insight: 'These cut across the political spectrum deliberately.'"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp04+05: flourishing-grounded, politically balanced' && git push"
