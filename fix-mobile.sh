#!/bin/bash
# Mobile fixes from real device testing
# Run from humanrespect-app/ root

set -e

echo "📱 Mobile fixes..."

# ══════════════════════════════════════
# FIX 1: Nav bar interferes with reading on mobile
# Solution: hide nav entirely during experiences on mobile,
# show only on scroll-up (like iOS Safari address bar behavior)
# On desktop: keep current behavior (faded wordmark)
# ══════════════════════════════════════

cat > src/components/shared/SiteNav.vue << 'VUEEOF'
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
VUEEOF

echo "  ✓ Fix 1: Nav hidden during scroll on mobile, shows on scroll-up"

# ══════════════════════════════════════
# FIX 2: Scroll not resetting between screens
# The scrollTo in each page's advance() function may not
# be working on mobile. Force it more aggressively.
# Also update the router's scrollBehavior.
# ══════════════════════════════════════

# Fix the useScreenNav composable if it exists
SCREENNAV=$(find src -name "useScreenNav*" 2>/dev/null | head -1)
if [ -n "$SCREENNAV" ]; then
  # Check if it has scrollTo
  if grep -q "scrollTo" "$SCREENNAV"; then
    # Replace smooth scroll with instant scroll + small delay
    sed -i '' 's/window.scrollTo({ top: 0, behavior: .smooth. })/window.scrollTo(0, 0)/g' "$SCREENNAV"
    echo "  ✓ Fix 2a: useScreenNav scroll reset fixed"
  fi
fi

# Also fix in all page-level components that have scrollTo
for f in src/pages/Experience01.vue src/pages/Experience02.vue src/pages/Experience03.vue \
         src/pages/PillarA.vue src/pages/PillarB.vue src/pages/PillarC.vue \
         src/pages/PillarD.vue src/pages/PillarE.vue \
         src/pages/Practice01.vue src/pages/Practice02.vue src/pages/Practice03.vue \
         src/pages/Practice04.vue src/pages/Practice05.vue; do
  if [ -f "$f" ]; then
    sed -i '' "s/window.scrollTo({ top: 0, behavior: 'smooth' })/window.scrollTo(0, 0)/g" "$f"
  fi
done

echo "  ✓ Fix 2b: All page scrollTo calls use instant reset"

# Also ensure router scrollBehavior works
sed -i '' "s/scrollBehavior() { return { top: 0 } }/scrollBehavior() { return { top: 0, behavior: 'instant' } }/g" src/router/index.js

echo "  ✓ Fix 2c: Router scrollBehavior set to instant"

# ══════════════════════════════════════
# FIX 3: Font size and paragraph spacing on mobile
# Update mobile.css with proper mobile typography
# ══════════════════════════════════════

cat > src/styles/mobile.css << 'CSSEOF'
/* ── Prevent horizontal overflow ── */
.screen-inner,
.opening {
    overflow-wrap: break-word;
    word-wrap: break-word;
}

/* ── Tap target sizing ── */
@media (max-width: 680px) {
    button,
    .path-card,
    .choice-card,
    .verdict-card,
    .item-card,
    [role="button"] {
        min-height: 44px;
    }
}

/* ── Mobile typography ── */
@media (max-width: 680px) {
    .display-large {
        font-size: clamp(1.8rem, 5vw, 2.5rem) !important;
        line-height: 1.25 !important;
    }

    .display-medium {
        font-size: clamp(1.3rem, 3.5vw, 1.7rem) !important;
        line-height: 1.35 !important;
    }

    .body-text,
    .body-text-large {
        font-size: 0.95rem !important;
        line-height: 1.75 !important;
    }

    .body-text + .body-text,
    .body-text-large + .body-text,
    .body-text + .body-text-large,
    .body-text-large + .body-text-large {
        margin-top: 0.85rem !important;
    }

    .caption {
        font-size: 0.72rem !important;
    }
}

/* ── Experience container mobile ── */
@media (max-width: 680px) {
    .exp-container {
        padding: 3rem 1.25rem !important;
    }
}

@media (max-width: 480px) {
    .exp-container {
        padding: 2.5rem 1rem !important;
    }
}

/* ── Content blocks on mobile ── */
@media (max-width: 680px) {
    .content-block {
        padding: 1.1rem 1.25rem !important;
        margin: 1.25rem 0 !important;
    }

    .content-block p {
        font-size: 0.92rem !important;
    }
}

/* ── Path cards on mobile ── */
@media (max-width: 480px) {
    .path-card {
        padding: 1rem 1.1rem !important;
    }

    .path-card-title {
        font-size: 0.95rem !important;
    }

    .path-card-desc {
        font-size: 0.78rem !important;
    }
}

/* ── Opening screen mobile ── */
@media (max-width: 480px) {
    .opening {
        padding: 1.5rem 0 !important;
        min-height: auto !important;
    }

    .opening .subtitle {
        font-size: 0.88rem !important;
        line-height: 1.7 !important;
    }

    .opening .begin-btn {
        font-size: 0.92rem !important;
        padding: 0.75rem 1.75rem !important;
    }

    .overline {
        font-size: 0.68rem !important;
    }
}

/* ── Closing question blocks on mobile ── */
@media (max-width: 480px) {
    .closing-question {
        font-size: 1.15rem !important;
        padding: 1.25rem 0.75rem !important;
    }

    .closing-question-block {
        margin: 1.5rem 0 !important;
        padding: 1.5rem 0.5rem !important;
    }
}

/* ── Newsletter form mobile ── */
@media (max-width: 480px) {
    .newsletter-block {
        padding: 1.25rem !important;
    }

    .newsletter-headline {
        font-size: 0.95rem !important;
    }

    .input-row {
        flex-direction: column !important;
    }

    .submit-btn {
        width: 100% !important;
    }
}

/* ── Scenario boxes on mobile ── */
@media (max-width: 480px) {
    .scenario-box {
        padding: 1.1rem 1.2rem !important;
    }

    .scenario-box p {
        font-size: 0.9rem !important;
    }
}

/* ── Step dots spacing ── */
@media (max-width: 480px) {
    .step-dots {
        margin-bottom: 1.5rem !important;
    }
}

/* ── Journey nav spacing ── */
@media (max-width: 480px) {
    .journey-nav {
        margin-top: 2rem !important;
    }
}

/* ── Foundation summary ── */
@media (max-width: 480px) {
    .foundation-summary {
        gap: 1rem !important;
    }

    .foundation-item {
        gap: 0.75rem !important;
    }

    .foundation-desc {
        font-size: 0.82rem !important;
    }
}

/* ── Divider spacing ── */
@media (max-width: 480px) {
    .divider {
        margin: 1rem 0 !important;
    }
}

/* ── Safe area for notched phones ── */
@supports (padding: env(safe-area-inset-bottom)) {
    .site-nav {
        padding-top: max(0.6rem, env(safe-area-inset-top));
        padding-left: max(1rem, env(safe-area-inset-left));
        padding-right: max(1rem, env(safe-area-inset-right));
    }

    .page-footer {
        padding-bottom: max(2rem, env(safe-area-inset-bottom));
    }
}

/* ── Reduce motion on mobile ── */
@media (max-width: 480px) {
    .stagger > * {
        transform: translateY(8px) !important;
        transition-duration: 0.3s !important;
    }
    .stagger.animate > *:nth-child(1) { transition-delay: 0.02s !important; }
    .stagger.animate > *:nth-child(2) { transition-delay: 0.08s !important; }
    .stagger.animate > *:nth-child(3) { transition-delay: 0.14s !important; }
    .stagger.animate > *:nth-child(4) { transition-delay: 0.2s !important; }
    .stagger.animate > *:nth-child(5) { transition-delay: 0.26s !important; }
    .stagger.animate > *:nth-child(n+6) { transition-delay: 0.3s !important; }
}
CSSEOF

echo "  ✓ Fix 3: Mobile typography, spacing, and layout optimized"

# ══════════════════════════════════════
# FIX 4: Pillar B closing screen missing JourneyNav
# The newsletter-integration.sh should have added it,
# but let's check and fix
# ══════════════════════════════════════

PILLARB_CLOSE=$(find src/components/experiences/pillarB -name "*.vue" | xargs grep -l "question that remains" 2>/dev/null | head -1)
if [ -z "$PILLARB_CLOSE" ]; then
  # Try the last screen
  PILLARB_CLOSE=$(ls src/components/experiences/pillarB/*.vue 2>/dev/null | tail -1)
fi

echo "  Pillar B closing file: $PILLARB_CLOSE"

if [ -n "$PILLARB_CLOSE" ]; then
  if ! grep -q "JourneyNav" "$PILLARB_CLOSE" 2>/dev/null; then
    echo "  ⚠ JourneyNav missing from Pillar B closing — rewriting"
    cat > "$PILLARB_CLOSE" << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />
    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>
    <ContentBlock variant="principle"><p>...then a political system that operates by taking people's time without their individual consent is consuming the very substance of human life.</p></ContentBlock>
    <p class="body-text">This doesn't make the people in government evil. It means the <em>system</em> is misaligned with what human beings actually need to flourish.</p>
    <div class="closing-question-block"><p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p></div>
    <ContentBlock variant="insight"><p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks fundamentally different.</p></ContentBlock>
    <NewsletterSignup variant="minimal" source="pillarB_closing" headline="One question per week, applied to the real world." description="A short email exploring how the force/persuasion question plays out in actual situations." button-text="Subscribe" />
    <JourneyNav current="pillarB" />
    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question-block { margin: 2.5rem 0; text-align: center; padding: 2rem 1.5rem; }
.closing-question { font-family: var(--serif); font-size: clamp(1.3rem, 3vw, 1.7rem); line-height: 1.45; color: var(--ink); font-style: italic; font-weight: 400; }
</style>
VUEEOF
    echo "  ✓ Fix 4: Pillar B closing now has JourneyNav"
  else
    echo "  ✅ Fix 4: Pillar B closing already has JourneyNav"
  fi
else
  echo "  ⚠ Could not find Pillar B closing file"
  echo "  Files: $(ls src/components/experiences/pillarB/ 2>/dev/null)"
fi

echo ""
echo "✅ All 4 mobile fixes applied!"
echo ""
echo "Changes:"
echo "  1. Nav: hidden during scroll on mobile, appears on scroll-up"
echo "     On desktop: unchanged (faded wordmark)"
echo "  2. Scroll: instant reset (not smooth) on screen transitions"
echo "     Router scrollBehavior also set to instant"
echo "  3. Mobile CSS: font sizes, spacing, content blocks, path cards,"
echo "     newsletter forms, scenario boxes all optimized for small screens"
echo "  4. Pillar B: closing screen now has JourneyNav for navigation"
echo ""
echo "Push with: git add . && git commit -m 'mobile: nav, scroll, typography, pillarB nav' && git push"
