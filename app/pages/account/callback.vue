<template>
  <div class="page">
    <div class="callback-inner">
      <template v-if="error">
        <h1 class="display-medium">That link didn't work.</h1>
        <p class="body-text">{{ error }}</p>
        <router-link to="/account/sign-in" class="retry-link">Try signing in again →</router-link>
      </template>
      <template v-else>
        <div class="pulse-mark"/>
        <p class="body-text">Signing you in…</p>
      </template>
    </div>
  </div>
</template>

<script setup>
definePageMeta({ name: 'auth-callback' })

useHead({
  title: 'Signing in — Human Respect',
  meta: [{ name: 'robots', content: 'noindex' }]
})

const { user } = useAuth()
const error = ref('')

onMounted(async () => {
  // Supabase parses the URL fragment and fires SIGNED_IN, which the auth
  // plugin listens for. Wait for the session rather than racing it.
  const deadline = Date.now() + 8000
  while (!user.value && Date.now() < deadline) {
    await new Promise((r) => setTimeout(r, 150))
  }

  if (user.value) {
    await navigateTo('/account', { replace: true })
  } else {
    const params = new URLSearchParams(window.location.hash.slice(1))
    error.value =
      params.get('error_description') ||
      'The sign-in link may have expired or already been used.'
  }
})
</script>

<style scoped>
.page { min-height: 100vh; background: var(--paper); display: flex; align-items: center; justify-content: center; }
.callback-inner { text-align: center; max-width: 420px; padding: 2rem; }
.pulse-mark {
  width: 32px; height: 1px;
  background: var(--ochre);
  margin: 0 auto 2rem;
  animation: pulseWidth 1.4s ease-in-out infinite;
}
@keyframes pulseWidth {
  0%, 100% { opacity: 0.3; transform: scaleX(0.6); }
  50%      { opacity: 1;   transform: scaleX(1); }
}
.retry-link {
  display: inline-block;
  margin-top: 2rem;
  font-family: var(--serif);
  font-size: 1rem;
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color var(--transition);
}
.retry-link:hover { border-bottom-color: var(--ochre); }
</style>
