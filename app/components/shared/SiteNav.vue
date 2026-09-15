<template>
  <nav
    class="site-nav"
    :class="{
      minimal: isExperience,
      'nav-hidden': shouldHide,
      'nav-visible': !shouldHide
    }"
  >
    <div class="nav-inner">
      <router-link :to="wordmarkDest" class="nav-wordmark">Human Respect</router-link>
      <div class="nav-links">
        <template v-if="!isExperience">
          <router-link to="/about" class="nav-link">About</router-link>
          <router-link v-if="isSignedIn" to="/account" class="nav-link">Account</router-link>
          <router-link v-else-if="hasProgress" to="/account/sign-in" class="nav-link">Save progress</router-link>
          <router-link v-else to="/account/sign-in" class="nav-link">Sign in</router-link>
        </template>
        <ThemeToggle />
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { useJourneyStore } from '@/stores/journey'
import ThemeToggle from '@/components/shared/ThemeToggle.vue'

const route = useRoute()
const journey = useJourneyStore()
const { isSignedIn } = useAuth()
const scrolled = ref(false)
const scrollingUp = ref(false)
const lastScrollY = ref(0)
const isMobile = ref(false)

const isExperience = computed(() => {
  const path = route.path
  return path.startsWith('/experience/') ||
         path.startsWith('/pillar/') ||
         path.startsWith('/practice/')
})

const hasProgress = computed(() => {
  return journey.exp01?.completed || journey.exp02?.completed ||
    (journey.completions && Object.keys(journey.completions).length > 0) ||
    journey.visitor?.totalExperiences > 0
})

const wordmarkDest = computed(() => {
  if (hasProgress.value) return '/your-journey'
  return '/'
})

// The nav, and the theme toggle in it, stay in place. On a phone inside an
// experience it tucks away while reading down and returns on the way up, but
// never at the very top of the page.
const shouldHide = computed(() => {
  if (isExperience.value && isMobile.value) return scrolled.value && !scrollingUp.value
  return false
})

function handleScroll() {
  const currentY = window.scrollY
  scrolled.value = currentY > 120
  scrollingUp.value = currentY < lastScrollY.value && currentY > 60
  lastScrollY.value = currentY
}

function checkMobile() {
  isMobile.value = window.innerWidth <= 680
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', checkMobile, { passive: true })
  checkMobile()
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', checkMobile)
})
</script>

<style scoped>
.site-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: 0.75rem 1.5rem;
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.nav-inner { max-width: 960px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
.nav-wordmark { font-family: var(--serif); font-size: 0.9rem; font-weight: 500; color: var(--ink-muted); text-decoration: none; letter-spacing: 0.02em; transition: color 0.2s ease; }
.nav-wordmark:hover { color: var(--ink); }
.nav-links { display: flex; align-items: center; gap: 1.5rem; }
.nav-link { font-family: var(--sans); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--ink-faint); text-decoration: none; transition: color 0.2s ease; }
.nav-link:hover { color: var(--ink-muted); }

/* A solid ground, so the links never sit on top of the text scrolling
   beneath them. */
.site-nav:not(.minimal) {
  background: var(--paper);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  box-shadow: 0 1px 0 var(--border-subtle);
}

.nav-hidden { opacity: 0; transform: translateY(-100%); pointer-events: none; }
.nav-visible { opacity: 1; transform: translateY(0); pointer-events: auto; }

.site-nav.minimal .nav-wordmark { opacity: 0.6; }
.site-nav.minimal:hover .nav-wordmark { opacity: 1; }

@media (max-width: 680px) {
  .site-nav.minimal { background: var(--paper); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); padding: 0.6rem 1rem; }
  .site-nav.minimal .nav-wordmark { font-size: 0.8rem; color: var(--ink-muted); }
}

@media (max-width: 480px) {
  .site-nav { padding: 0.6rem 1rem; }
  .nav-wordmark { font-size: 0.82rem; }
  .nav-links { gap: 1rem; }
}
</style>

<!-- Unscoped: Vue's :global() swallows the rest of a scoped selector, so
     these dark-screen rules never applied when they lived in the block above. -->
<style>
html body.dark-mode .site-nav.site-nav { background: var(--bg-dark); box-shadow: none; }
body.dark-mode .site-nav .nav-wordmark { color: rgba(240, 235, 227, 0.45); }
body.dark-mode .site-nav .nav-wordmark:hover { color: rgba(240, 235, 227, 0.8); }
body.dark-mode .site-nav .nav-link { color: rgba(240, 235, 227, 0.5); }
body.dark-mode .site-nav .nav-link:hover { color: rgba(240, 235, 227, 0.85); }
@media (min-width: 681px) {
  html body.dark-mode .site-nav.site-nav.minimal { background: transparent; }
}
</style>
