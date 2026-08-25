<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Your account</p>
      <h1 class="display-large">Keep your thinking<br><em>where you can find it.</em></h1>
      <Divider />

      <p class="body-text-large">
        {{ hasProgress
          ? 'You have work in progress on this device. Sign in and it comes with you — to your phone, your laptop, and back again.'
          : 'An account keeps your progress across devices and lets you pick up where you left off.' }}
      </p>

      <p class="body-text reassurance">
        Nothing you have done so far is lost by signing in. Your progress is
        carried over and merged, not replaced.
      </p>

      <!-- Sent state -->
      <div v-if="sent" class="sent-state">
        <div class="sent-mark">✓</div>
        <h2 class="display-medium">Check your email.</h2>
        <p class="body-text">
          We sent a sign-in link to <strong>{{ email }}</strong>. It expires in an hour.
        </p>
        <button class="text-button" @click="sent = false">Use a different address</button>
      </div>

      <!-- Form -->
      <div v-else class="signin-form">
        <button class="google-button" :disabled="loading" @click="handleGoogle">
          <svg class="google-mark" viewBox="0 0 18 18" aria-hidden="true">
            <path fill="#4285F4" d="M17.64 9.2c0-.64-.06-1.25-.16-1.84H9v3.48h4.84a4.14 4.14 0 0 1-1.8 2.72v2.26h2.92a8.78 8.78 0 0 0 2.68-6.62z"/>
            <path fill="#34A853" d="M9 18c2.43 0 4.47-.8 5.96-2.18l-2.92-2.26c-.8.54-1.84.86-3.04.86-2.34 0-4.32-1.58-5.03-3.7H.96v2.34A9 9 0 0 0 9 18z"/>
            <path fill="#FBBC05" d="M3.97 10.72a5.4 5.4 0 0 1 0-3.44V4.94H.96a9 9 0 0 0 0 8.12l3.01-2.34z"/>
            <path fill="#EA4335" d="M9 3.58c1.32 0 2.5.46 3.44 1.35l2.58-2.58A9 9 0 0 0 .96 4.94l3.01 2.34C4.68 5.16 6.66 3.58 9 3.58z"/>
          </svg>
          Continue with Google
        </button>

        <div class="divider-or"><span>or</span></div>

        <form @submit.prevent="handleMagicLink">
          <label class="field-label" for="email">Email address</label>
          <input
            id="email"
            v-model="email"
            type="email"
            class="email-input"
            placeholder="you@example.com"
            autocomplete="email"
            :disabled="loading"
          >
          <p v-if="error" class="field-error">{{ error }}</p>
          <button class="submit-button" type="submit" :disabled="!isValid || loading">
            {{ loading ? 'Sending…' : 'Email me a sign-in link' }}
          </button>
        </form>

        <p class="body-text fine-print">
          No password to remember. We email you a link that signs you in.
          See how we handle your data in our
          <router-link to="/privacy" class="inline-link">privacy notice</router-link>.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'

definePageMeta({ name: 'sign-in' })
usePageSeo('sign-in')

const { sendMagicLink, signInWithGoogle, loading, isSignedIn } = useAuth()
const journey = useJourneyStore()

const email = ref('')
const sent = ref(false)
const error = ref('')

const isValid = computed(() => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value))
const hasProgress = computed(() => journey.completionCount > 0)

// Already signed in — nothing to do here. Client-only, since the session is
// only known in the browser.
watchEffect(() => {
  if (import.meta.client && isSignedIn.value) navigateTo('/account')
})

async function handleMagicLink() {
  if (!isValid.value) return
  error.value = ''
  try {
    await sendMagicLink(email.value)
    sent.value = true
  } catch (e) {
    error.value = e.message || 'Could not send the link. Please try again.'
  }
}

async function handleGoogle() {
  error.value = ''
  try {
    await signInWithGoogle()
  } catch (e) {
    error.value = e.message || 'Could not start Google sign-in.'
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: var(--paper); }
.page-container { max-width: 620px; margin: 0 auto; padding: 6rem 1.5rem 5rem; }

.reassurance {
  margin-top: 1rem;
  color: var(--ink-muted);
  padding-left: 1rem;
  border-left: 2px solid var(--ochre-light);
}

.signin-form { margin-top: 3rem; }

.google-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  width: 100%;
  padding: 0.9rem 1.5rem;
  font-family: var(--sans);
  font-size: 0.95rem;
  color: var(--ink);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  cursor: pointer;
  transition: border-color var(--transition), background var(--transition);
}
.google-button:hover:not(:disabled) { border-color: var(--ink-faint); background: #fff; }
.google-button:disabled { opacity: 0.5; cursor: default; }
.google-mark { width: 18px; height: 18px; flex-shrink: 0; }

.divider-or {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin: 2rem 0;
  color: var(--ink-faint);
  font-size: 0.8rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
.divider-or::before, .divider-or::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--border-subtle);
}

.field-label {
  display: block;
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-muted);
  margin-bottom: 0.6rem;
}

.email-input {
  width: 100%;
  padding: 0.85rem 1.1rem;
  font-family: var(--sans);
  font-size: 1rem;
  color: var(--ink);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  transition: border-color var(--transition);
}
.email-input:focus { outline: none; border-color: var(--ochre); }
.email-input::placeholder { color: var(--ink-faint); }

.field-error { margin-top: 0.6rem; font-size: 0.85rem; color: var(--concede-warm); }

.submit-button {
  width: 100%;
  margin-top: 1.25rem;
  padding: 0.9rem 2rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  letter-spacing: 0.03em;
  color: var(--paper);
  background: var(--ochre);
  border: 1px solid var(--ochre);
  border-radius: 100px;
  cursor: pointer;
  transition: all var(--transition);
}
.submit-button:hover:not(:disabled) { background: var(--ochre-light); border-color: var(--ochre-light); }
.submit-button:disabled { opacity: 0.4; cursor: default; }

.fine-print { margin-top: 1.5rem; font-size: 0.85rem; color: var(--ink-faint); line-height: 1.6; }
.inline-link { color: var(--ochre); border-bottom: 1px solid transparent; transition: border-color var(--transition); }
.inline-link:hover { border-bottom-color: var(--ochre); }

.sent-state { margin-top: 3rem; text-align: center; }
.sent-mark {
  width: 44px; height: 44px;
  margin: 0 auto 1.5rem;
  display: flex; align-items: center; justify-content: center;
  border: 1.5px solid var(--insight-green);
  border-radius: 50%;
  color: var(--insight-green);
}
.text-button {
  margin-top: 1.5rem;
  font-family: var(--sans);
  font-size: 0.85rem;
  color: var(--ink-muted);
  background: none;
  border: none;
  border-bottom: 1px solid var(--border-subtle);
  cursor: pointer;
  padding-bottom: 2px;
}
.text-button:hover { color: var(--ink); border-bottom-color: var(--ink-faint); }

@media (max-width: 480px) {
  .page-container { padding: 5rem 1rem 3rem; }
}
</style>
