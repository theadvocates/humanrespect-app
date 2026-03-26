#!/bin/bash
# Adds "Recommended next" badge to top suggested card in JourneyNav
# Run from humanrespect-app/ root

cat > src/components/shared/PathCard.vue << 'VUEEOF'
<template>
  <component
    :is="to ? 'router-link' : 'a'"
    :to="to || undefined"
    :href="href || undefined"
    class="path-card"
    :class="{ completed, disabled, recommended }"
    v-bind="$attrs"
  >
    <div class="path-card-content">
      <div class="path-card-header">
        <span v-if="recommended" class="recommended-badge">Recommended next</span>
        <span v-else-if="completed" class="completed-badge">✓ Done</span>
      </div>
      <div class="path-card-title"><slot name="title" /></div>
      <div class="path-card-desc"><slot name="desc" /></div>
    </div>
    <span class="path-arrow" v-if="!disabled">→</span>
  </component>
</template>

<script setup>
defineProps({
  to: { type: [Object, String], default: null },
  href: { type: String, default: null },
  completed: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  recommended: { type: Boolean, default: false }
})
</script>

<style scoped>
.path-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  margin-bottom: 0.75rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  text-decoration: none;
  color: var(--ink);
  transition: all 0.25s ease;
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.path-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
}

.path-card:active { transform: translateY(0); }

/* Recommended state */
.path-card.recommended {
  border-color: var(--ochre);
  background: var(--ochre-faint);
  box-shadow: 0 2px 12px rgba(154, 123, 79, 0.12);
}

.path-card.recommended:hover {
  box-shadow: 0 4px 20px rgba(154, 123, 79, 0.2);
}

.recommended-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: white;
  background: var(--ochre);
  padding: 0.2rem 0.6rem;
  border-radius: 3px;
  margin-bottom: 0.35rem;
}

/* Completed state */
.path-card.completed {
  background: var(--paper);
  border-color: var(--border-subtle);
  opacity: 0.75;
}

.path-card.completed:hover {
  opacity: 1;
  border-color: var(--ochre);
}

.path-card.disabled { opacity: 0.4; pointer-events: none; }

.path-card-content { flex: 1; min-width: 0; }
.path-card-header { display: flex; align-items: center; gap: 0.5rem; }

.completed-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--insight-green);
  background: var(--insight-bg);
  padding: 0.2rem 0.5rem;
  border-radius: 3px;
  margin-bottom: 0.35rem;
}

.path-card-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.35;
}

.path-card.completed .path-card-title { color: var(--ink-muted); }

.path-card-desc {
  font-family: var(--sans);
  font-size: 0.82rem;
  color: var(--ink-muted);
  margin-top: 0.3rem;
  line-height: 1.55;
}

.path-arrow {
  flex-shrink: 0;
  font-size: 1rem;
  color: var(--ochre);
  margin-left: 1rem;
  transition: transform 0.2s ease;
}

.path-card:hover .path-arrow { transform: translateX(3px); }

@media (max-width: 480px) {
  .path-card { padding: 1rem 1.25rem; }
}
</style>
VUEEOF

echo "  ✓ PathCard updated with recommended state"

cat > src/components/shared/JourneyNav.vue << 'VUEEOF'
<template>
  <div class="journey-nav">
    <!-- Suggested next steps -->
    <div v-if="nextSteps.length" class="nav-section">
      <p class="caption" style="margin-bottom: 1rem;">{{ nextLabel }}</p>
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

    <!-- Already completed -->
    <div v-if="revisitSteps.length" class="nav-section" style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Revisit</p>
      <PathCard
        v-for="step in revisitSteps"
        :key="step.name"
        :to="{ name: step.name }"
        :completed="true"
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
  current: { type: String, required: true },
  nextLabel: { type: String, default: 'Continue your journey' }
})

const journey = useJourneyStore()

const allExperiences = [
  { name: 'exp01', title: 'The Question', desc: 'A five-minute thought experiment that reveals the gap between personal and political morality.', revisitDesc: 'Revisit the thought experiment that started everything.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection — or revisit your original one.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Actually Means', desc: 'Discover the empirical grounding for the principle — from your own life experience.', revisitDesc: 'Revisit the Six Pillars and Three Domains framework.', tier: 'foundation', order: 3 },
  { name: 'pillarA', title: 'Your Body Is Not Negotiable', desc: 'Bodily integrity — why safety is the precondition for all flourishing.', revisitDesc: 'Revisit the first domain of human integrity.', tier: 'pillar', order: 4 },
  { name: 'pillarB', title: 'Your Time Is Your Life', desc: 'Time as the irreplaceable substance of life — the philosophy\'s most original insight.', revisitDesc: 'Revisit the tax-hours calculation and the hierarchy of irreversibility.', tier: 'pillar', order: 5 },
  { name: 'pillarC', title: 'What You Built Is Who You Were', desc: 'Property as crystallized time — why material integrity matters for flourishing.', revisitDesc: 'Revisit material integrity and the meaning of theft.', tier: 'pillar', order: 6 },
  { name: 'pillarD', title: 'The Method Is the Message', desc: 'Your values aren\'t the problem. The question is force or persuasion.', revisitDesc: 'Revisit the values exercise and the method question.', tier: 'pillar', order: 7 },
  { name: 'pillarE', title: 'Cooperation Is a Technology', desc: 'Real evidence that voluntary cooperation solves problems people assume require force.', revisitDesc: 'Explore voluntary alternatives for a different issue.', tier: 'pillar', order: 8 },
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

const others = computed(() => allExperiences.filter(e => e.name !== props.current))

const nextSteps = computed(() => {
  const incomplete = others.value.filter(e => !isCompleted(e.name))
  if (incomplete.length === 0) return []

  const currentTier = allExperiences.find(e => e.name === props.current)?.tier
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
    .slice(0, 2)
})

function getTierPriority(currentTier) {
  switch (currentTier) {
    case 'foundation': return ['foundation', 'pillar', 'practice']
    case 'pillar': return ['pillar', 'practice', 'foundation']
    case 'practice': return ['practice', 'pillar', 'foundation']
    default: return ['foundation', 'pillar', 'practice']
  }
}
</script>

<style scoped>
.journey-nav { margin-top: 2.5rem; }
</style>
VUEEOF

echo "  ✓ JourneyNav passes recommended to first card"

echo ""
echo "✅ Recommended next step indicator added."
echo "Push with: git add . && git commit -m 'ux: recommended next step badge' && git push"
