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
      <router-link to="/" class="nav-wordmark">Human Respect</router-link>
      <div v-if="!isExperience" class="nav-links">
        <router-link to="/about" class="nav-link">About</router-link>
        <router-link to="/privacy" class="nav-link">Privacy</router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
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

const isHome = computed(() => route.path === '/')

const shouldHide = computed(() => {
  // Landing page: hidden until scroll
  if (isHome.value && !scrolled.value) return true
  // Experiences on mobile: hidden unless scrolling up
  if (isExperience.value && isMobile.value) return !scrollingUp.value
  // Everything else: always visible
  return false
})

function handleScroll() {
  const currentY = window.scrollY
  scrolled.value = currentY > 200
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

.nav-inner {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-wordmark {
  font-family: var(--serif);
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--ink-muted);
  text-decoration: none;
  letter-spacing: 0.02em;
  transition: color 0.2s ease;
}

.nav-wordmark:hover { color: var(--ink); }

.nav-links { display: flex; gap: 1.5rem; }

.nav-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-faint);
  text-decoration: none;
  transition: color 0.2s ease;
}

.nav-link:hover { color: var(--ink-muted); }

/* Visibility states */
.nav-hidden {
  opacity: 0;
  transform: translateY(-100%);
  pointer-events: none;
}

.nav-visible {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

/* Minimal mode during experiences (desktop) */
.site-nav.minimal {
  opacity: 0.3;
}

.site-nav.minimal:hover {
  opacity: 0.8;
}

/* On mobile during experiences: fully hidden/shown, no faded state */
@media (max-width: 680px) {
  .site-nav.minimal {
    opacity: 1;
    background: rgba(244, 240, 234, 0.92);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    padding: 0.6rem 1rem;
  }

  .site-nav.minimal .nav-wordmark {
    font-size: 0.8rem;
    color: var(--ink-muted);
  }
}

/* Dark mode support */
:global(body.dark-mode) .nav-wordmark {
  color: rgba(240, 235, 227, 0.3);
}

:global(body.dark-mode) .nav-wordmark:hover {
  color: rgba(240, 235, 227, 0.65);
}

:global(body.dark-mode) .nav-link {
  color: rgba(240, 235, 227, 0.2);
}

:global(body.dark-mode) .nav-link:hover {
  color: rgba(240, 235, 227, 0.5);
}

@media (max-width: 680px) {
  :global(body.dark-mode) .site-nav.minimal {
    background: rgba(26, 26, 46, 0.92);
  }
}

@media (max-width: 480px) {
  .site-nav { padding: 0.6rem 1rem; }
  .nav-wordmark { font-size: 0.82rem; }
  .nav-links { gap: 1rem; }
}
</style>
