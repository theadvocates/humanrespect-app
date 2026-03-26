#!/bin/bash
# Newsletter: Buttondown integration + contextual placement
# Run from humanrespect-app/ root
#
# BEFORE RUNNING: 
# 1. Create a Buttondown account at buttondown.com
# 2. Go to Settings → API → copy your API key
# 3. Add VITE_BUTTONDOWN_API_KEY to your .env.local file
# 4. Add VITE_BUTTONDOWN_API_KEY to Cloudflare Pages env vars

set -e

echo "📧 Building newsletter integration..."

# ══════════════════════════════════════
# 1. UPDATED NEWSLETTER COMPONENT
#    Posts to both Supabase AND Buttondown
#    Accepts contextual copy via props
# ══════════════════════════════════════

cat > src/components/shared/NewsletterSignup.vue << 'VUEEOF'
<template>
  <div class="newsletter-block" :class="{ 'newsletter-minimal': variant === 'minimal' }">
    <div v-if="!submitted" class="newsletter-form">
      <p class="newsletter-headline">{{ headline }}</p>
      <p class="newsletter-desc">{{ description }}</p>
      <div class="input-row">
        <input
          type="email"
          class="email-input"
          v-model="email"
          placeholder="Your email address"
          @keydown.enter="submit"
        />
        <button
          class="submit-btn"
          :disabled="!isValid || submitting"
          @click="submit"
        >
          {{ submitting ? '...' : buttonText }}
        </button>
      </div>
      <p v-if="error" class="error-msg">{{ error }}</p>
      <p class="privacy-note">No spam. No selling data. Unsubscribe anytime. We respect your time — it's kind of our whole thing.</p>
    </div>
    <div v-else class="newsletter-success">
      <p class="success-msg">{{ successMessage }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAnalytics } from '@/composables/useAnalytics'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  headline: { type: String, default: 'The questions don\'t stop here.' },
  description: { type: String, default: 'One short email per week applying the Philosophy of Human Respect to a real situation. No selling. No spam. Just the question, applied.' },
  buttonText: { type: String, default: 'Subscribe' },
  successMessage: { type: String, default: 'You\'re in. Watch for your first email.' },
  source: { type: String, default: 'unknown' },
  variant: { type: String, default: 'full' } // 'full' or 'minimal'
})

const { trackNewsletterSignup } = useAnalytics()
const journey = useJourneyStore()

const email = ref('')
const submitting = ref(false)
const submitted = ref(false)
const error = ref('')

const isValid = computed(() => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value))

async function submit() {
  if (!isValid.value || submitting.value) return

  submitting.value = true
  error.value = ''
  const cleanEmail = email.value.toLowerCase().trim()

  // Fire both requests concurrently
  const results = await Promise.allSettled([
    subscribeSupabase(cleanEmail),
    subscribeButtondown(cleanEmail)
  ])

  // Check if at least one succeeded
  const supabaseResult = results[0]
  const buttondownResult = results[1]

  if (supabaseResult.status === 'fulfilled' || buttondownResult.status === 'fulfilled') {
    submitted.value = true
    trackNewsletterSignup(props.source)
  } else {
    error.value = 'Something went wrong. Please try again.'
    console.warn('Both newsletter services failed:', results)
  }

  submitting.value = false
}

async function subscribeSupabase(emailAddr) {
  const { error: dbError } = await supabase
    .from('newsletter_subscribers')
    .insert({
      email: emailAddr,
      source: props.source,
      visitor_id: journey.visitorId,
      subscribed_at: new Date().toISOString()
    })

  // Duplicate email is fine
  if (dbError && dbError.code !== '23505') throw dbError
}

async function subscribeButtondown(emailAddr) {
  const apiKey = import.meta.env.VITE_BUTTONDOWN_API_KEY
  if (!apiKey || apiKey === 'placeholder') {
    console.warn('Buttondown API key not configured — skipping')
    return // Don't fail if key isn't set yet
  }

  const response = await fetch('https://api.buttondown.com/v1/subscribers', {
    method: 'POST',
    headers: {
      'Authorization': `Token ${apiKey}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email_address: emailAddr,
      tags: [props.source],
      metadata: {
        visitor_id: journey.visitorId,
        furthest_tier: journey.furthestTier,
        source: props.source
      }
    })
  })

  if (!response.ok) {
    const data = await response.json().catch(() => ({}))
    // 409 = already subscribed, treat as success
    if (response.status === 409) return
    throw new Error(data.detail || `Buttondown error: ${response.status}`)
  }
}
</script>

<style scoped>
.newsletter-block {
  margin: 2.5rem 0;
  padding: 2rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
}

.newsletter-minimal {
  padding: 1.5rem;
  background: transparent;
  border: 1px solid var(--border-subtle);
}

.newsletter-headline {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.35rem;
}

.newsletter-minimal .newsletter-headline {
  font-size: 1rem;
}

.newsletter-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.6;
  margin-bottom: 1.25rem;
}

.input-row {
  display: flex;
  gap: 0.5rem;
}

.email-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink);
  background: white;
  outline: none;
  transition: border-color 0.2s;
}

.email-input:focus { border-color: var(--ochre); }
.email-input::placeholder { color: var(--ink-faint); }

.submit-btn {
  padding: 0.75rem 1.5rem;
  background: var(--ochre);
  color: white;
  border: none;
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  white-space: nowrap;
  -webkit-tap-highlight-color: transparent;
}

.submit-btn:hover:not(:disabled) { background: var(--ochre-light); }
.submit-btn:disabled { opacity: 0.4; cursor: not-allowed; }

.privacy-note {
  font-size: 0.72rem;
  color: var(--ink-faint);
  margin-top: 0.75rem;
  font-style: italic;
}

.error-msg {
  font-size: 0.8rem;
  color: var(--concede-warm);
  margin-top: 0.5rem;
}

.newsletter-success {
  text-align: center;
  padding: 1rem 0;
}

.success-msg {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--insight-green);
  font-style: italic;
}

@media (max-width: 480px) {
  .newsletter-block { padding: 1.5rem; }
  .newsletter-minimal { padding: 1.25rem; }
  .input-row { flex-direction: column; }
  .submit-btn { width: 100%; }
}
</style>
VUEEOF

echo "  ✓ NewsletterSignup updated with Buttondown + contextual props"

# ══════════════════════════════════════
# 2. REMOVE newsletter from Exp01 Invitation
#    (too early — visitor hasn't built enough trust)
# ══════════════════════════════════════

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

    <PathCard href="#" @click.prevent="share">
      <template #title>Share this experience</template>
      <template #desc>{{ shareDesc }}</template>
    </PathCard>

    <JourneyNav current="exp01" />

    <p class="body-text" style="text-align: center; margin-top: 2rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

const journey = useJourneyStore()
const { trackShare } = useAnalytics()
const el = ref(null)
const shareDesc = ref('Send this thought experiment to someone you disagree with politically.')

onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp01(journey.exp01.personal, journey.exp01.political)
})

function share() {
  const text = "I just went through a 5-minute thought experiment that showed me something I'd never noticed about my own political beliefs."
  const url = window.location.origin + '/experience/the-question'
  if (navigator.share) {
    navigator.share({ title: 'The Question', text, url })
    trackShare('native', 'exp01')
  } else {
    navigator.clipboard.writeText(text + ' ' + url).then(() => {
      shareDesc.value = 'Link copied to clipboard.'
      trackShare('clipboard', 'exp01')
      setTimeout(() => { shareDesc.value = 'Send this thought experiment to someone you disagree with politically.' }, 2000)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.6rem); line-height: 1.5; color: var(--ink); text-align: center; margin: 2rem 0; font-style: italic; }
</style>
VUEEOF

echo "  ✓ Exp01 Invitation — newsletter removed (too early)"

# ══════════════════════════════════════
# 3. ADD newsletter to Exp03 TheBridge
#    (first placement — foundation complete)
# ══════════════════════════════════════

cat > src/components/experiences/exp03/TheBridge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">You now have the complete framework.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div><div class="foundation-title">The gap</div><p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div><div class="foundation-title">The objection</div><p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div><div class="foundation-title">The grounding</div><p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time.</p></div>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">From here, the philosophy goes deeper into each dimension.</p>

    <NewsletterSignup
      source="exp03_bridge"
      headline="The questions don't stop here."
      description="Once you start seeing the force/persuasion distinction, you notice it everywhere — in the news, in conversations, in your own decisions. We send one short email per week applying the Philosophy of Human Respect to a real situation. No selling. No spam. Just the question, applied."
      success-message="You're in. The first question arrives this week."
    />

    <JourneyNav current="exp03" next-label="Go deeper" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.foundation-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
</style>
VUEEOF

echo "  ✓ Exp03 TheBridge — newsletter added (first placement)"

# ══════════════════════════════════════
# 4. ADD minimal newsletter to Pillar closings
# ══════════════════════════════════════

# Pillar A
cat > src/components/experiences/pillarA/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If physical safety is the precondition for flourishing...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...what does that mean for institutions whose primary tool is the threat of force?</p></ContentBlock>
    <p class="body-text-large">Every law is ultimately backed by the threat of physical enforcement. Every tax carries the implicit promise: comply, or men with guns will eventually come.</p>
    <ContentBlock variant="insight"><p>A society aligned with Human Respect must design systems that protect bodies and restore safety <em>without</em> becoming a source of the fear they're meant to prevent.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarA_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarA" />
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

# Pillar B
cat > src/components/experiences/pillarB/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />
    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>
    <ContentBlock variant="principle"><p>...then a political system that operates by taking people's time without their individual consent is consuming the very substance of human life.</p></ContentBlock>
    <p class="body-text">This doesn't make the people in government evil. It means the <em>system</em> is misaligned with what human beings actually need to flourish.</p>
    <div class="closing-question-block"><p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p></div>
    <ContentBlock variant="insight"><p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks fundamentally different.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarB_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarB" />
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
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question-block { margin: 2.5rem 0; text-align: center; padding: 2rem 1.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.7rem); line-height: 1.45; color: var(--ink); font-style: italic; font-weight: 400; }
</style>
VUEEOF

# Pillar C
cat > src/components/experiences/pillarC/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">If property is crystallized time, and time is the substance of life...</h2>
    <Divider />
    <ContentBlock variant="principle"><p>...then what is taxation of legitimately earned property — and what would voluntary funding look like?</p></ContentBlock>
    <p class="body-text-large">If every dollar you earned represents hours of your life, then taking those dollars without your individual consent is taking your life-hours.</p>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>The philosophy doesn't claim that transitioning to voluntary funding is simple. The argument is <em>directional</em>: we should be moving toward more voluntary funding and less compulsory taking.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarC_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarC" />
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

# Pillar D
cat > src/components/experiences/pillarD/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">Can you hold your deepest values and commit to advancing them only through persuasion?</h2>
    <Divider />
    <p class="body-text-large">Not because your values don't matter. Because the method matters as much as the goal.</p>
    <ContentBlock variant="principle"><p>Can you hold your deepest values while committing never to force them on another person? And if you can — what would that actually look like?</p></ContentBlock>
    <ContentBlock variant="concession" label="The honest acknowledgment"><p>This is genuinely hard. When you care deeply about an issue, the temptation to use force is powerful. The philosophy asks you to trust that persuasion and cooperation will produce better outcomes — even for the causes you care about most.</p></ContentBlock>
    <p class="body-text">The political wars of our era are not really about values. They're about method. The moment enough people commit to persuasion over force, the war ends.</p>
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

# Pillar E
cat > src/components/experiences/pillarE/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />
    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies.</p>
    <ContentBlock variant="principle"><p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p></ContentBlock>
    <ContentBlock variant="insight"><p>The Philosophy of Human Respect claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity.</p></ContentBlock>

    <div v-if="otherIssues.length" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another issue</p>
      <PathCard v-for="issue in otherIssues" :key="issue.id" href="#" @click.prevent="$emit('restart-with', issue.id)">
        <template #title>{{ issue.label }}</template>
        <template #desc>See voluntary alternatives for {{ issue.label.toLowerCase() }}.</template>
      </PathCard>
    </div>

    <NewsletterSignup variant="minimal" source="pillarE_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarE" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { appliedIssues } from './examplesData.js'

defineEmits(['restart-with'])
const chosenIssue = inject('chosenIssue', ref(null))
const otherIssues = computed(() => appliedIssues.filter(i => i.id !== chosenIssue.value))
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ All 5 Pillar closings — minimal newsletter added"

# ══════════════════════════════════════
# 5. ADD action-oriented newsletter to Practice closings
# ══════════════════════════════════════

# Practice 01
cat > src/components/experiences/practice01/TheReflection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />
    <p class="body-text-large">Pick one area where you currently support force and ask yourself: is there a voluntary alternative?</p>
    <ContentBlock variant="insight"><p>Your political footprint shrinks one conscious choice at a time.</p></ContentBlock>
    <NewsletterSignup source="practice01_closing" headline="Keep practicing." description="A weekly email with one real-world situation and the question: force or persuasion? Plus what other people designed as voluntary solutions." button-text="I'm in" success-message="Welcome. The first situation arrives this week." />
    <JourneyNav current="practice01" />
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

# Practice 02
cat > src/components/experiences/practice02/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real challenge</p>
    <h2 class="display-medium">Was it harder than you expected?</h2>
    <Divider />
    <p class="body-text-large">If it was, that's the point. We've been trained to reach for force as the default.</p>
    <ContentBlock variant="insight"><p>Whatever you drafted, it respects everyone involved. No one is forced. Every participant chose to be there.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The next time you hear a political proposal, try this: strip out the force. What would the same goal look like through persuasion alone?</p></ContentBlock>
    <NewsletterSignup source="practice02_closing" headline="Keep practicing." description="Each week, we take one real political proposal and ask: what would this look like without force? Join and practice alongside others." button-text="I'm in" success-message="Welcome. The first situation arrives this week." />
    <JourneyNav current="practice02" />
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

# Practice 03
cat > src/components/experiences/practice03/TheInvitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The most powerful tool</p>
    <h2 class="display-medium">Share the experience, not the argument.</h2>
    <Divider />
    <p class="body-text-large">A conclusion someone reaches themselves is a hundred times more powerful than one you handed them. Share <strong>Experience 01</strong> and let them discover the gap on their own.</p>
    <div class="share-block">
      <button class="share-btn" @click="copyLink">{{ copied ? 'Copied!' : 'Copy link to humanrespect.app' }}</button>
    </div>
    <NewsletterSignup source="practice03_closing" headline="Keep practicing." description="Weekly conversation fuel — one real situation, the force/persuasion question applied, and ideas from others who are having these conversations too." button-text="I'm in" success-message="Welcome. Conversation fuel arrives this week." />
    <JourneyNav current="practice03" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
const copied = ref(false)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
function copyLink() {
  navigator.clipboard.writeText('https://humanrespect.app').then(() => {
    copied.value = true; setTimeout(() => { copied.value = false }, 2000)
  })
}
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.share-block { text-align: center; margin: 2rem 0; }
.share-btn { padding: 0.85rem 2rem; background: var(--ochre); color: white; border: none; border-radius: 100px; font-family: var(--sans); font-size: 0.9rem; cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.share-btn:hover { background: var(--ochre-light); transform: translateY(-1px); }
</style>
VUEEOF

# Practice 04
cat > src/components/experiences/practice04/TheCommitment.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play.</p>
    <ContentBlock variant="insight"><p>By the end of seven days, you'll see the force/persuasion question everywhere. That's not the philosophy talking. That's your own observation.</p></ContentBlock>
    <ContentBlock variant="principle"><p>The Philosophy of Human Respect isn't something you adopt in a moment. It's something you discover gradually, as you notice the pattern in your own daily life.</p></ContentBlock>
    <NewsletterSignup source="practice04_closing" headline="Keep noticing." description="One email per week with a real situation to apply the audit to. Think of it as your weekly prompt." button-text="I'm in" success-message="Welcome. Your first weekly prompt arrives soon." />
    <JourneyNav current="practice04" />
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

# Practice 05
cat > src/components/experiences/practice05/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The real question</p>
    <h2 class="display-medium">Will you actually do it?</h2>
    <Divider />
    <p class="body-text-large">You just designed a voluntary solution to a real problem. The question is whether you'll take the first step.</p>
    <ContentBlock variant="principle"><p>You don't need permission. You don't need a law. You need one conversation with one other person who cares about the same problem. Start there.</p></ContentBlock>
    <NewsletterSignup source="practice05_closing" headline="Keep building." description="Each week, we share one voluntary solution someone actually built — real people solving real problems without force. Get inspired, then build your own." button-text="I'm in" success-message="Welcome. Real solutions, weekly." />
    <JourneyNav current="practice05" />
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

echo "  ✓ All 5 Practice closings — action-oriented newsletter added"

echo ""
echo "✅ Newsletter integration complete!"
echo ""
echo "Placement strategy:"
echo "  ✗ Exp01 — removed (too early, trust not built)"
echo "  ✗ Exp02 — not added (visitor still processing objections)"
echo "  ✓ Exp03 — FIRST placement, full variant, 'questions don't stop here'"
echo "  ✓ Pillars A-E — minimal variant, 'one question per week'"
echo "  ✓ Practices 01-05 — full variant, action-oriented 'keep practicing/building'"
echo ""
echo "TO COMPLETE SETUP:"
echo "  1. Create Buttondown account at buttondown.com"
echo "  2. Copy your API key from Settings → API"
echo "  3. Add to .env.local:  VITE_BUTTONDOWN_API_KEY=your_key_here"
echo "  4. Add to Cloudflare Pages env vars:  VITE_BUTTONDOWN_API_KEY=your_key_here"
echo ""
echo "Push with: git add . && git commit -m 'newsletter: buttondown + contextual placement' && git push"
