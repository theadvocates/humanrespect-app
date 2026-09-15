/**
 * Persuade or Force? — the short Human Respect Test.
 *
 * Ten statements, scored the way the World's Smallest Political Quiz scores:
 * agree 20, maybe 10, disagree 0, so each half lands on 0–100.
 *
 * The halves are the two routes to force on Rufer's Personal Values / Political
 * Ethics Map — "through coercion directly or through a political system." Items
 * are matched by topic across the halves (a goal, money, time, values, the Acid
 * Test), so the gap between the two scores is the delegation loophole from Six
 * Key Concepts E, measured rather than asserted.
 *
 * Copy rules from Six Key Concepts apply to every line here: no rights
 * language, no harm-principle qualifiers, and "respect" never means kindness.
 */

export const ANSWERS = [
  { id: 'agree', label: 'Agree', points: 20 },
  { id: 'maybe', label: 'Maybe', points: 10 },
  { id: 'disagree', label: 'Disagree', points: 0 }
]

export const PARTS = {
  directly: { label: 'Directly', note: "When it's your own hands." },
  others: { label: 'Through others', note: 'When a vote, a law, or a leader does it for you.' }
}

export const TEST_VERSION = 2

/**
 * Four items are reverse-keyed (`keyed: 'force'`): agreeing with them is the
 * force answer. Version 1 keyed every item toward persuasion, so a visitor
 * could read the right answer off the first statement and agree their way to
 * a flattering score. The reversed items sit on the same topics in both halves
 * (money, values), so the halves stay matched and the gap still measures only
 * the delegation.
 */
export const ITEMS = [
  { id: 'd-goal', part: 'directly', text: "If people won't join a cause I care about, my job is to persuade them better, not to make them." },
  { id: 'd-money', part: 'directly', keyed: 'force', text: "If a neighbor refused to chip in for something that would clearly help the whole street, I'd be justified in making them pay their share." },
  { id: 'd-time', part: 'directly', text: "I wouldn't make someone give up their time for a project they didn't agree to, even a good one." },
  { id: 'd-values', part: 'directly', keyed: 'force', text: "If an adult I care about were making a choice that would ruin their life, I'd be right to force them to stop." },
  { id: 'd-acid', part: 'directly', text: "I'd rather solve a problem slowly, with people who chose to help, than quickly, with people who were made to." },

  { id: 'o-goal', part: 'others', text: 'Voting for someone who promises to make people comply is still asking someone to make them comply for me.' },
  { id: 'o-money', part: 'others', keyed: 'force', text: "When enough people vote for a good cause, it's fair to make everyone help pay for it." },
  { id: 'o-time', part: 'others', text: "A law that makes people give their time to a cause they didn't choose is still forcing them, even for a good cause." },
  { id: 'o-values', part: 'others', keyed: 'force', text: "If a law would stop people from making choices that ruin their own lives, it's worth passing even if they object." },
  { id: 'o-acid', part: 'others', text: "A leader who can't get something done without forcing people to go along isn't much of a leader." }
]

const POINTS = Object.fromEntries(ANSWERS.map((a) => [a.id, a.points]))

/** Points toward persuasion for one answer. Reverse-keyed items flip. */
export function pointsFor(item, answer) {
  const p = POINTS[answer]
  if (p === undefined) return 0
  return item.keyed === 'force' ? 20 - p : p
}

/**
 * `answers` maps item id → answer id. Unanswered items score as 0.
 * 100 means persuasion every time; 0 means force every time.
 */
export function score(answers) {
  const total = (part) =>
    ITEMS.filter((i) => i.part === part).reduce((sum, i) => sum + pointsFor(i, answers[i.id]), 0)
  const directly = total('directly')
  const others = total('others')
  return { directly, others, gap: directly - others }
}

/** What a number on the scale means, in words, for the result screen. */
export function describeScore(n) {
  if (n >= 90) return 'persuade, every time'
  if (n >= 70) return 'persuade, almost always'
  if (n >= 40) return 'sometimes persuade, sometimes force'
  if (n >= 20) return 'force, more often than not'
  return 'force, whenever it matters'
}

export const RESULTS = {
  consistent: {
    name: 'Persuasion, all the way through',
    head: "You don't make an exception for force when someone else does it for you.",
    body: [
      "You'd persuade rather than force, and you keep that standard when the force would come through a vote, a law, or a leader. Most people draw the line at their own hands and hand the rest to someone else.",
      "The Principle of Human Respect says your standard is right, and says why. Coercion, theft, and violence always reduce happiness, harmony, and prosperity. Always. Whose hand is on them doesn't change what they do.",
      'The harder test comes next. Find the cause you care about most, and ask whether any part of it still depends on making people go along.'
    ]
  },
  loophole: {
    name: 'The loophole',
    head: "You'd persuade, not force. Until someone else does the forcing.",
    body: [
      "You wouldn't take a neighbor's money or time yourself. Through a vote, a law, or a leader, you're more comfortable with it. The force is the same. Only the distance changed.",
      "If you paid someone to take from your neighbor, what they did would be on you. A politician is someone you chose to act for you. Handing force to an agent doesn't make it something else.",
      "This is how people who would never coerce anyone in their own lives end up backing it at scale, on every side, each for their own good values."
    ]
  },
  weighing: {
    name: 'Still weighing it',
    head: "You haven't drawn the line yet.",
    body: [
      "You see a place for persuasion and a place for force, and you haven't settled where one ends and the other begins.",
      "The Principle of Human Respect doesn't split the difference. Coercion, theft, and violence always reduce happiness, harmony, and prosperity, whether the cause is good or bad and whoever carries them out.",
      'Go back to the statements where you chose force, and ask of each one: what kind of problem-solver would you be if no one could be forced to do it your way?'
    ]
  },
  force: {
    name: 'Force on the table',
    head: "When the goal matters enough, you're willing to make people go along.",
    body: [
      "You're consistent. You'd use force yourself, and you'd use it through others. That's more honest than most.",
      'The Principle of Human Respect says it will cost you the very thing you want. Coercion, theft, and violence always reduce happiness, harmony, and prosperity, even when the goal is a good one.',
      'Two things worth testing. Picture the people you disagree with most holding that same power, pointed at you. Then think of the last time something was taken from you by force. Did it leave you better off?'
    ]
  }
}

/** Thresholds are first guesses; revisit once there is response data. */
export function classify({ directly, others }) {
  if (directly >= 70 && others >= 70) return 'consistent'
  if (directly >= 70) return 'loophole'
  if (directly <= 30 && others <= 30) return 'force'
  return 'weighing'
}

/**
 * A shared result travels in the link: /test?r=loophole&d=90&o=40. Anything
 * that doesn't add up (unknown result, off-scale numbers, a result the scores
 * couldn't produce) is ignored, so a hand-edited link can't put words in
 * someone's mouth.
 */
export function sharedResultPath({ key, directly, others }) {
  return `/test?r=${key}&d=${directly}&o=${others}`
}

export function parseShared(query = {}) {
  const key = String(query.r || '')
  const d = Number(query.d)
  const o = Number(query.o)
  const onScale = (n) => Number.isInteger(n) && n >= 0 && n <= 100 && n % 10 === 0
  if (!RESULTS[key] || !onScale(d) || !onScale(o)) return null
  if (classify({ directly: d, others: o }) !== key) return null
  return { key, directly: d, others: o, gap: d - o }
}
