#!/bin/bash
# Creates Experience 02: "The Objection You're Already Thinking"
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/exp02/objections

echo "🏗️  Building Experience 02..."

# ══════════════════════════════════════
# PAGE ORCHESTRATOR
# ══════════════════════════════════════

cat > src/pages/Experience02.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @choose-objection="handleObjectionChoice"
          @restart-with="restartWith"
          @share="handleShare"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useJourneyStore } from '@/stores/journey'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()

const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response, Concession, TheQuestion, WhereNext
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02.chosenObjection}`)

watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

function advance() {
  if (currentScreen.value < screenComponents.length - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function handleObjectionChoice(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
}

function restartWith(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
  currentScreen.value = 2 // jump to Steelman
  history.value = [0, 1, 2]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function handleShare() {
  const text = "I picked my strongest objection to a philosophical idea — and it got a more honest answer than I expected."
  const url = window.location.origin + '/experience/the-objection'

  if (navigator.share) {
    navigator.share({ title: 'The Objection You\'re Already Thinking', text, url })
  } else {
    navigator.clipboard.writeText(text + ' ' + url)
  }
}
</script>

<style scoped>
.exp-app {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1.5rem;
  transition: background 0.6s ease, color 0.6s ease;
  background: var(--paper);
}
.exp-app.dark-mode {
  background: var(--bg-dark);
  color: var(--text-inverse);
}
.exp-container {
  max-width: 640px;
  width: 100%;
}
.screen-fade-enter-active,
.screen-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
</style>
VUEEOF

echo "  ✓ Experience02.vue"

# ══════════════════════════════════════
# OBJECTION DATA (shared across screens)
# ══════════════════════════════════════

cat > src/components/experiences/exp02/objectionData.js << 'JSEOF'
export const objections = {
  'social-contract': {
    title: '"I consented by living here."',
    steelman: 'By participating in a democratic society — using its roads, courts, schools, and protections — you implicitly consent to its funding mechanism. Taxation is the price of civilization. You\'re free to leave if you don\'t want to pay. This is nothing like a stranger walking into someone\'s house.',
    response: [
      'Consider: if a landscaping company mowed your lawn without asking, then handed you a bill and said "you benefited, so you owe us" — would the benefit you received make it a voluntary transaction?',
      'Most people would say no. Consent requires the ability to say no <em>before</em> the obligation is imposed.',
      '"Implicit consent" is a concept we reject in every other moral context. We don\'t accept it in contracts. We don\'t accept it in medicine. We don\'t accept it in relationships. In every other area of life, consent means the right to say no without being punished.',
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
      'Before government welfare programs existed, voluntary institutions — mutual aid societies, fraternal organizations, religious charities, community networks — provided healthcare, education, disaster relief, and poverty assistance. These systems were <em>replaced</em> by government programs, not because they failed, but because political actors argued they could do it better through force.',
      'The deeper question: does taking James\'s money against his will actually help Sarah in the most sustainable way? Or does it create dependency, reduce James\'s willingness to give voluntarily, erode the community bonds that produce real care — and ultimately generate worse outcomes than cooperation would?',
      'Consider the massive reduction in global poverty over the past two centuries. That progress came primarily from expanding voluntary exchange and economic freedom — not from redistribution programs.'
    ],
    concession: 'This is where the philosophy must be most honest. Voluntary systems are not guaranteed to catch every person who falls. During any transition from coercive to voluntary systems, some people who currently receive government help might experience disruption. The philosophy cannot credibly promise zero casualties. What it can argue is that the <em>trajectory</em> of voluntary cooperation points toward greater flourishing for everyone — and that coercive systems create their own suffering, less visible but equally real.',
    question: 'Is compassion measured by your willingness to use force on others — or by your willingness to act yourself? If you care about Sarah, what\'s stopping you from helping her directly, right now, without waiting for a politician to take James\'s money?'
  },

  'democracy': {
    title: '"Government has democratic legitimacy."',
    steelman: 'When 60% of voters approve a tax, that\'s collective self-governance — the most legitimate form of authority humans have devised. Comparing that to one person unilaterally taking another\'s property ignores the moral weight of democratic process. Democracy isn\'t just a mechanism; it\'s how free people govern themselves.',
    response: [
      'Democratic process determines <em>who</em> makes a decision. It doesn\'t transform the <em>nature</em> of the action.',
      'If 60% of your neighbors voted that you must give $500 a month to a community fund — and men with guns would come to your house if you refused — the vote wouldn\'t change what happens to you. Your money still leaves your possession against your will. The vote changes the <em>authority</em>, not the <em>experience of the person being acted upon</em>.',
      'The Philosophy of Human Respect holds that the effect on the person experiencing force doesn\'t change based on how many people authorized it. Democratic authorization makes coercion more orderly — which is genuinely better than chaotic coercion — but it doesn\'t make it voluntary.',
      'History is full of democratic majorities authorizing terrible things. Slavery was democratically supported. Segregation was passed by elected legislatures. Democratic legitimacy has never been sufficient, on its own, to make an action moral.'
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

echo "  ✓ objectionData.js"

# ══════════════════════════════════════
# SCREEN COMPONENTS
# ══════════════════════════════════════

# ── Opening ──
cat > src/components/experiences/exp02/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 02 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">You have a <em>"but..."</em></h1>
    <Divider :centered="true" />
    <p class="subtitle">Good. A philosophy that can't withstand your strongest objection isn't worth your time. Let's find out if this one can.</p>
    <button class="begin-btn" @click="$emit('advance')">
      Choose your objection <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.opening { text-align: center; padding: 2rem 0; }
.overline {
  font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--ochre-light); margin-bottom: 2rem; display: block;
}
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle {
  font-family: var(--sans); font-size: 1rem; line-height: 1.8;
  color: rgba(240,235,227,0.65); max-width: 480px; margin: 0 auto;
}
.begin-btn {
  display: inline-block; margin-top: 3rem; padding: 1rem 3rem;
  background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light);
  border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500;
  cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em;
}
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening.vue"

# ── ChooseObjection ──
cat > src/components/experiences/exp02/ChooseObjection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your strongest pushback</p>
    <h2 class="display-medium">Which of these is closest to what you're thinking?</h2>
    <p class="body-text" style="margin-top: 1rem;">Pick the one that feels most true to you — the objection you'd make if we were having this conversation in person.</p>
    <div class="choices">
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'social-contract'"
        @select="choose('social-contract')"
      >
        <template #label>"I consented to taxation by living in a democratic society."</template>
        <template #detail>It's not like theft — I agreed to this by participating in the system.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'people-will-die'"
        @select="choose('people-will-die')"
      >
        <template #label>"Without taxes, people will die."</template>
        <template #detail>Some things are too important to leave to voluntary charity.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'democracy'"
        @select="choose('democracy')"
      >
        <template #label>"A democratic vote makes it legitimate."</template>
        <template #detail>Collective self-governance is fundamentally different from personal theft.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'public-goods'"
        @select="choose('public-goods')"
      >
        <template #label>"Some things can't be funded voluntarily."</template>
        <template #detail>Roads, courts, defense — the free rider problem is real.</template>
      </ChoiceCard>
    </div>
    <NavBar
      :can-go-back="true"
      :disable-continue="!journey.exp02.chosenObjection"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose-objection'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(key) {
  emit('choose-objection', key)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2rem 0 1rem; }
</style>
VUEEOF

echo "  ✓ ChooseObjection.vue"

# ── Steelman ──
cat > src/components/experiences/exp02/Steelman.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Taking your objection seriously</p>
    <h2 class="display-medium">{{ obj.title }}</h2>
    <Divider />
    <p class="body-text-large">Before responding, we need to state your objection in its strongest form. Not a caricature. Not a straw man. The real argument, as a thoughtful person would make it.</p>
    <ContentBlock variant="mirror" label="Your objection, at its strongest">
      <p>{{ obj.steelman }}</p>
    </ContentBlock>
    <p class="body-text">If this doesn't capture your position well enough, that's fair — these are complex ideas. But this is the version we're going to engage with, because this is the version that deserves a serious answer.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ Steelman.vue"

# ── Response ──
cat > src/components/experiences/exp02/Response.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The honest response</p>
    <h2 class="display-medium">Here's what the philosophy says back.</h2>
    <Divider />
    <ContentBlock variant="insight" label="The response">
      <p v-for="(para, i) in obj.response" :key="i" v-html="para"></p>
    </ContentBlock>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ Response.vue"

# ── Concession ──
cat > src/components/experiences/exp02/Concession.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">What honesty requires</p>
    <h2 class="display-medium">What the philosophy can't claim.</h2>
    <Divider />
    <p class="body-text-large">A philosophy that only gives you the strong parts of its argument and hides the difficult parts isn't trustworthy. So here's what intellectual honesty requires us to say.</p>
    <ContentBlock variant="concession" label="The honest concession">
      <p v-html="obj.concession"></p>
    </ContentBlock>
    <p class="body-text">You may find this concession sufficient reason to reject the philosophy entirely. That's your right, and it's the kind of decision the philosophy itself asks you to make — freely, without coercion.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ Concession.vue"

# ── TheQuestion ──
cat > src/components/experiences/exp02/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">We don't end with an answer. We end with a question.</h2>
    <Divider />
    <p class="body-text-large">You came in with an objection. You've seen it taken seriously, responded to, and the limits of that response honestly acknowledged. Now there's a question left.</p>
    <ContentBlock variant="principle">
      <p v-html="obj.question"></p>
    </ContentBlock>
    <p class="body-text">This isn't rhetorical. It's a question worth sitting with — maybe for a few days. The Philosophy of Human Respect doesn't ask you to accept it today. It asks you to carry the question and see if the world starts looking different.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ TheQuestion.vue"

# ── WhereNext ──
cat > src/components/experiences/exp02/WhereNext.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each of the other objections gets the same treatment — steelmanned, responded to, conceded where honesty requires, and left as an open question. You might find that one of them changes your mind where this one didn't.</p>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard
        v-for="key in otherObjections"
        :key="key"
        href="#"
        @click.prevent="$emit('restart-with', key)"
      >
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Or continue your journey</p>
      <PathCard href="#" @click.prevent="$emit('share')">
        <template #title>Share this with someone who disagrees</template>
        <template #desc>See which objection they choose — and whether the response holds up for them too.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Revisit the original thought experiment</template>
        <template #desc>Experience 01: The Question That Changes Everything</template>
      </PathCard>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with', 'share'])
const journey = useJourneyStore()
const otherObjections = computed(() =>
  Object.keys(allObjections).filter(k => k !== journey.exp02.chosenObjection)
)
const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  // Mark experience as complete
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ WhereNext.vue"

echo ""
echo "✅ Experience 02 complete!"
echo ""
echo "Files created:"
echo "  src/pages/Experience02.vue"
echo "  src/components/experiences/exp02/objectionData.js"
echo "  src/components/experiences/exp02/Opening.vue"
echo "  src/components/experiences/exp02/ChooseObjection.vue"
echo "  src/components/experiences/exp02/Steelman.vue"
echo "  src/components/experiences/exp02/Response.vue"
echo "  src/components/experiences/exp02/Concession.vue"
echo "  src/components/experiences/exp02/TheQuestion.vue"
echo "  src/components/experiences/exp02/WhereNext.vue"
echo ""
echo "Test: npm run dev → navigate to /experience/the-objection"
