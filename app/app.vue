<template>
  <SiteNav />
  <router-view />
</template>

<script setup>
import SiteNav from '@/components/shared/SiteNav.vue'

// Google Search Console verification, when the meta-tag method is used.
const { googleSiteVerification } = useRuntimeConfig().public
if (googleSiteVerification) {
  useHead({ meta: [{ name: 'google-site-verification', content: googleSiteVerification }] })
}
</script>
