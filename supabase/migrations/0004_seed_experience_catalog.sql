-- Experience catalog seed
--
-- Mirrors the routes in app/pages/ and the tier logic in app/stores/journey.js.
-- Idempotent: re-running updates titles and ordering without duplicating rows.

insert into public.experiences
  (id, slug, title, description, tier, sort_order, estimated_minutes, screen_count, required_for_cert)
values
  -- Foundation — sequential, builds the framework
  ('exp01', '/experience/the-question', 'The Question',
   'A five-minute thought experiment that reveals something about your own moral reasoning.',
   'foundation', 1, 5, 8, true),
  ('exp02', '/experience/the-objection', 'The Objection',
   'Pick your strongest objection to voluntary cooperation. It gets steelmanned, responded to, and honestly conceded.',
   'foundation', 2, 8, 8, true),
  ('exp03', '/experience/flourishing', 'What Flourishing Actually Means',
   'Discover the empirical grounding for the principle of Human Respect — traced through your own life experience.',
   'foundation', 3, 8, 8, true),

  -- Arguments — standalone, any order
  ('exp04', '/experience/human-nature', 'The Realist Objection',
   'People are flawed and self-interested. That turns out to be the strongest argument against giving any of them coercive power over the rest.',
   'argument', 1, 8, 7, false),
  ('exp05', '/experience/human-agency', 'Human Agency',
   'If you hire someone to steal, you bear responsibility. What changes when the intermediary is a government?',
   'argument', 2, 8, 7, false),

  -- Pillars — the domains of human integrity
  ('pillarA', '/pillar/your-body-is-not-negotiable', 'Your Body Is Not Negotiable',
   'Bodily integrity: why physical safety is the precondition for all human flourishing.',
   'pillar', 1, 7, 6, false),
  ('pillarB', '/pillar/your-time-is-your-life', 'Your Time Is Your Life',
   'Time as the irreplaceable substance of life — the philosophy''s most original insight.',
   'pillar', 2, 7, 6, false),
  ('pillarC', '/pillar/what-you-built', 'What You Built Is Who You Were',
   'Property as crystallized time: why material integrity matters for human flourishing.',
   'pillar', 3, 7, 6, false),
  ('pillarD', '/pillar/the-method-is-the-message', 'The Method Is the Message',
   'Your values aren''t the problem. The question is whether you advance them through force or persuasion.',
   'pillar', 4, 7, 6, false),
  ('pillarE', '/pillar/cooperation-is-a-technology', 'Cooperation Is a Technology',
   'Real evidence that voluntary cooperation solves problems people assume require government force.',
   'pillar', 5, 7, 6, false),

  -- Practices — applied
  ('practice01', '/practice/political-footprint', 'Your Political Footprint',
   'Map where you currently support coercion in your political life.',
   'practice', 1, 10, 6, false),
  ('practice02', '/practice/persuasion-practice', 'The Persuasion Practice',
   'Take an issue you care about and design a persuasion-only approach to solving it.',
   'practice', 2, 10, 4, false),
  ('practice03', '/practice/the-conversation', 'The Conversation',
   'A framework for discussing Human Respect with someone who disagrees with you.',
   'practice', 3, 10, 4, false),
  ('practice04', '/practice/respect-audit', 'The Respect Audit',
   'Track where you choose persuasion vs. force for seven days.',
   'practice', 4, 10, 4, false),
  ('practice05', '/practice/design-a-solution', 'Design a Voluntary Solution',
   'Pick a real problem in your community and design a solution that doesn''t use force.',
   'practice', 5, 10, 4, false)

on conflict (id) do update set
  slug              = excluded.slug,
  title             = excluded.title,
  description       = excluded.description,
  tier              = excluded.tier,
  sort_order        = excluded.sort_order,
  estimated_minutes = excluded.estimated_minutes,
  screen_count      = excluded.screen_count,
  required_for_cert = excluded.required_for_cert;
