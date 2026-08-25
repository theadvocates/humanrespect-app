#!/bin/bash
# Smart navigation: context-aware next steps on all closing screens
# Run from humanrespect-app/ root

set -e

echo "🧭 Building smart navigation..."

# ══════════════════════════════════════
# THE SHARED COMPONENT
# ══════════════════════════════════════

cat > src/components/shared/JourneyNav.vue << 'VUEEOF'
<template>
  <div class="journey-nav">
    <!-- Suggested next steps (not yet completed) -->
    <div v-if="nextSteps.length" class="nav-section">
      <p class="caption" style="margin-bottom: 1rem;">{{ nextLabel }}</p>
      <PathCard
        v-for="step in nextSteps"
        :key="step.name"
        :to="{ name: step.name }"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.desc }}</template>
      </PathCard>
    </div>

    <!-- Already completed (revisit) -->
    <div v-if="revisitSteps.length" class="nav-section" style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Revisit</p>
      <PathCard
        v-for="step in revisitSteps"
        :key="step.name"
        :to="{ name: step.name }"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.revisitDesc || step.desc }}</template>
      </PathCard>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  // The current experience — excluded from suggestions
  current: { type: String, required: true },
  // Override the "next steps" label
  nextLabel: { type: String, default: 'Continue your journey' }
})

const journey = useJourneyStore()

// ── All experiences in recommended order ──
const allExperiences = [
  // Foundation
  { name: 'exp01', title: 'The Question', desc: 'A five-minute thought experiment that reveals the gap between personal and political morality.', revisitDesc: 'Revisit the thought experiment that started everything.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection — or revisit your original one.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Actually Means', desc: 'Discover the empirical grounding for the principle — from your own life experience.', revisitDesc: 'Revisit the Six Pillars and Three Domains framework.', tier: 'foundation', order: 3 },

  // Pillars
  { name: 'pillarA', title: 'Your Body Is Not Negotiable', desc: 'Bodily integrity — why safety is the precondition for all flourishing.', revisitDesc: 'Revisit the first domain of human integrity.', tier: 'pillar', order: 4 },
  { name: 'pillarB', title: 'Your Time Is Your Life', desc: 'Time as the irreplaceable substance of life — the philosophy\'s most original insight.', revisitDesc: 'Revisit the tax-hours calculation and the hierarchy of irreversibility.', tier: 'pillar', order: 5 },
  { name: 'pillarC', title: 'What You Built Is Who You Were', desc: 'Property as crystallized time — why material integrity matters for flourishing.', revisitDesc: 'Revisit material integrity and the meaning of theft.', tier: 'pillar', order: 6 },
  { name: 'pillarD', title: 'The Method Is the Message', desc: 'Your values aren\'t the problem. The question is force or persuasion.', revisitDesc: 'Revisit the values exercise and the method question.', tier: 'pillar', order: 7 },
  { name: 'pillarE', title: 'Cooperation Is a Technology', desc: 'Real evidence that voluntary cooperation solves problems people assume require force.', revisitDesc: 'Explore voluntary alternatives for a different issue.', tier: 'pillar', order: 8 },

  // Practice
  { name: 'practice01', title: 'Your Political Footprint', desc: 'Map where you currently support coercion in your life.', revisitDesc: 'See if your footprint has changed.', tier: 'practice', order: 9 },
  { name: 'practice02', title: 'The Persuasion Practice', desc: 'Take an issue you care about and design a persuasion-only approach.', revisitDesc: 'Try a different issue this time.', tier: 'practice', order: 10 },
  { name: 'practice03', title: 'The Conversation', desc: 'A framework for discussing Human Respect with someone who disagrees.', revisitDesc: 'Refresh the four-move framework before your next conversation.', tier: 'practice', order: 11 },
  { name: 'practice04', title: 'The Respect Audit', desc: 'Track where you choose persuasion vs. force for 7 days.', revisitDesc: 'Start another 7-day cycle of awareness.', tier: 'practice', order: 12 },
  { name: 'practice05', title: 'Design a Voluntary Solution', desc: 'Pick a real problem in your community and solve it without force.', revisitDesc: 'Design a solution for a different community problem.', tier: 'practice', order: 13 },
]

const isCompleted = (name) => {
  if (name === 'exp01') return journey.exp01.completed
  if (name === 'exp02') return journey.exp02.completed
  return !!journey.completions[name]
}

// Filter out current experience, split into next vs revisit
const others = computed(() => allExperiences.filter(e => e.name !== props.current))

const nextSteps = computed(() => {
  const incomplete = others.value.filter(e => !isCompleted(e.name))

  if (incomplete.length === 0) return []

  // Smart ordering: suggest the natural next tier first
  const currentTier = allExperiences.find(e => e.name === props.current)?.tier
  const tierPriority = getTierPriority(currentTier)

  // Sort by tier priority, then by order within tier
  return incomplete
    .sort((a, b) => {
      const aPri = tierPriority.indexOf(a.tier)
      const bPri = tierPriority.indexOf(b.tier)
      if (aPri !== bPri) return aPri - bPri
      return a.order - b.order
    })
    .slice(0, 3) // Show max 3 suggestions
})

const revisitSteps = computed(() => {
  return others.value
    .filter(e => isCompleted(e.name))
    .sort((a, b) => a.order - b.order)
    .slice(0, 2) // Show max 2 revisit options
})

function getTierPriority(currentTier) {
  // After foundation → suggest pillars first, then remaining foundation, then practice
  // After pillar → suggest other pillars first, then practice, then foundation
  // After practice → suggest other practices first, then pillars, then foundation
  switch (currentTier) {
    case 'foundation': return ['foundation', 'pillar', 'practice']
    case 'pillar': return ['pillar', 'practice', 'foundation']
    case 'practice': return ['practice', 'pillar', 'foundation']
    default: return ['foundation', 'pillar', 'practice']
  }
}
</script>

<style scoped>
.journey-nav {
  margin-top: 2.5rem;
}
</style>
VUEEOF

echo "  ✓ JourneyNav.vue created"

# ══════════════════════════════════════
# UPDATE ALL CLOSING SCREENS TO USE JourneyNav
# ══════════════════════════════════════

# ── Exp01 Invitation ──
cat > src/components/experiences/exp01/Invitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="8" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />
    <p class="body-text-large">You already live by the principle of Human Respect in most of your life. You don't steal from neighbors. You don't threaten coworkers. You solve problems through conversation, persuasion, and voluntary agreement.</p>
    <p class="body-text-large">The question is whether you'll extend that same principle to how you think about politics and society.</p>
    <p class="closing-question">What if every social problem you care about could be addressed through cooperation instead of force — and what if the solutions would actually work better?</p>
    <ContentBlock variant="insight">
      <p>This isn't a question that gets answered in five minutes. It's a question that changes how you see every political argument, every policy debate, every election — for the rest of your life.</p>
    </ContentBlock>

    <PathCard href="#" @click.prevent="share">
      <template #title>Share this experience</template>
      <template #desc>{{ shareDesc }}</template>
    </PathCard>

    <JourneyNav current="exp01" />
    <NewsletterSignup source="exp01_invitation" />

    <p class="body-text" style="text-align: center; margin-top: 2rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

const journey = useJourneyStore()
const { trackShare } = useAnalytics()
const el = ref(null)
const shareDesc = ref('Send this thought experiment to someone you disagree with politically.')

onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp01(journey.exp01.personal, journey.exp01.political)
})

function share() {
  const text = "I just went through a 5-minute thought experiment that showed me something I'd never noticed about my own political beliefs."
  const url = window.location.origin + '/experience/the-question'
  if (navigator.share) {
    navigator.share({ title: 'The Question', text, url })
    trackShare('native', 'exp01')
  } else {
    navigator.clipboard.writeText(text + ' ' + url).then(() => {
      shareDesc.value = 'Link copied to clipboard.'
      trackShare('clipboard', 'exp01')
      setTimeout(() => { shareDesc.value = 'Send this thought experiment to someone you disagree with politically.' }, 2000)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.6rem); line-height: 1.5; color: var(--ink); text-align: center; margin: 2rem 0; font-style: italic; }
</style>
VUEEOF

echo "  ✓ Exp01 Invitation"

# ── Exp02 WhereNext ──
cat > src/components/experiences/exp02/WhereNext.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each objection gets the same treatment — steelmanned, responded to, conceded where honesty requires.</p>

    <div style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard v-for="key in otherObjections" :key="key" href="#" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <JourneyNav current="exp02" next-label="Or continue your journey" />
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
const otherObjections = computed(() => Object.keys(allObjections).filter(k => k !== journey.exp02.chosenObjection))
const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Exp02 WhereNext"

# ── Exp03 TheBridge ──
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
        <div><div class="foundation-title">The gap</div><p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div><div class="foundation-title">The objection</div><p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div><div class="foundation-title">The grounding</div><p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time.</p></div>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">From here, the philosophy goes deeper into each dimension.</p>

    <JourneyNav current="exp03" next-label="Go deeper" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
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

echo "  ✓ Exp03 TheBridge"

# ── Pillar closing screens (A, B, C, D, E) ──
# These all follow the same pattern: closing content + JourneyNav

# Pillar A
cat > src/components/experiences/pillarA/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If physical safety is the precondition for flourishing...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...what does that mean for institutions whose primary tool is the threat of force?</p></ContentBlock>
    <p class="body-text-large">Every law is ultimately backed by the threat of physical enforcement. Every tax carries the implicit promise: comply, or men with guns will eventually come. Every regulation rests on the willingness to cage those who disobey.</p>
    <ContentBlock variant="insight"><p>A society aligned with Human Respect must design systems that protect bodies and restore safety <em>without</em> becoming a source of the fear they're meant to prevent.</p></ContentBlock>
    <JourneyNav current="pillarA" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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

echo "  ✓ Pillar A closing"

# Pillar B
cat > src/components/experiences/pillarB/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />
    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>
    <ContentBlock variant="principle"><p>...then a political system that operates by taking people's time without their individual consent is consuming the very substance of human life.</p></ContentBlock>
    <p class="body-text">This doesn't make the people in government evil. It means the <em>system</em> — the mechanism of compulsory participation — is misaligned with what human beings actually need to flourish.</p>
    <div class="closing-question-block"><p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p></div>
    <ContentBlock variant="insight"><p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks fundamentally different.</p></ContentBlock>
    <JourneyNav current="pillarB" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question-block { margin: 2.5rem 0; text-align: center; padding: 2rem 1.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.7rem); line-height: 1.45; color: var(--ink); font-style: italic; font-weight: 400; }
</style>
VUEEOF

echo "  ✓ Pillar B closing"

# Pillar C
cat > src/components/experiences/pillarC/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p></ContentBlock>
    <p class="body-text-large">If every dollar you earned represents hours of your life, then taking those dollars without your individual consent is taking your life-hours.</p>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>The philosophy doesn't claim that transitioning to voluntary funding is simple. The argument is <em>directional</em>: we should be moving toward more voluntary funding and less compulsory taking.</p></ContentBlock>
    <p class="body-text">The three domains are now complete. Your body, your resources, and your time — each one essential for flourishing, each one deserving of respect.</p>
    <JourneyNav current="pillarC" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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

echo "  ✓ Pillar C closing"

# Pillar D
cat > src/components/experiences/pillarD/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />
    <p class="body-text-large">Not because your values don't matter. Because the method matters as much as the goal — and a world of mutual persuasion produces more flourishing than a world of mutual coercion.</p>
    <ContentBlock variant="principle"><p>Can you hold your deepest values while committing never to force them on another person? And if you can — what would that actually look like in your life, your community, and your politics?</p></ContentBlock>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>This is genuinely hard. When you care deeply about an issue, the temptation to use force is powerful. The philosophy asks you to trust that persuasion and cooperation will produce better outcomes — even for the causes you care about most.</p></ContentBlock>
    <p class="body-text">The political wars of our era are not really about values. They're about method. The moment enough people commit to persuasion over force, the war ends.</p>
    <JourneyNav current="pillarD" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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

echo "  ✓ Pillar D closing"

# Pillar E — keeps the "explore other issues" feature + JourneyNav
cat > src/components/experiences/pillarE/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />
    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies.</p>
    <ContentBlock variant="principle"><p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p></ContentBlock>
    <ContentBlock variant="insight"><p>The Philosophy of Human Respect claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity.</p></ContentBlock>

    <div v-if="otherIssues.length" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another issue</p>
      <PathCard v-for="issue in otherIssues" :key="issue.id" href="#" @click.prevent="$emit('restart-with', issue.id)">
        <template #title>{{ issue.label }}</template>
        <template #desc>See voluntary alternatives for {{ issue.label.toLowerCase() }}.</template>
      </PathCard>
    </div>

    <JourneyNav current="pillarE" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { appliedIssues } from './examplesData.js'

defineEmits(['restart-with'])
const chosenIssue = inject('chosenIssue', ref(null))
const otherIssues = computed(() => appliedIssues.filter(i => i.id !== chosenIssue.value))
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Pillar E closing"

# ── Practice closing screens ──

# Practice 01
cat > src/components/experiences/practice01/TheReflection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />
    <p class="body-text-large">Pick one area where you currently support force and ask yourself: is there a voluntary alternative? Could this be done through persuasion and choice instead of compulsion?</p>
    <ContentBlock variant="insight"><p>Your political footprint shrinks one conscious choice at a time.</p></ContentBlock>
    <JourneyNav current="practice01" />
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

# Practice 02
cat > src/components/experiences/practice02/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If it was, that's the point. We've been trained to reach for force as the default. Designing voluntary solutions requires more creativity, more empathy, and more trust.</p>
    <ContentBlock variant="insight"><p>Whatever you drafted, it respects everyone involved. No one is forced. Every participant chose to be there.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The next time you hear a political proposal, try this: strip out the force. What would the same goal look like through persuasion alone?</p></ContentBlock>
    <JourneyNav current="practice02" />
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

# Practice 03
cat > src/components/experiences/practice03/TheInvitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The most powerful tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">A conclusion someone reaches themselves is a hundred times more powerful than one you handed them. Share <strong>Experience 01</strong> and let them discover the gap on their own.</p>
    <div class="share-block">
      <button class="share-btn" @click="copyLink">{{ copied ? 'Copied!' : 'Copy link to humanrespect.app' }}</button>
    </div>
    <JourneyNav current="practice03" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
const copied = ref(false)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
function copyLink() {
  navigator.clipboard.writeText('https://humanrespect.app').then(() => {
    copied.value = true; setTimeout(() => { copied.value = false }, 2000)
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

# Practice 04
cat > src/components/experiences/practice04/TheCommitment.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play.</p>
    <ContentBlock variant="insight"><p>By the end of seven days, you'll see the force/persuasion question everywhere. That's not the philosophy talking. That's your own observation.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The Philosophy of Human Respect isn't something you adopt in a moment. It's something you discover gradually, as you notice the pattern in your own daily life.</p></ContentBlock>
    <JourneyNav current="practice04" />
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

# Practice 05
cat > src/components/experiences/practice05/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real question</p>
    <h2 class="display-medium">Will you actually do it?</h2>
    <Divider />
    <p class="body-text-large">You just designed a voluntary solution to a real problem. The philosophy says it can work. The evidence says it can work. The question is whether you'll take the first step.</p>
    <ContentBlock variant="principle"><p>You don't need permission. You don't need a law. You need one conversation with one other person who cares about the same problem. Start there.</p></ContentBlock>
    <JourneyNav current="practice05" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
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

echo "  ✓ All practice closings"

echo ""
echo "✅ Smart navigation wired into all 13 closing screens!"
echo ""
echo "How it works:"
echo "  • JourneyNav reads the journey store's completions"
echo "  • Shows up to 3 'next steps' (incomplete experiences, prioritized by tier)"
echo "  • Shows up to 2 'revisit' options (completed experiences)"
echo "  • After completing Pillar B, you'll see other pillars first, then practices"
echo "  • After completing a practice, you'll see other practices first"
echo "  • As you complete more, 'next steps' shrink and 'revisit' grows"
echo ""
echo "Push with: git add . && git commit -m 'smart nav: context-aware journey navigation' && git push"
