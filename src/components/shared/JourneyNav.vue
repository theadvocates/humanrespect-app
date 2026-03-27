<template>
  <div class="journey-nav" v-if="nextSteps.length > 0 || revisitSteps.length > 0">
    <p class="caption" style="margin-bottom: 1rem;">{{ nextLabel || 'Continue your journey' }}</p>

    <div class="steps">
      <PathCard
        v-for="(step, idx) in nextSteps"
        :key="step.name"
        :to="{ name: step.name }"
        :recommended="idx === 0"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.desc }}</template>
      </PathCard>
    </div>

    <div v-if="revisitSteps.length > 0" class="revisit-section">
      <p class="revisit-label">Revisit</p>
      <div class="steps">
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
  </div>
</template>

<script setup>
import { computed } from 'vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  current: { type: String, required: true },
  nextLabel: { type: String, default: '' }
})

const journey = useJourneyStore()

const allExperiences = [
  // Foundation (sequential)
  { name: 'exp01', title: 'The Question', desc: 'A thought experiment that reveals the gap between personal and political morality.', revisitDesc: 'Revisit the thought experiment that started everything.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection or revisit your original one.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Means', desc: 'Discover the empirical grounding for the principle, from your own life experience.', revisitDesc: 'Revisit the Three Domains framework.', tier: 'foundation', order: 3 },
  // Arguments (any order after foundation)
  { name: 'exp04', title: 'The Realist Objection', desc: 'People are flawed. That is the strongest argument for voluntary cooperation over concentrated power.', revisitDesc: 'Revisit the incentive argument against coercive systems.', tier: 'argument', order: 4 },
  { name: 'exp05', title: 'Human Agency', desc: 'If you hire someone to steal, you bear responsibility. What changes when the intermediary is a government?', revisitDesc: 'Revisit the agency argument and the chain of authorization.', tier: 'argument', order: 5 },
  // Pillars (any order)
  { name: 'pillarA', title: 'Bodily Integrity', desc: 'Why safety is the precondition for all flourishing. Who faces force in your name?', revisitDesc: 'Revisit the first domain of human integrity.', tier: 'pillar', order: 6 },
  { name: 'pillarB', title: 'Temporal Integrity', desc: 'Time as the irreplaceable substance of life. How many hours do you give to taxes?', revisitDesc: 'Revisit the tax-hours calculation.', tier: 'pillar', order: 7 },
  { name: 'pillarC', title: 'Material Integrity', desc: 'Property as crystallized time. What have you not built because of insecurity?', revisitDesc: 'Revisit material integrity and the cost of insecurity.', tier: 'pillar', order: 8 },
  { name: 'pillarD', title: 'The Human Respect Method', desc: 'Your values are not the problem. The question is force or persuasion.', revisitDesc: 'Revisit the values exercise and the method question.', tier: 'pillar', order: 9 },
  { name: 'pillarE', title: 'Cooperation as Technology', desc: 'Real evidence that voluntary cooperation solves problems people assume require force.', revisitDesc: 'Explore voluntary alternatives for a different issue.', tier: 'pillar', order: 10 },
  // Practices (any order)
  { name: 'practice01', title: 'Political Footprint', desc: 'Map where force operates in your life vs. where you support it.', revisitDesc: 'See if your footprint has changed.', tier: 'practice', order: 11 },
  { name: 'practice02', title: 'Persuasion Practice', desc: 'Draft a persuasion-only approach to an issue you care about.', revisitDesc: 'Try a different issue this time.', tier: 'practice', order: 12 },
  { name: 'practice03', title: 'The Conversation', desc: 'A framework for discussing Human Respect with someone who disagrees.', revisitDesc: 'Refresh the four-move framework.', tier: 'practice', order: 13 },
  { name: 'practice04', title: 'Respect Audit', desc: 'Notice force vs. persuasion in your daily life for 7 days.', revisitDesc: 'Start another 7-day observation cycle.', tier: 'practice', order: 14 },
  { name: 'practice05', title: 'Design a Solution', desc: 'Pick a real problem. Solve it with zero coercion.', revisitDesc: 'Design a solution for a different problem.', tier: 'practice', order: 15 },
]

function isCompleted(name) {
  if (name === 'exp01') return !!journey.exp01?.completed
  if (name === 'exp02') return !!journey.exp02?.completed
  return !!journey.completions?.[name]
}

const others = computed(() => allExperiences.filter(e => e.name !== props.current))

const nextSteps = computed(() => {
  const incomplete = others.value.filter(e => !isCompleted(e.name))
  if (incomplete.length === 0) return []

  const currentExp = allExperiences.find(e => e.name === props.current)
  const currentTier = currentExp?.tier || 'foundation'

  // Smart ordering based on where we are
  const tierPriority = getTierPriority(currentTier)

  return incomplete
    .sort((a, b) => {
      const aPri = tierPriority.indexOf(a.tier)
      const bPri = tierPriority.indexOf(b.tier)
      if (aPri !== bPri) return aPri - bPri
      return a.order - b.order
    })
    .slice(0, 3)
})

const revisitSteps = computed(() => {
  return others.value
    .filter(e => isCompleted(e.name))
    .sort((a, b) => a.order - b.order)
})

function getTierPriority(currentTier) {
  switch (currentTier) {
    case 'foundation':
      return ['foundation', 'argument', 'pillar', 'practice']
    case 'argument':
      return ['argument', 'pillar', 'practice', 'foundation']
    case 'pillar':
      return ['pillar', 'argument', 'practice', 'foundation']
    case 'practice':
      return ['practice', 'pillar', 'argument', 'foundation']
    default:
      return ['foundation', 'argument', 'pillar', 'practice']
  }
}
</script>

<style scoped>
.journey-nav { margin-top: 3rem; }
.steps { display: flex; flex-direction: column; gap: 0.5rem; }
.revisit-section { margin-top: 2rem; }
.revisit-label { font-size: 0.72rem; letter-spacing: 0.1em; text-transform: uppercase; color: var(--ink-faint); margin-bottom: 0.5rem; }
</style>
