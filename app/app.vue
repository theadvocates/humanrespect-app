<template>
  <SiteNav />
  <router-view />
</template>

<script setup>
import SiteNav from '@/components/shared/SiteNav.vue'

// Google Search Console verification, when the meta-tag method is used.
// Records where people were when they left — the signal that shows which
// screen loses them, which nothing in the app captured before.
const { trackAbandonOnExit } = useAnalytics()
onMounted(() => trackAbandonOnExit())

const { googleSiteVerification } = useRuntimeConfig().public
if (googleSiteVerification) {
  useHead({ meta: [{ name: 'google-site-verification', content: googleSiteVerification }] })
}
</script>
