#!/bin/bash
# Priority 1: Site nav, footer links, Buttondown verification
# Run from humanrespect-app/ root

set -e

echo "🔧 Priority 1 fixes..."

# ══════════════════════════════════════
# 1. SHARED SITE NAV COMPONENT
# Subtle wordmark + links on static pages
# Minimal wordmark-only during experiences
# ══════════════════════════════════════

cat > src/components/shared/SiteNav.vue << 'VUEEOF'
<template>
  <nav class="site-nav" :class="{ minimal: isExperience }">
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
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const isExperience = computed(() => {
  const path = route.path
  return path.startsWith('/experience/') ||
         path.startsWith('/pillar/') ||
         path.startsWith('/practice/')
})
</script>

<style scoped>
.site-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: 1rem 1.5rem;
  transition: opacity 0.3s ease;
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

.nav-wordmark:hover {
  color: var(--ink);
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-faint);
  text-decoration: none;
  transition: color 0.2s ease;
}

.nav-link:hover {
  color: var(--ink-muted);
}

/* Minimal mode during experiences */
.site-nav.minimal {
  opacity: 0.4;
}

.site-nav.minimal:hover {
  opacity: 0.8;
}

/* Dark mode support */
:global(body.dark-mode) .nav-wordmark {
  color: rgba(240, 235, 227, 0.35);
}

:global(body.dark-mode) .nav-wordmark:hover {
  color: rgba(240, 235, 227, 0.7);
}

:global(body.dark-mode) .nav-link {
  color: rgba(240, 235, 227, 0.2);
}

:global(body.dark-mode) .nav-link:hover {
  color: rgba(240, 235, 227, 0.5);
}

@media (max-width: 480px) {
  .site-nav { padding: 0.75rem 1rem; }
  .nav-wordmark { font-size: 0.82rem; }
}
</style>
VUEEOF

echo "  ✓ SiteNav.vue created"

# ══════════════════════════════════════
# 2. ADD SITENAV TO APP.VUE
# ══════════════════════════════════════

cat > src/App.vue << 'VUEEOF'
<template>
  <SiteNav v-if="showNav" />
  <router-view />
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import SiteNav from '@/components/shared/SiteNav.vue'

const route = useRoute()

// Show nav on all pages except the landing page (which has its own hero layout)
const showNav = computed(() => {
  return route.path !== '/'
})
</script>
VUEEOF

echo "  ✓ App.vue updated with SiteNav"

# ══════════════════════════════════════
# 3. ADD TOP PADDING TO ABOUT + PRIVACY
#    so content doesn't hide behind fixed nav
# ══════════════════════════════════════

# About page — reduce top padding since nav now provides spacing
sed -i.bak 's/padding: 6rem 1.5rem 4rem;/padding: 5rem 1.5rem 4rem;/' src/pages/AboutPage.vue
rm -f src/pages/AboutPage.vue.bak

sed -i.bak 's/padding: 4rem 1.25rem 3rem;/padding: 3.5rem 1.25rem 3rem;/' src/pages/AboutPage.vue
rm -f src/pages/AboutPage.vue.bak

# Privacy page — same adjustment
sed -i.bak 's/padding: 6rem 1.5rem 4rem;/padding: 5rem 1.5rem 4rem;/' src/pages/PrivacyPage.vue
rm -f src/pages/PrivacyPage.vue.bak

sed -i.bak 's/padding: 4rem 1.25rem 3rem;/padding: 3.5rem 1.25rem 3rem;/' src/pages/PrivacyPage.vue
rm -f src/pages/PrivacyPage.vue.bak

echo "  ✓ Page padding adjusted for fixed nav"

# ══════════════════════════════════════
# 4. FIX LANDING PAGE FOOTER LINKS
#    Rewrite the footer section to use router-link for both
# ══════════════════════════════════════

# Check if the sed from about-privacy.sh worked. If not, do a targeted fix.
# Rather than fragile sed, let's just verify the LandingPage has router-links in footer.
# We'll grep and fix if needed.

if grep -q 'href="#" class="footer-link">Privacy' src/pages/LandingPage.vue 2>/dev/null; then
  sed -i.bak 's|<a href="#" class="footer-link">Privacy</a>|<router-link to="/privacy" class="footer-link">Privacy</router-link>|' src/pages/LandingPage.vue
  rm -f src/pages/LandingPage.vue.bak
  echo "  ✓ Landing page Privacy link fixed"
else
  echo "  ✓ Landing page Privacy link already correct"
fi

# Also make sure the About link uses router-link
if grep -q 'href="/about" class="footer-link"' src/pages/LandingPage.vue 2>/dev/null; then
  echo "  ✓ Landing page About link already works (href)"
elif grep -q "to=\"/about\"" src/pages/LandingPage.vue 2>/dev/null; then
  echo "  ✓ Landing page About link already correct (router-link)"
fi

# ══════════════════════════════════════
# 5. ADD SITENAV TO LANDING PAGE TOO
#    But only show it after scrolling past the hero
#    Actually — the landing page has its own design, so
#    we hide the global nav there. But we need the footer
#    links to work. Let's add a landing-specific nav that
#    appears on scroll.
# ══════════════════════════════════════

# Actually, the simplest approach: show the global SiteNav on the landing page too,
# but make it appear only after scrolling. Let's update App.vue to always show it,
# and add scroll-based visibility on the landing page.

cat > src/App.vue << 'VUEEOF'
<template>
  <SiteNav />
  <router-view />
</template>

<script setup>
import SiteNav from '@/components/shared/SiteNav.vue'
</script>
VUEEOF

# Update SiteNav to handle the landing page: hidden until scroll
cat > src/components/shared/SiteNav.vue << 'VUEEOF'
<template>
  <nav
    class="site-nav"
    :class="{
      minimal: isExperience,
      'nav-hidden': isHome && !scrolled,
      'nav-scrolled': isHome && scrolled
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

const isExperience = computed(() => {
  const path = route.path
  return path.startsWith('/experience/') ||
         path.startsWith('/pillar/') ||
         path.startsWith('/practice/')
})

const isHome = computed(() => route.path === '/')

function handleScroll() {
  scrolled.value = window.scrollY > 200
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.site-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: 1rem 1.5rem;
  transition: opacity 0.4s ease, transform 0.4s ease;
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

.nav-wordmark:hover {
  color: var(--ink);
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-faint);
  text-decoration: none;
  transition: color 0.2s ease;
}

.nav-link:hover {
  color: var(--ink-muted);
}

/* Hidden on landing page before scroll */
.nav-hidden {
  opacity: 0;
  transform: translateY(-10px);
  pointer-events: none;
}

/* Appears on landing page after scroll */
.nav-scrolled {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

/* Minimal mode during experiences */
.site-nav.minimal {
  opacity: 0.35;
}

.site-nav.minimal:hover {
  opacity: 0.8;
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

@media (max-width: 480px) {
  .site-nav { padding: 0.75rem 1rem; }
  .nav-wordmark { font-size: 0.82rem; }
  .nav-links { gap: 1rem; }
}
</style>
VUEEOF

echo "  ✓ SiteNav handles all contexts (home/static/experience)"

echo ""
echo "✅ Priority 1 fixes applied!"
echo ""
echo "Navigation behavior:"
echo "  Landing page (/) — nav hidden initially, fades in after scrolling 200px"
echo "  About + Privacy — full nav: wordmark + About + Privacy links"
echo "  Experiences — minimal: faded wordmark only (escape hatch to home)"
echo "  Dark mode — all nav elements adapt to light-on-dark colors"
echo ""
echo "BUTTONDOWN VERIFICATION:"
echo "  1. Go to humanrespect.app/experience/flourishing"
echo "  2. Complete Experience 03 to the closing screen"
echo "  3. Enter a test email in the newsletter signup"
echo "  4. Check Buttondown → Subscribers (should appear)"
echo "  5. Check Supabase → newsletter_subscribers table (should also appear)"
echo "  6. If Buttondown subscriber shows but is 'unactivated', check if"
echo "     double opt-in is enabled in Buttondown Settings → Subscribing"
echo ""
echo "Push with: git add . && git commit -m 'nav: site-wide navigation + footer fixes' && git push"
