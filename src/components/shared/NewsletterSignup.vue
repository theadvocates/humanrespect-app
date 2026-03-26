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
