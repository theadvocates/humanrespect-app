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
