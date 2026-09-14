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

export const ITEMS = [
  { id: 'd-goal', part: 'directly', text: "If people won't join a cause I care about, my job is to persuade them better, not to make them." },
  { id: 'd-money', part: 'directly', text: "I wouldn't take money from a neighbor, even to fund something that would help them." },
  { id: 'd-time', part: 'directly', text: "I wouldn't make someone give up their time for a project they didn't agree to, even a good one." },
  { id: 'd-values', part: 'directly', text: 'When someone lives by values I think are wrong, changing their mind is as far as I should go.' },
  { id: 'd-acid', part: 'directly', text: "I'd rather solve a problem slowly, with people who chose to help, than quickly, with people who were made to." },

  { id: 'o-goal', part: 'others', text: 'Voting for someone who promises to make people comply is still asking someone to make them comply for me.' },
  { id: 'o-money', part: 'others', text: "If I wouldn't take my neighbor's money myself, I shouldn't ask anyone else to take it for me, even by voting for it." },
  { id: 'o-time', part: 'others', text: "A law that makes people give their time to a cause they didn't choose is still forcing them, even for a good cause." },
  { id: 'o-values', part: 'others', text: "A majority vote doesn't make it right to force people to live by the majority's values." },
  { id: 'o-acid', part: 'others', text: "A leader who can't get something done without forcing people to go along isn't much of a leader." }
]

const POINTS = Object.fromEntries(ANSWERS.map((a) => [a.id, a.points]))

/** `answers` maps item id → answer id. Unanswered items score as 0. */
export function score(answers) {
  const total = (part) =>
    ITEMS.filter((i) => i.part === part).reduce((sum, i) => sum + (POINTS[answers[i.id]] ?? 0), 0)
  const directly = total('directly')
  const others = total('others')
  return { directly, others, gap: directly - others }
}

export const RESULTS = {
  consistent: {
    name: 'Persuasion, all the way through',
    head: "You don't make an exception for force when someone else does it for you.",
    body: [
      "You'd persuade rather than force, and you hold that standard when the force would come through a vote, a law, or a leader. That's harder than it sounds.",
      "There's a reason it holds up. Force, theft, and violence reliably reduce happiness, harmony, and prosperity, whoever's hand is on them. That's the Principle of Human Respect."
    ]
  },
  loophole: {
    name: 'The loophole',
    head: "You'd persuade, not force. Until someone else does the forcing.",
    body: [
      "You wouldn't take a neighbor's money or time yourself. When it comes through a vote, a law, or a leader you support, you're more comfortable with it.",
      "You wouldn't ask one neighbor to take from another on your behalf. If you did, you'd be responsible. What changes when that neighbor holds office?"
    ]
  },
  weighing: {
    name: 'Still weighing it',
    head: "You haven't drawn the line yet.",
    body: [
      "You see a place for persuasion and a place for force, and you haven't settled where one ends and the other begins. That's an honest place to be.",
      'A question to take with you: what kind of problem-solver would you be if no one could be forced to do it your way?'
    ]
  },
  force: {
    name: 'Force on the table',
    head: "When the goal matters enough, you're willing to make people go along.",
    body: [
      "At least you're consistent, whether the force is yours or someone else's.",
      'Two things worth testing. Picture the people you disagree with most holding that same power, pointed at you. And think of the last time something was taken from you. Did it leave you happier?'
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
