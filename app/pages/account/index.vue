<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Your account</p>
      <h1 class="display-large">{{ displayName || 'Your account' }}</h1>
      <Divider />

      <div class="account-row">
        <div>
          <div class="row-label">Signed in as</div>
          <div class="row-value">{{ user?.email }}</div>
        </div>
        <button class="text-button" @click="handleSignOut">Sign out</button>
      </div>

      <div class="account-row">
        <div class="grow">
          <label class="row-label" for="name">Name on your certificate</label>
          <input
            id="name"
            v-model="name"
            type="text"
            class="name-input"
            placeholder="How your name should appear"
            @blur="saveName"
          >
          <p v-if="nameSaved" class="saved-note">Saved.</p>
        </div>
      </div>

      <div class="section">
        <h2 class="section-heading">Your progress</h2>
        <p class="section-note">
          {{ journey.completionCount }} of {{ TOTAL_EXPERIENCES }} experiences completed.
        </p>
        <div class="progress-track">
          <div class="progress-fill" :style="{ width: progressPct + '%' }"/>
        </div>
        <router-link to="/your-journey" class="journey-link">See your journey →</router-link>
      </div>

      <div class="section">
        <h2 class="section-heading">Certificates</h2>
        <p v-if="!foundationComplete" class="section-note">
          Complete the three foundation experiences to earn your first certificate.
        </p>
        <template v-else>
          <p class="section-note">You have completed the foundation.</p>
          <button class="submit-button" :disabled="issuing" @click="claimCertificate">
            {{ issuing ? 'Issuing…' : 'Issue my certificate' }}
          </button>
          <p v-if="certError" class="field-error">{{ certError }}</p>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'
import { getSupabase } from '@/lib/supabase'

definePageMeta({ name: 'account' })

useHead({
  title: 'Your account — Human Respect',
  meta: [{ name: 'robots', content: 'noindex' }]
})

const TOTAL_EXPERIENCES = 15

const { user, displayName, isSignedIn, signOut } = useAuth()
const journey = useJourneyStore()

const name = ref('')
const nameSaved = ref(false)
const issuing = ref(false)
const certError = ref('')

const progressPct = computed(() =>
  Math.round((journey.completionCount / TOTAL_EXPERIENCES) * 100)
)
const foundationComplete = computed(() => journey.foundationComplete)

// Client-only: the session is restored in the browser, so during SSR this
// would always read as signed-out.
watchEffect(() => {
  if (!import.meta.client) return
  if (!isSignedIn.value) navigateTo('/account/sign-in')
  else if (!name.value) name.value = displayName.value || ''
})

async function saveName() {
  const supabase = getSupabase()
  if (!supabase || !user.value) return
  const trimmed = name.value.trim()
  if (!trimmed) return

  const { error } = await supabase
    .from('profiles')
    .update({ display_name: trimmed })
    .eq('id', user.value.id)

  if (!error) {
    nameSaved.value = true
    setTimeout(() => { nameSaved.value = false }, 2000)
  }
}

async function claimCertificate() {
  const supabase = getSupabase()
  if (!supabase) return

  issuing.value = true
  certError.value = ''
  const { data, error } = await supabase.rpc('issue_certificate', { p_tier: 'foundation' })
  issuing.value = false

  if (error) {
    certError.value = error.message
    return
  }
  if (data?.public_code) await navigateTo(`/certificate/${data.public_code}`)
}

async function handleSignOut() {
  await signOut()
  await navigateTo('/')
}
</script>

<style scoped>
.page { min-height: 100vh; background: var(--paper); }
.page-container { max-width: 620px; margin: 0 auto; padding: 6rem 1.5rem 5rem; }

.account-row {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1.5rem;
  padding: 1.25rem 0;
  border-bottom: 1px solid var(--border-subtle);
}
.grow { flex: 1; }
.row-label {
  display: block;
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-muted);
  margin-bottom: 0.4rem;
}
.row-value { font-family: var(--sans); font-size: 0.95rem; color: var(--ink); }

.name-input {
  width: 100%;
  padding: 0.6rem 0;
  font-family: var(--serif);
  font-size: 1.15rem;
  color: var(--ink);
  background: transparent;
  border: none;
  border-bottom: 1px solid var(--border-subtle);
  transition: border-color var(--transition);
}
.name-input:focus { outline: none; border-bottom-color: var(--ochre); }
.saved-note { margin-top: 0.4rem; font-size: 0.78rem; color: var(--insight-green); }

.section { margin-top: 3rem; }
.section-heading {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.5rem;
}
.section-note { font-family: var(--sans); font-size: 0.9rem; color: var(--ink-muted); margin-bottom: 1rem; }

.progress-track { height: 2px; background: var(--paper-deep); border-radius: 2px; overflow: hidden; }
.progress-fill { height: 100%; background: var(--ochre); transition: width 0.6s ease; }

.journey-link {
  display: inline-block;
  margin-top: 1.25rem;
  font-family: var(--serif);
  font-size: 1rem;
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color var(--transition);
}
.journey-link:hover { border-bottom-color: var(--ochre); }

.submit-button {
  padding: 0.8rem 1.8rem;
  font-family: var(--serif);
  font-size: 1rem;
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

.text-button {
  font-family: var(--sans);
  font-size: 0.85rem;
  color: var(--ink-muted);
  background: none;
  border: none;
  border-bottom: 1px solid var(--border-subtle);
  cursor: pointer;
  padding-bottom: 2px;
  white-space: nowrap;
}
.text-button:hover { color: var(--ink); border-bottom-color: var(--ink-faint); }

.field-error { margin-top: 0.75rem; font-size: 0.85rem; color: var(--concede-warm); }

@media (max-width: 480px) {
  .page-container { padding: 5rem 1rem 3rem; }
}
</style>
