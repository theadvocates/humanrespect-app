<template>
  <SiteNav />
  <router-view />
</template>

<script setup>
import SiteNav from '@/components/shared/SiteNav.vue'

// Google Search Console verification, when the meta-tag method is used.
// Records where people were when they left — the signal that shows which
// screen loses them, which nothing in the app captured before.
const { trackAbandonOnExit, capture } = useAnalytics()
const route = useRoute()

onMounted(() => {
  trackAbandonOnExit()

  // Arrivals from the share loop. Without this the ?ref=share links on shared
  // URLs would be decoration — the loop has to be countable to be judged.
  if (route.query.ref) {
    capture('arrived_from_share', {
      ref: String(route.query.ref).slice(0, 32),
      landed_on: route.path,
      referrer: document.referrer || null
    })
  }
})

const { googleSiteVerification } = useRuntimeConfig().public
if (googleSiteVerification) {
  useHead({ meta: [{ name: 'google-site-verification', content: googleSiteVerification }] })
}
</script>
