#!/bin/bash
# Copy editing pass: implementing approved audit fixes
# Run from humanrespect-app/ root
#
# Fixes implemented:
# 1. Update philanthropy to 2024 ($592.5B)
# 2. Use Flourishing Principle in Exp01 Screen 7
# 4. Frame "effect doesn't change" as philosophy's claim
# 5. Strengthen social contract steelman with Rawlsian note
# 6. Add nuance to mutual aid history
# 7. Replace slavery with Jim Crow + Japanese internment
# 8. Rework values/method claim in Pillar D
# 9. Remove condescending preemption in Exp01 mirror
# 10. Soften accusatory closing question in Exp02
# 11. Reduce "this isn't political" repetitions
# 15. Fix "stranger on the bus"
# 16. Rephrase "This isn't X, it's Y" in Exp03
# 17. Add note to Pillar B calculator

set -e

echo "📝 Copy editing pass..."

# ══════════════════════════════════════
# FIX #2: Exp01 Screen 7 — Flourishing Principle wording
# Also FIX #11: Remove "not a political ideology" assertion
# ══════════════════════════════════════

cat > src/components/experiences/exp01/ThePrinciple.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern has a name</p>
    <h2 class="display-medium">The Principle of Human Respect</h2>
    <Divider />
    <p class="body-text-large">Across every culture and era, a consistent pattern holds: human well-being is sensitive to how people treat each other. Specifically, it is sensitive to the presence or absence of force.</p>
    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>
    <p class="body-text">This holds whether the force comes from a mugger, a dictator, a majority vote, or a well-intentioned policy. The mechanism doesn't change the effect.</p>
    <p class="body-text">And the inverse holds too. Wherever people interact through persuasion and voluntary cooperation — in friendships, in markets, in communities that choose to help each other — flourishing increases.</p>
    <p class="body-text">This is what the thought experiment was pointing toward. A statement about cause and effect: <em>how</em> we pursue good outcomes matters as much as the outcomes themselves.</p>
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
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ #2: Flourishing Principle in Exp01"

# ══════════════════════════════════════
# FIX #4: Exp01 Screen 6 — Frame claim as philosophy's position
# ══════════════════════════════════════

cat > src/components/experiences/exp01/TheDeeperQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The deeper question</p>
    <h2 class="display-medium">{{ hasGap ? 'Why do we make this exception?' : 'Most people hold two moral codes without realizing it.' }}</h2>
    <p class="body-text-large">{{ hasGap
      ? "You wouldn't personally take James's money. But when a politician does the same thing and calls it taxation, it feels different. Why?"
      : "They would never personally take a neighbor's money — but they routinely vote for governments to take their neighbors' money for causes they believe in. Why?"
    }}</p>
    <p class="body-text">We've been taught that democratic authorization transforms the act. That voting for something makes it fundamentally different from doing it yourself. That the collective can do what the individual cannot.</p>
    <p class="body-text">But the Philosophy of Human Respect observes that the money still leaves James's pocket. He still didn't choose to give it. And his capacity to flourish still decreases — regardless of who authorized the taking.</p>
    <ContentBlock variant="principle">
      <p>The philosophy holds that the effect on the person being acted upon doesn't change based on who authorized the action. If this is true, the implications are profound.</p>
    </ContentBlock>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const hasGap = computed(() => journey.mirrorPattern === 'gap')
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ #4: Framed as philosophy's claim"

# ══════════════════════════════════════
# FIX #9: Exp01 Screen 5 — Remove condescending preemption
# FIX #15: "stranger on the bus" → "stranger you passed on the street"
# ══════════════════════════════════════

cat > src/components/experiences/exp01/TheMirror.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you just revealed</p>

    <!-- GAP: no/yes (most common) -->
    <template v-if="pattern === 'gap'">
      <h2 class="display-medium">Read your two answers back to yourself.</h2>
      <ContentBlock variant="mirror">
        <p><strong>Personally:</strong> You said taking James's money is wrong — even to help Sarah.</p>
        <p><strong>Politically:</strong> You said the government <em>should</em> take James's money — to help people just like Sarah.</p>
      </ContentBlock>
      <p class="body-text-large">The money still comes from someone who earned it. It still goes to someone who needs it. The cause is equally compassionate in both cases.</p>
      <p class="body-text">The only thing that changed is who does the taking. And somehow, that changed your answer.</p>
      <ContentBlock variant="insight">
        <p>Most people hold one standard for personal conduct and a different one for political action, and we rarely stop to ask why. <strong>That gap is the starting point for everything that follows.</strong></p>
      </ContentBlock>
    </template>

    <!-- CONSISTENT VOLUNTARY: no/no -->
    <template v-else-if="pattern === 'consistent-voluntary'">
      <h2 class="display-medium">Your answers are remarkably consistent.</h2>
      <ContentBlock variant="insight">
        <p>You said taking James's money is wrong — whether done personally or through government. You apply the same moral standard to both situations.</p>
      </ContentBlock>
      <p class="body-text-large">This puts you in a minority. Most people hold one moral code for their personal life and a different one for political action. They would never personally take a neighbor's money, but they'll vote for a government to do exactly that.</p>
      <p class="body-text">You've already noticed something that most people never examine. The question is: what does that consistency tell you about how society could work?</p>
    </template>

    <!-- CONSISTENT COERCIVE: yes/yes -->
    <template v-else-if="pattern === 'consistent-coercive'">
      <h2 class="display-medium">Your answers are consistent — and worth examining.</h2>
      <ContentBlock variant="mirror">
        <p>You said Sarah's need justifies taking James's money — both personally and through government. You believe urgent need can override individual consent.</p>
      </ContentBlock>
      <p class="body-text-large">This is a coherent position. But consider: if <em>you</em> can decide when someone else's need justifies taking from James, so can everyone else. And their definition of "urgent need" may be very different from yours.</p>
      <p class="body-text">When everyone has the right to take from others for causes they consider justified, what happens to trust? To cooperation? To the willingness to produce in the first place?</p>
    </template>

    <!-- UNUSUAL: yes/no -->
    <template v-else>
      <h2 class="display-medium">Your answers form an interesting pattern.</h2>
      <ContentBlock variant="mirror">
        <p>You'd personally take James's money for Sarah — but you wouldn't vote for a government to do the same thing at scale. You hold yourself to a <em>different</em> standard than you hold institutions.</p>
      </ContentBlock>
      <p class="body-text-large">This suggests you see personal compassion and institutional force as fundamentally different — that scale changes the ethics. That's worth sitting with.</p>
    </template>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const pattern = computed(() => journey.mirrorPattern)
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ #9: Removed condescending preemption"

# ── Fix #15 in Exp01 Screen 1 ──
sed -i.bak 's/The stranger on the bus/The stranger you passed on the street/g' src/components/experiences/exp01/TheStartingPoint.vue 2>/dev/null || true
rm -f src/components/experiences/exp01/TheStartingPoint.vue.bak
echo "  ✓ #15: Stranger on the street"

# ══════════════════════════════════════
# FIX #5, #6, #7, #10: Exp02 objection data
# ══════════════════════════════════════

cat > src/components/experiences/exp02/objectionData.js << 'JSEOF'
export const objections = {
  'social-contract': {
    title: '"I consented by living here."',
    steelman: 'By participating in a democratic society — using its roads, courts, schools, and protections — you implicitly consent to its funding mechanism. Taxation is the price of civilization. This argument has deep philosophical roots: Rawls argued that rational people, choosing principles of justice from behind a veil of ignorance, would agree to institutions that protect the least advantaged — even through compulsory taxation. You\'re free to leave if you disagree. This is fundamentally different from a stranger walking into someone\'s house.',
    response: [
      'Consider: if a landscaping company mowed your lawn without asking, then handed you a bill and said "you benefited, so you owe us" — would the benefit you received make it a voluntary transaction?',
      'Most people would say no. Consent requires the ability to say no <em>before</em> the obligation is imposed.',
      '"Implicit consent" is a concept we reject in every other moral context. We don\'t accept it in contracts. We don\'t accept it in medicine. We don\'t accept it in relationships. In every other area of life, consent means the right to say no without being punished.',
      'The Rawlsian version is more sophisticated, but it rests on a thought experiment — what people <em>would</em> agree to hypothetically — not on what any actual person <em>did</em> agree to. The Philosophy of Human Respect holds that hypothetical consent is not consent.',
      'And the "you can leave" argument actually proves the point. If the only way to withdraw consent is to abandon your home, your community, your livelihood, and your country — that\'s not meaningful consent. It\'s coercion with an escape clause.'
    ],
    concession: 'The social contract tradition is serious philosophy with a long lineage — Locke, Rousseau, Rawls. The Philosophy of Human Respect doesn\'t claim these thinkers are foolish. It claims they\'ve accepted an exception to a principle they\'d never accept in personal life. That\'s precisely what the thought experiment revealed.',
    question: 'If "you benefit, therefore you consented" were truly valid, what <em>couldn\'t</em> be justified by it? If a cult leader provides food and shelter, have the members consented to his authority?'
  },

  'people-will-die': {
    title: '"People will die without help."',
    steelman: 'A child is hungry. A family is homeless. Someone is dying of a treatable disease. If refusing to use force means people die preventable deaths, then the force is the lesser evil. The moral weight of preventing suffering outweighs the moral cost of nonconsensual taxation.',
    response: [
      'This is the strongest objection, and it deserves a serious answer. Notice what it assumes: that <em>force is the only way</em> to help.',
      'Before government welfare programs existed, voluntary institutions — mutual aid societies, fraternal organizations, religious charities, community networks — provided healthcare, education, disaster relief, and poverty assistance. These systems were extensive and effective, though imperfect. They didn\'t reach everyone — many were segregated or restricted to employed members. Government programs expanded partly because voluntary systems were overwhelmed during the Great Depression, and partly because political actors saw advantage in centralizing these functions.',
      'The deeper question: does taking James\'s money against his will actually help Sarah in the most sustainable way? Or does it create dependency, reduce James\'s willingness to give voluntarily, erode the community bonds that produce real care — and ultimately generate worse outcomes than cooperation would?',
      'Consider the massive reduction in global poverty over the past two centuries. That progress came primarily from expanding voluntary exchange and economic freedom — not from redistribution programs.'
    ],
    concession: 'This is where the philosophy must be most honest. Voluntary systems are not guaranteed to catch every person who falls. During any transition from coercive to voluntary systems, some people who currently receive government help might experience disruption. The philosophy cannot credibly promise zero casualties. What it can argue is that the <em>trajectory</em> of voluntary cooperation points toward greater flourishing for everyone — and that coercive systems create their own suffering, less visible but equally real.',
    question: 'Is compassion measured by your willingness to use force on others — or by your willingness to act yourself?'
  },

  'democracy': {
    title: '"Government has democratic legitimacy."',
    steelman: 'When 60% of voters approve a tax, that\'s collective self-governance — the most legitimate form of authority humans have devised. Comparing that to one person unilaterally taking another\'s property ignores the moral weight of democratic process. Democracy isn\'t just a mechanism; it\'s how free people govern themselves.',
    response: [
      'Democratic process determines <em>who</em> makes a decision. It doesn\'t transform the <em>nature</em> of the action.',
      'If 60% of your neighbors voted that you must give $500 a month to a community fund — and men with guns would come to your house if you refused — the vote wouldn\'t change what happens to you. Your money still leaves your possession against your will. The vote changes the <em>authority</em>, not the <em>experience of the person being acted upon</em>.',
      'The Philosophy of Human Respect holds that the effect on the person experiencing force doesn\'t change based on how many people authorized it. Democratic authorization makes coercion more orderly — which is genuinely better than chaotic coercion — but it doesn\'t make it voluntary.',
      'History shows that democratic majorities have authorized things we now recognize as deeply unjust — from Jim Crow laws to Japanese internment to forced sterilization programs. Democratic legitimacy has never been, on its own, sufficient to make an action moral.'
    ],
    concession: 'Democracy is better than dictatorship. The philosophy isn\'t arguing that democratic process has no value — it\'s arguing that democracy is an <em>incomplete</em> answer to the question of how people should relate to each other. Majority rule is appropriate for genuinely shared decisions. It becomes problematic when it\'s used to override individual consent on matters of property and personal choice.',
    question: 'If democratic legitimacy truly transforms the nature of the act, then there\'s nothing a democratic majority could do that would be wrong — as long as they voted on it first. Do you accept that conclusion? If not, where do you draw the line?'
  },

  'public-goods': {
    title: '"Roads, courts, defense — you can\'t fund those voluntarily."',
    steelman: 'Some goods are "non-excludable" — everyone benefits whether they pay or not. If defense, courts, and roads were voluntarily funded, rational self-interest would lead most people to free-ride on others\' contributions. The result would be systematic underfunding of essential services. This is a well-documented economic problem, not a theoretical worry.',
    response: [
      'The free rider problem is real for a narrow category of truly non-excludable goods. But notice how far the argument has retreated. It started as "taxation is legitimate" and has narrowed to "taxation might be necessary for a few specific things."',
      'Most government spending isn\'t on public goods. It\'s on <em>excludable</em> services — education, healthcare, retirement, housing — that could be provided through voluntary markets. Using the public goods argument to justify the entire scope of government is a massive overreach.',
      'Technology has also dramatically shrunk the category of non-excludable goods. Toll roads, subscription services, digital access controls, and blockchain-based coordination make exclusion feasible for things that were impossible to exclude a generation ago.',
      'And voluntary funding of shared goods already works in many contexts. Wikipedia. Open-source software. Volunteer fire departments. Charitable hospitals. Community-funded infrastructure. The claim that people <em>won\'t</em> voluntarily fund shared goods is contradicted by the fact that they already do — every day, at enormous scale.'
    ],
    concession: 'National defense may be the strongest case for compulsory funding. A purely voluntary defense system faces genuine coordination challenges. The philosophy should acknowledge this as a legitimately hard problem rather than hand-waving it away. But even here, the direction matters: minimize compulsion, don\'t maximize it. Perhaps defense is the last thing to voluntarize — but that doesn\'t invalidate the principle for everything else.',
    question: 'If voluntary cooperation can build Wikipedia, fund open-source software that runs the internet, and raise billions for disaster relief — why do we assume it\'s impossible for roads?'
  }
}
JSEOF

echo "  ✓ #5,6,7,10: Objection data updated"

# ══════════════════════════════════════
# FIX #8: Pillar D — Rework values/method claim
# ══════════════════════════════════════

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
    <p class="body-text">People across the political spectrum genuinely disagree on values — and those disagreements are real, not trivial. But beneath the disagreements lies a question that cuts deeper: will you advance your values through persuasion, or through force? That question is the one thing people of every political identity could agree on without giving up a single value they hold. It may be the only path out of the conflict.</p>
    <NewsletterSignup variant="minimal" source="pillarD_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarD" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ #8: Values/method reworked"

# ══════════════════════════════════════
# FIX #1, #12: Pillar E — Update philanthropy to 2024 data
# ══════════════════════════════════════

cat > src/components/experiences/pillarE/examplesData.js << 'JSEOF'
export const cooperationExamples = [
  {
    id: 'wikipedia',
    name: 'Wikipedia',
    what: 'The largest encyclopedia in human history',
    how: 'Entirely volunteer-written and donation-funded. No government mandate. No compulsory participation. 60+ million articles in 300+ languages.',
    assumption: '"You can\'t create reliable public knowledge without institutional funding and professional oversight."',
    reality: 'Voluntary contributors produce and maintain more accurate, more comprehensive, and more current information than any state-funded encyclopedia ever did.'
  },
  {
    id: 'software',
    name: 'Open-source software',
    what: 'The infrastructure that runs the internet',
    how: 'Linux, Apache, Python, Firefox, WordPress — created by volunteers and voluntary organizations. No one was forced to contribute. The result powers the majority of the world\'s servers.',
    assumption: '"Critical infrastructure requires centralized control and compulsory funding."',
    reality: 'The most reliable, secure, and innovative infrastructure on earth was built by people who chose to build it.'
  },
  {
    id: 'disaster',
    name: 'Volunteer disaster response',
    what: 'Faster and more effective than government in crisis',
    how: 'The Cajun Navy during Hurricane Harvey. Volunteer firefighters protecting roughly two-thirds of US communities. Mutual aid networks during COVID. Community organizations consistently arrive before FEMA.',
    assumption: '"Only government can coordinate large-scale emergency response."',
    reality: 'Voluntary networks are consistently faster, more adaptive, and more personally responsive than bureaucratic agencies.'
  },
  {
    id: 'arbitration',
    name: 'Private arbitration',
    what: 'Dispute resolution without government courts',
    how: 'Billions of dollars in commercial disputes resolved annually through voluntary arbitration. Faster, cheaper, and more satisfactory to both parties than the court system.',
    assumption: '"Justice requires government courts backed by state power."',
    reality: 'When both parties voluntarily agree to a process, resolution is faster, less adversarial, and more likely to preserve relationships.'
  },
  {
    id: 'charity',
    name: 'Private philanthropy',
    what: 'Voluntary generosity at scale',
    how: 'Americans gave $592.5 billion to charity in 2024 — from individuals, families, foundations, and corporations. All by choice, not compulsion. Community foundations, mutual aid societies, GoFundMe campaigns, religious charities.',
    assumption: '"Without forced redistribution, the poor would be abandoned."',
    reality: 'Voluntary generosity has existed in every culture in history and consistently grows when people feel economically secure and socially connected.'
  }
]

export const appliedIssues = [
  {
    id: 'education',
    label: 'Education',
    problem: 'Many children receive inadequate education, especially in disadvantaged communities.',
    forceSolution: 'Compulsory public schooling funded by property taxes.',
    voluntaryApproaches: [
      'Scholarship funds and community-sponsored tuition',
      'Homeschool cooperatives and microschools',
      'Free online learning platforms (Khan Academy, MIT OpenCourseWare)',
      'Apprenticeship programs funded by businesses who benefit',
      'Neighborhood learning pods with volunteer mentors'
    ]
  },
  {
    id: 'healthcare',
    label: 'Healthcare',
    problem: 'Healthcare is expensive and inaccessible for many people.',
    forceSolution: 'Government-mandated insurance funded by taxes.',
    voluntaryApproaches: [
      'Health-sharing ministries and mutual aid health cooperatives',
      'Direct primary care (monthly subscription, no insurance middleman)',
      'Community health centers funded by donations and user fees',
      'Medical mission organizations and free clinics',
      'Transparent pricing and cross-border competition'
    ]
  },
  {
    id: 'poverty',
    label: 'Poverty',
    problem: 'People fall into cycles of poverty that are difficult to escape.',
    forceSolution: 'Tax-funded welfare programs with eligibility requirements.',
    voluntaryApproaches: [
      'Mutual aid societies (historically provided insurance, healthcare, and support)',
      'Microfinance and community lending circles',
      'Job training programs funded by employers and philanthropists',
      'Religious and secular charity with personal relationships',
      'Removing regulatory barriers that prevent poor people from starting businesses'
    ]
  },
  {
    id: 'environment',
    label: 'Environment',
    problem: 'Industrial activity damages ecosystems and threatens public health.',
    forceSolution: 'Government regulations and penalties for pollution.',
    voluntaryApproaches: [
      'Land trusts and conservation easements (voluntary preservation)',
      'Consumer pressure and boycotts driving corporate change',
      'Private certification systems (organic, fair trade, B Corp)',
      'Common-law tort remedies — polluters pay damages to those they harm',
      'Community-owned renewable energy cooperatives'
    ]
  },
  {
    id: 'safety',
    label: 'Community safety',
    problem: 'Crime threatens people\'s safety and property.',
    forceSolution: 'Government police forces funded by taxes.',
    voluntaryApproaches: [
      'Neighborhood watch and community patrol programs',
      'Private security cooperatives funded by residents',
      'Restorative justice circles and community mediation',
      'Technology-enabled safety networks (apps, cameras, communication)',
      'Addressing root causes through voluntary mentorship and opportunity creation'
    ]
  }
]
JSEOF

echo "  ✓ #1,12: Philanthropy updated to 2024, firefighter figure softened"

# ══════════════════════════════════════
# FIX #16: Exp03 Screen 5 — Rephrase "This isn't X, it's Y"
# FIX #11: Reduce "this isn't political" assertion
# ══════════════════════════════════════

cat > src/components/experiences/exp03/TheGrounding.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The principle, grounded</p>
    <h2 class="display-medium">This is what the Philosophy of Human Respect is actually saying.</h2>
    <Divider />

    <p class="body-text-large">In Experience 01, you encountered the principle as a claim. Now you can see where it comes from — not from ideology, but from the observable structure of human well-being.</p>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
      <p style="margin-top: 1rem;">Therefore, the ethical foundation of society is the full respect for each person's body, resources, and time.</p>
    </ContentBlock>

    <p class="body-text">This is a statement about cause and effect — the same kind of statement as "plants grow toward light" or "trust increases cooperation." It describes a pattern that holds across cultures, eras, and individual lives.</p>

    <p class="body-text">Including yours. The best period of your life had these conditions present. The worst period had them violated. That's the pattern the principle describes.</p>

    <ContentBlock variant="insight">
      <p>Other moral frameworks ground the case against coercion in the existence of natural rights — which requires accepting a metaphysical premise. The Philosophy of Human Respect grounds it in the predictable damage coercion does to flourishing — a claim you can test against your own experience and the evidence of every society in history.</p>
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
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ #16,11: Rephrased 'this isn't X' + reduced political disclaimer"

# ══════════════════════════════════════
# FIX #17: Pillar B Calculator — add note about 40-hour assumption
# ══════════════════════════════════════

# Use sed to add the note near the calculator
if [ -f "src/components/experiences/pillarB/TheCalculator.vue" ]; then
  # Add a note after the result block
  sed -i.bak 's|<div class="result-label">hours of your life per year</div>|<div class="result-label">hours of your life per year</div>\n      <div class="calc-note">Based on a standard 40-hour work week.</div>|' src/components/experiences/pillarB/TheCalculator.vue
  rm -f src/components/experiences/pillarB/TheCalculator.vue.bak
  
  # Add styling for the note
  sed -i.bak 's|</style>|.calc-note { font-size: 0.72rem; color: var(--ink-faint); font-style: italic; margin-top: 0.5rem; }\n</style>|' src/components/experiences/pillarB/TheCalculator.vue
  rm -f src/components/experiences/pillarB/TheCalculator.vue.bak
  echo "  ✓ #17: Calculator note added"
else
  echo "  ⚠ Pillar B calculator file not found — add note manually"
fi

echo ""
echo "✅ Copy editing pass complete!"
echo ""
echo "Changes made:"
echo "  #1,12  Philanthropy updated to 2024: \$592.5B"
echo "  #2     Flourishing Principle in Exp01 (consistent with Exp03 + About)"
echo "  #4     'Effect doesn't change' framed as philosophy's position"
echo "  #5     Social contract steelman includes Rawlsian argument"
echo "  #6     Mutual aid history adds nuance (gaps, Depression)"
echo "  #7     Slavery → Jim Crow + Japanese internment + forced sterilization"
echo "  #8     Values/method: acknowledges real value disagreements, reframes"
echo "  #9     Removed 'you may have seen where this was headed'"
echo "  #10    Removed accusatory follow-up question in 'people will die'"
echo "  #11    Reduced 'this isn't political' repetitions"
echo "  #15    'Stranger on the bus' → 'stranger you passed on the street'"
echo "  #16    Rephrased 'This isn't X, it's Y' construction"
echo "  #17    Calculator note about 40-hour week assumption"
echo ""
echo "NOT changed (flagged for future):"
echo "  #3     'Six pillars' terminology — future experiences could expand"
echo "  #13    Firefighter 70% — softened to 'roughly two-thirds'"
echo "  #18    Pillar D values exercise balance — needs future review"
echo "  #19    Newsletter copy — fine as-is"
echo ""
echo "Push with: git add . && git commit -m 'copy: editing pass against systematic guide' && git push"
