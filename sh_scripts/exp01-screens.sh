#!/bin/bash
# Creates all Experience 01 screen components
# Run from humanrespect-app/ root after running setup.sh

set -e

mkdir -p src/components/experiences/exp01

# ── Opening ──
cat > src/components/experiences/exp01/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">A five-minute philosophical experiment</span>
    <h1 class="display-large" style="margin-bottom: 0.3em;">
      You live by a moral code<br><em>you've never put into words.</em>
    </h1>
    <Divider :centered="true" />
    <p class="body-text" style="color: rgba(240,235,227,0.65);">
      In the next few minutes, you'll discover what that code is — and a question
      about it you've probably never thought to ask.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Begin <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])

const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})
</script>

<style scoped>
.opening {
  text-align: center;
  padding: 2rem 0;
}
.overline {
  font-size: 0.75rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--ochre-light);
  margin-bottom: 2rem;
  display: block;
}
.begin-btn {
  display: inline-block;
  margin-top: 3rem;
  padding: 1rem 3rem;
  background: transparent;
  color: var(--ochre-light);
  border: 1px solid var(--ochre-light);
  border-radius: 100px;
  font-family: var(--serif);
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 0.05em;
}
.begin-btn:hover {
  background: var(--ochre-light);
  color: var(--bg-dark);
}
.begin-btn .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
}
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

# ── CommonGround ──
cat > src/components/experiences/exp01/CommonGround.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The starting point</p>
    <h2 class="display-medium">Every person you've ever met shares something fundamental with you.</h2>
    <Divider />
    <p class="body-text-large">Your closest friend. Your political opponent. The stranger on the bus. Every one of them woke up this morning trying to build a life that works — seeking some version of happiness, security, and meaning.</p>
    <p class="body-text">This isn't a sentimental idea. It's observation. The universal human drive to flourish is as real and consistent as any pattern in nature. Everything that follows builds on this single, shared foundation.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

# ── Scenario ──
cat > src/components/experiences/exp01/Scenario.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">A thought experiment</p>
    <h2 class="display-medium">Imagine this.</h2>
    <ScenarioBox label="The situation">
      <p>Your neighbor <strong>Sarah</strong> is a single mother who just lost her job. She can't make rent this month. Her kids might go hungry.</p>
      <p>You want to help. Everyone on your street wants to help. That's not the question.</p>
      <p>The question is <em>how</em>.</p>
    </ScenarioBox>
    <p class="body-text">You know that another neighbor, <strong>James</strong>, has the money. He could easily cover Sarah's rent without any real hardship to himself. But he hasn't offered.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

# ── PersonalChoice ──
cat > src/components/experiences/exp01/PersonalChoice.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your instinct</p>
    <h2 class="display-medium">Would you personally walk into James's house, take $1,200 from his savings, and give it to Sarah?</h2>
    <p class="body-text" style="margin-top: 1rem;">Remember: Sarah genuinely needs it. James can afford it. The cause is compassionate.</p>
    <div class="choices">
      <ChoiceCard :selected="journey.exp01.personal === 'no'" @select="choose('no')">
        <template #label>No.</template>
        <template #detail>Taking someone's money without their permission is wrong — even for a good cause. I'd find another way to help Sarah.</template>
      </ChoiceCard>
      <ChoiceCard :selected="journey.exp01.personal === 'yes'" @select="choose('yes')">
        <template #label>Yes.</template>
        <template #detail>Sarah's need is urgent enough. If James won't help voluntarily, taking the money to save her family is justified.</template>
      </ChoiceCard>
    </div>
    <NavBar :can-go-back="true" :disable-continue="!journey.exp01.personal" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(value) {
  emit('choose', { key: 'personal', value })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2.5rem 0 1rem; }
</style>
VUEEOF

# ── PoliticalChoice ──
cat > src/components/experiences/exp01/PoliticalChoice.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The same question, differently</p>
    <h2 class="display-medium">Now imagine the same situation — but at the scale of a city.</h2>
    <ScenarioBox label="The policy">
      <p>Thousands of people like Sarah need help. A politician proposes a new tax on people like James — taking a portion of their income to fund housing assistance for families in crisis.</p>
      <p>Same money. Same cause. Same people. The only thing that changes is <em>who does the taking</em>.</p>
    </ScenarioBox>
    <div class="choices">
      <ChoiceCard :selected="journey.exp01.political === 'yes'" @select="choose('yes')">
        <template #label>Yes, I'd support this policy.</template>
        <template #detail>This is what democratic government is for — pooling resources to help people who need it.</template>
      </ChoiceCard>
      <ChoiceCard :selected="journey.exp01.political === 'no'" @select="choose('no')">
        <template #label>No, I'd oppose this policy.</template>
        <template #detail>Even through government, taking someone's money without their individual consent is wrong. We should find voluntary ways to help.</template>
      </ChoiceCard>
    </div>
    <NavBar :can-go-back="true" :disable-continue="!journey.exp01.political" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(value) {
  emit('choose', { key: 'political', value })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2.5rem 0 1rem; }
</style>
VUEEOF

# ── Mirror ──
cat > src/components/experiences/exp01/Mirror.vue << 'VUEEOF'
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
        <p>You may have seen where this was headed. That's fine — it doesn't change the fact that you gave two different answers to what is, at its core, the same moral question. <strong>Most people do.</strong> We hold one standard for personal conduct and a different one for political action, and we rarely stop to ask why.</p>
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

# ── WhyTheGap ──
cat > src/components/experiences/exp01/WhyTheGap.vue << 'VUEEOF'
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
    <p class="body-text">But here's what doesn't change: the money still leaves James's pocket. He still didn't choose to give it. And his capacity to flourish still decreases — regardless of who authorized the taking.</p>
    <ContentBlock variant="principle">
      <p>The effect on the person being acted upon doesn't change based on who authorized the action. This turns out to be a pattern with profound implications.</p>
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

# ── ThePrinciple ──
cat > src/components/experiences/exp01/ThePrinciple.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern has a name</p>
    <h2 class="display-medium">The Principle of Human Respect</h2>
    <Divider />
    <p class="body-text-large">Across every culture and era, a consistent pattern holds: when people experience violence initiated against them, or theft of their property through force or fraud, their happiness, harmony, and prosperity decrease.</p>
    <p class="body-text">This is true whether the force comes from a mugger, a dictator, a majority vote, or a well-intentioned policy. The mechanism doesn't change the effect.</p>
    <ContentBlock variant="principle">
      <p>Human happiness, harmony, and prosperity always decrease as persons experience the initiation of violence, or the theft of their property or time through force or fraud.</p>
    </ContentBlock>
    <p class="body-text">And the inverse holds too. Wherever people interact through persuasion and voluntary cooperation — in friendships, in markets, in communities that choose to help each other — flourishing increases.</p>
    <p class="body-text">This is what the thought experiment was pointing toward. Not a political ideology, but an observation about cause and effect: <em>how</em> we pursue good outcomes matters as much as the outcomes themselves.</p>
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

# ── Invitation ──
cat > src/components/experiences/exp01/Invitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="8" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />
    <p class="body-text-large">You already live by the principle of Human Respect in most of your life. You don't steal from neighbors. You don't threaten coworkers. You solve problems through conversation, persuasion, and voluntary agreement.</p>
    <p class="body-text-large">The question is whether you'll extend that same principle to how you think about politics and society.</p>
    <p class="closing-question">What if every social problem you care about could be addressed through cooperation instead of force — and what if the solutions would actually work better?</p>
    <ContentBlock variant="insight">
      <p>This isn't a question that gets answered in five minutes. It's a question that changes how you see every political argument, every policy debate, every election — for the rest of your life.</p>
    </ContentBlock>
    <p class="body-text" style="text-align: center; margin-top: 2rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>

    <div class="continue-paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>You probably have a "but..."</template>
        <template #desc>Pick your strongest objection. We'll take it seriously, respond honestly, and tell you what the philosophy can't claim.</template>
      </PathCard>
      <PathCard href="#" @click.prevent="share">
        <template #title>Share this experience</template>
        <template #desc>{{ shareDesc }}</template>
      </PathCard>
      <PathCard href="#">
        <template #title>Get one idea per week</template>
        <template #desc>A weekly email exploring how the principle of Human Respect applies to the issues you care about.</template>
      </PathCard>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'

const journey = useJourneyStore()
const el = ref(null)
const shareDesc = ref('Send this thought experiment to someone you disagree with politically. See what they discover.')

onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  // Mark experience as complete
  journey.completeExp01(journey.exp01.personal, journey.exp01.political)
})

function share() {
  const text = "I just went through a 5-minute thought experiment that showed me something I'd never noticed about my own political beliefs."
  const url = window.location.origin + '/experience/the-question'

  if (navigator.share) {
    navigator.share({ title: 'The Question That Changes Everything', text, url })
  } else {
    navigator.clipboard.writeText(text + ' ' + url).then(() => {
      shareDesc.value = 'Link copied to clipboard.'
      setTimeout(() => {
        shareDesc.value = 'Send this thought experiment to someone you disagree with politically. See what they discover.'
      }, 2000)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question {
  font-family: var(--serif);
  font-size: clamp(1.3rem, 3vw, 1.6rem);
  line-height: 1.5;
  color: var(--ink);
  text-align: center;
  margin: 2rem 0;
  font-style: italic;
}
</style>
VUEEOF

echo "✅ All Experience 01 screen components created"
