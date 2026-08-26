// Per-route metadata for SEO and social sharing.
// Rendered server-side, so crawlers and social unfurlers see the real values.

export const SITE_URL = 'https://humanrespect.app'
export const SITE_NAME = 'Human Respect'
// Fallback card. Per-page cards live at /og/<key>.png — see
// scripts/generate-og.mjs.
export const DEFAULT_OG_IMAGE = `${SITE_URL}/og/default.png`

export const pageMeta = {
  home: {
    title: 'Human Respect — Discover the principle you already live by',
    description:
      'A series of interactive philosophical experiences exploring how voluntary cooperation relates to human flourishing.'
  },
  exp01: {
    title: 'The Question',
    description:
      'You already know that force damages relationships. This experience helps you see the principle you live by — and why we abandon it at scale.'
  },
  exp02: {
    title: 'The Objection',
    description:
      'Pick your strongest objection to voluntary cooperation. It gets steelmanned, responded to, and honestly conceded.'
  },
  exp03: {
    title: 'What Flourishing Actually Means',
    description:
      'Discover the empirical grounding for the principle of Human Respect — traced through your own life experience.'
  },
  exp04: {
    title: 'The Realist Objection',
    description:
      'People are flawed and self-interested. That turns out to be the strongest argument against giving any of them coercive power over the rest.'
  },
  exp05: {
    title: 'Human Agency',
    description:
      'If you hire someone to steal, you bear responsibility. What changes when the intermediary is a government?'
  },
  pillarA: {
    title: 'Your Body Is Not Negotiable',
    description: 'Bodily integrity: why physical safety is the precondition for all human flourishing.'
  },
  pillarB: {
    title: 'Your Time Is Your Life',
    description:
      "Time as the irreplaceable substance of life — the Philosophy of Human Respect's most original insight."
  },
  pillarC: {
    title: 'What You Built Is Who You Were',
    description: 'Property as crystallized time: why material integrity matters for human flourishing.'
  },
  pillarD: {
    title: 'The Method Is the Message',
    description:
      "Your values aren't the problem. The question is whether you advance them through force or persuasion."
  },
  pillarE: {
    title: 'Cooperation Is a Technology',
    description:
      'Real evidence that voluntary cooperation solves problems people assume require government force.'
  },
  practice01: {
    title: 'Your Political Footprint',
    description: 'Map where you currently support coercion in your political life.'
  },
  practice02: {
    title: 'The Persuasion Practice',
    description: 'Take an issue you care about and design a persuasion-only approach to solving it.'
  },
  practice03: {
    title: 'The Conversation',
    description: 'A framework for discussing Human Respect with someone who disagrees with you.'
  },
  practice04: {
    title: 'The Respect Audit',
    description: 'Track where you choose persuasion vs. force for seven days.'
  },
  practice05: {
    title: 'Design a Voluntary Solution',
    description: "Pick a real problem in your community and design a solution that doesn't use force."
  },
  milestone: {
    title: 'Foundation Complete',
    description: 'You have completed the foundation of the Philosophy of Human Respect.'
  },
  'your-journey': {
    title: 'Your Journey',
    description: 'Track your progress through the Philosophy of Human Respect.'
  },
  about: {
    title: 'About',
    description:
      'Why this exists: the Philosophy of Human Respect, articulated by Chris J. Rufer, founder of The Morning Star Company.'
  },
  'sign-in': {
    title: 'Sign In',
    description: 'Sign in to keep your progress across devices. Nothing you have already done is lost.'
  },
  terms: {
    title: 'Terms',
    description: 'The agreement between us, in plain language. What this site is, what we ask of you, and what we do not promise.'
  },
  privacy: {
    title: 'Privacy',
    description: 'How we handle your data. Anonymous analytics, no tracking cookies, no data sales.'
  }
}
