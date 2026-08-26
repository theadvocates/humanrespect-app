/**
 * The curriculum, in one place.
 *
 * This list previously existed in four: app/utils/seo.js, the sitemap route,
 * getTier() in the journey store, and a hardcoded array in your-journey.vue.
 * They had already drifted — the journey page showed exp02's description under
 * exp03 and vice versa — which is what duplicated content always eventually
 * does. Everything that needs to know about an experience reads this.
 *
 * `minutes` is an honest estimate, not a floor. It is shown to people before
 * they commit, because an unlabelled time cost is the thing that makes a five
 * minute exercise feel expensive.
 */

export const TIERS = {
  foundation: {
    label: 'The core case',
    note: 'Three experiences that build the argument. Best in order, but not required.'
  },
  argument: {
    label: 'Go deeper',
    note: 'Standalone arguments for people who want the harder version.'
  },
  pillar: {
    label: 'The five pillars',
    note: 'The domains of human integrity, and the case for cooperation. Any order.'
  },
  practice: {
    label: 'Put it into practice',
    note: 'Apply it to your actual life rather than reading about it.'
  }
}

export const EXPERIENCES = [
  // ── Foundation ────────────────────────────────────────────────────────────
  {
    id: 'exp01',
    route: 'exp01',
    path: '/experience/the-question',
    title: 'The Question',
    short: 'The full version of the question on the home page — slower, and with more room to think.',
    tier: 'foundation',
    order: 1,
    minutes: 5
  },
  {
    id: 'exp02',
    route: 'exp02',
    path: '/experience/the-objection',
    title: 'The Objection',
    short: 'Pick your strongest objection. It gets steelmanned, answered, and where it lands, honestly conceded.',
    tier: 'foundation',
    order: 2,
    minutes: 8
  },
  {
    id: 'exp03',
    route: 'exp03',
    path: '/experience/flourishing',
    title: 'What Flourishing Actually Means',
    short: 'The empirical grounding for the principle, traced through your own life rather than through theory.',
    tier: 'foundation',
    order: 3,
    minutes: 8
  },

  // ── Arguments ─────────────────────────────────────────────────────────────
  {
    id: 'exp04',
    route: 'exp04',
    path: '/experience/human-nature',
    title: 'The Realist Objection',
    short: 'People are flawed and self-interested — which turns out to be the strongest argument against giving any of them power over the rest.',
    tier: 'argument',
    order: 1,
    minutes: 8
  },
  {
    id: 'exp05',
    route: 'exp05',
    path: '/experience/human-agency',
    title: 'Human Agency',
    short: 'If you hire someone to steal, you bear responsibility. What changes when the intermediary is a government?',
    tier: 'argument',
    order: 2,
    minutes: 8
  },

  // ── Pillars ───────────────────────────────────────────────────────────────
  {
    id: 'pillarA',
    route: 'pillarA',
    path: '/pillar/your-body-is-not-negotiable',
    title: 'Your Body Is Not Negotiable',
    short: 'Bodily integrity: why physical safety is the precondition for everything else.',
    tier: 'pillar',
    order: 1,
    minutes: 7
  },
  {
    id: 'pillarB',
    route: 'pillarB',
    path: '/pillar/your-time-is-your-life',
    title: 'Your Time Is Your Life',
    short: "Time as the irreplaceable substance of a life — the philosophy's most original claim.",
    tier: 'pillar',
    order: 2,
    minutes: 7
  },
  {
    id: 'pillarC',
    route: 'pillarC',
    path: '/pillar/what-you-built',
    title: 'What You Built Is Who You Were',
    short: 'Property as crystallised time, and what insecurity actually costs.',
    tier: 'pillar',
    order: 3,
    minutes: 7
  },
  {
    id: 'pillarD',
    route: 'pillarD',
    path: '/pillar/the-method-is-the-message',
    title: 'The Method Is the Message',
    short: "Your values aren't the problem. The question is whether you advance them by force or by persuasion.",
    tier: 'pillar',
    order: 4,
    minutes: 7
  },
  {
    id: 'pillarE',
    route: 'pillarE',
    path: '/pillar/cooperation-is-a-technology',
    title: 'Cooperation Is a Technology',
    short: 'Evidence that voluntary cooperation solves problems people assume require force.',
    tier: 'pillar',
    order: 5,
    minutes: 7
  },

  // ── Practices ─────────────────────────────────────────────────────────────
  {
    id: 'practice01',
    route: 'practice01',
    path: '/practice/political-footprint',
    title: 'Your Political Footprint',
    short: 'Map where you currently support coercion — specifically, not abstractly.',
    tier: 'practice',
    order: 1,
    minutes: 10
  },
  {
    id: 'practice02',
    route: 'practice02',
    path: '/practice/persuasion-practice',
    title: 'The Persuasion Practice',
    short: 'Take an issue you care about and design an approach that uses no force at all.',
    tier: 'practice',
    order: 2,
    minutes: 10
  },
  {
    id: 'practice03',
    route: 'practice03',
    path: '/practice/the-conversation',
    title: 'The Conversation',
    short: 'A framework for raising this with someone who disagrees with you.',
    tier: 'practice',
    order: 3,
    minutes: 10
  },
  {
    id: 'practice04',
    route: 'practice04',
    path: '/practice/respect-audit',
    title: 'The Respect Audit',
    short: 'Notice where you choose persuasion and where you choose force, for seven days.',
    tier: 'practice',
    order: 4,
    minutes: 10
  },
  {
    id: 'practice05',
    route: 'practice05',
    path: '/practice/design-a-solution',
    title: 'Design a Voluntary Solution',
    short: "Pick a real problem in your community and solve it without coercion.",
    tier: 'practice',
    order: 5,
    minutes: 10
  }
]

export const TIER_ORDER = ['foundation', 'argument', 'pillar', 'practice']

export function byTier(tier) {
  return EXPERIENCES.filter((e) => e.tier === tier).sort((a, b) => a.order - b.order)
}

export function totalMinutes() {
  return EXPERIENCES.reduce((n, e) => n + e.minutes, 0)
}
