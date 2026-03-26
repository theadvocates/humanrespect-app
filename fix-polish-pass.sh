#!/bin/bash
# Styling polish pass: dark mode, mobile, animations, visual cleanup
# Run from humanrespect-app/ root

set -e

echo "✨ Styling polish pass..."

# ══════════════════════════════════════
# 1. TYPOGRAPHY.CSS — comprehensive dark mode + mobile
# ══════════════════════════════════════

cat > src/styles/typography.css << 'CSSEOF'
/* ── Display type ── */
.display-large {
    font-family: var(--serif);
    font-size: clamp(2rem, 5vw, 3rem);
    line-height: 1.2;
    letter-spacing: -0.02em;
    font-weight: 400;
    color: var(--ink);
}

.display-medium {
    font-family: var(--serif);
    font-size: clamp(1.5rem, 3.5vw, 2rem);
    line-height: 1.3;
    letter-spacing: -0.01em;
    font-weight: 400;
    color: var(--ink);
}

/* ── Body type ── */
.body-text {
    font-size: 1rem;
    line-height: 1.8;
    color: var(--ink-soft);
}

.body-text-large {
    font-size: 1.1rem;
    line-height: 1.8;
    color: var(--ink-soft);
}

.caption {
    font-size: 0.8rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--ink-faint);
}

/* ── Dark mode: boost weight + contrast ── */
.dark-mode .display-large,
.dark-mode .display-medium {
    color: #F0EBE3;
    font-weight: 500;
    -webkit-font-smoothing: antialiased;
}

.dark-mode .display-large em,
.dark-mode .display-medium em {
    color: rgba(240, 235, 227, 0.85);
    font-weight: 400;
}

.dark-mode .body-text,
.dark-mode .body-text-large {
    color: rgba(240, 235, 227, 0.75);
}

.dark-mode .caption {
    color: rgba(240, 235, 227, 0.45);
}

.dark-mode .body-text strong,
.dark-mode .body-text-large strong {
    color: rgba(240, 235, 227, 0.9);
}

/* ── Reduced motion ── */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
CSSEOF

echo "  ✓ Typography updated"

# ══════════════════════════════════════
# 2. TOKENS.CSS — add missing variables + mobile base font
# ══════════════════════════════════════

cat > src/styles/tokens.css << 'CSSEOF'
:root {
    --ink: #1E1C19;
    --ink-soft: #3D3A34;
    --ink-muted: #6E6A62;
    --ink-faint: #A09B92;
    --paper: #F4F0EA;
    --paper-warm: #EDE8E0;
    --paper-deep: #E4DED5;
    --cream: #FAF8F5;
    --bg-dark: #1A1A2E;
    --text-inverse: #F0EBE3;

    --ochre: #9A7B4F;
    --ochre-light: #B8995E;
    --ochre-faint: rgba(154, 123, 79, 0.08);

    --insight-green: #2E5E4E;
    --insight-bg: #E8F0EC;
    --mirror-blue: #3A4A6B;
    --mirror-bg: #E8ECF3;
    --concede-warm: #7A4A2A;
    --concede-bg: #F3ECE5;

    --border-subtle: #E5E0D8;
    --shadow-soft: 0 2px 20px rgba(45, 42, 38, 0.06);
    --shadow-hover: 0 4px 30px rgba(45, 42, 38, 0.12);
    --radius: 8px;

    --serif: 'Cormorant', Georgia, 'Times New Roman', serif;
    --sans: 'Karla', 'Helvetica Neue', Helvetica, Arial, sans-serif;

    --transition: 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* ── Base ── */
html {
    font-size: 18px;
    scroll-behavior: smooth;
}

body {
    font-family: var(--sans);
    color: var(--ink);
    background: var(--paper);
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    overflow-x: hidden;
}

/* Dark mode base */
body.dark-mode {
    background: var(--bg-dark);
}

/* ── Responsive base font ── */
@media (max-width: 680px) {
    html { font-size: 16px; }
}

@media (max-width: 480px) {
    html { font-size: 15px; }
}

/* ── Global reset helpers ── */
*, *::before, *::after {
    box-sizing: border-box;
}

img, svg {
    max-width: 100%;
    height: auto;
}

a {
    color: inherit;
}
CSSEOF

echo "  ✓ Tokens updated"

# ══════════════════════════════════════
# 3. STAGGER ANIMATION — more reliable, better mobile
# ══════════════════════════════════════

cat > src/styles/animations.css << 'CSSEOF'
/* ── Screen transitions ── */
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.4s ease, transform 0.4s ease;
}

.fade-enter-from {
    opacity: 0;
    transform: translateY(12px);
}

.fade-leave-to {
    opacity: 0;
    transform: translateY(-8px);
}

/* ── Stagger reveal ── */
.stagger > * {
    opacity: 0;
    transform: translateY(16px);
    transition: opacity 0.5s ease, transform 0.5s ease;
}

.stagger.animate > * {
    opacity: 1;
    transform: translateY(0);
}

.stagger.animate > *:nth-child(1) { transition-delay: 0.05s; }
.stagger.animate > *:nth-child(2) { transition-delay: 0.15s; }
.stagger.animate > *:nth-child(3) { transition-delay: 0.25s; }
.stagger.animate > *:nth-child(4) { transition-delay: 0.35s; }
.stagger.animate > *:nth-child(5) { transition-delay: 0.45s; }
.stagger.animate > *:nth-child(6) { transition-delay: 0.55s; }
.stagger.animate > *:nth-child(7) { transition-delay: 0.65s; }
.stagger.animate > *:nth-child(8) { transition-delay: 0.75s; }
.stagger.animate > *:nth-child(9) { transition-delay: 0.85s; }
.stagger.animate > *:nth-child(10) { transition-delay: 0.95s; }
/* Cap at 10 — after this, everything appears at 0.95s */
.stagger.animate > *:nth-child(n+11) { transition-delay: 0.95s; }

/* ── Mobile: reduce stagger delay for snappier feel ── */
@media (max-width: 480px) {
    .stagger > * {
        transform: translateY(10px);
        transition-duration: 0.35s;
    }
    .stagger.animate > *:nth-child(1) { transition-delay: 0.03s; }
    .stagger.animate > *:nth-child(2) { transition-delay: 0.1s; }
    .stagger.animate > *:nth-child(3) { transition-delay: 0.17s; }
    .stagger.animate > *:nth-child(4) { transition-delay: 0.24s; }
    .stagger.animate > *:nth-child(5) { transition-delay: 0.31s; }
    .stagger.animate > *:nth-child(6) { transition-delay: 0.38s; }
    .stagger.animate > *:nth-child(n+7) { transition-delay: 0.38s; }
}

/* ── Reduced motion ── */
@media (prefers-reduced-motion: reduce) {
    .stagger > * {
        opacity: 1;
        transform: none;
        transition: none;
    }
    .fade-enter-active,
    .fade-leave-active {
        transition: none;
    }
}
CSSEOF

echo "  ✓ Animations updated"

# ══════════════════════════════════════
# 4. GLOBAL MOBILE FIXES — overflow, padding, tap targets
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
    [role="button"] {
        min-height: 44px;
    }
}

/* ── Content block mobile adjustments ── */
@media (max-width: 480px) {
    .content-block {
        padding: 1.1rem 1.25rem;
        margin: 1.25rem 0;
    }

    .screen-inner {
        padding: 0 0.25rem;
    }

    .display-large {
        font-size: clamp(1.8rem, 5vw, 2.5rem);
    }

    .display-medium {
        font-size: clamp(1.35rem, 3.5vw, 1.75rem);
    }

    .body-text-large {
        font-size: 1rem;
    }
}

/* ── Closing question blocks on mobile ── */
@media (max-width: 480px) {
    .closing-question {
        font-size: 1.2rem !important;
        padding: 1.5rem 1rem !important;
    }

    .closing-question-block {
        margin: 1.5rem 0 !important;
        padding: 1.5rem 0.5rem !important;
    }
}

/* ── Opening screen mobile ── */
@media (max-width: 480px) {
    .opening {
        padding: 1.5rem 0;
        min-height: auto;
    }

    .opening .subtitle {
        font-size: 0.9rem;
    }

    .opening .begin-btn {
        font-size: 0.95rem;
        padding: 0.75rem 1.75rem;
    }
}

/* ── Newsletter form mobile ── */
@media (max-width: 480px) {
    .newsletter-block {
        padding: 1.25rem;
    }

    .newsletter-headline {
        font-size: 0.95rem;
    }

    .input-row {
        flex-direction: column;
    }

    .submit-btn {
        width: 100%;
    }
}

/* ── Foundation summary on mobile ── */
@media (max-width: 480px) {
    .foundation-summary {
        gap: 1rem;
    }

    .foundation-item {
        gap: 0.75rem;
    }
}

/* ── Safe area for notched phones ── */
@supports (padding: env(safe-area-inset-bottom)) {
    .site-nav {
        padding-top: max(1rem, env(safe-area-inset-top));
        padding-left: max(1.5rem, env(safe-area-inset-left));
        padding-right: max(1.5rem, env(safe-area-inset-right));
    }

    .page-footer {
        padding-bottom: max(3rem, env(safe-area-inset-bottom));
    }
}
CSSEOF

echo "  ✓ Mobile styles created"

# ══════════════════════════════════════
# 5. IMPORT the new CSS files in main.js
#    (ensure animations.css and mobile.css are loaded)
# ══════════════════════════════════════

# Check current main.js imports
if grep -q "animations.css" src/main.js 2>/dev/null; then
    echo "  ✓ animations.css already imported"
else
    sed -i.bak "/import.*tokens.css/a import './styles/animations.css'" src/main.js
    rm -f src/main.js.bak
    echo "  ✓ animations.css import added"
fi

if grep -q "mobile.css" src/main.js 2>/dev/null; then
    echo "  ✓ mobile.css already imported"
else
    sed -i.bak "/import.*animations.css/a import './styles/mobile.css'" src/main.js
    rm -f src/main.js.bak
    echo "  ✓ mobile.css import added"
fi

# ══════════════════════════════════════
# 6. DARK MODE CLEANUP — ensure every experience
#    removes dark-mode class on unmount
# ══════════════════════════════════════

# Create a shared composable for dark mode management
cat > src/composables/useDarkMode.js << 'JSEOF'
import { onMounted, onUnmounted } from 'vue'

export function useDarkMode() {
    onMounted(() => {
        document.body.classList.add('dark-mode')
    })

    onUnmounted(() => {
        document.body.classList.remove('dark-mode')
    })
}
JSEOF

echo "  ✓ useDarkMode composable created"

# ══════════════════════════════════════
# 7. CONTENT BLOCK COMPONENT — standardize styling
# ══════════════════════════════════════

cat > src/components/shared/ContentBlock.vue << 'VUEEOF'
<template>
  <div class="content-block" :class="variant">
    <p v-if="label" class="content-label">{{ label }}</p>
    <slot />
  </div>
</template>

<script setup>
defineProps({
  variant: {
    type: String,
    default: 'principle',
    validator: (v) => ['principle', 'insight', 'mirror', 'concession'].includes(v)
  },
  label: {
    type: String,
    default: null
  }
})
</script>

<style scoped>
.content-block {
  padding: 1.5rem 1.75rem;
  margin: 1.5rem 0;
  border-radius: 0 var(--radius) var(--radius) 0;
  transition: background 0.3s ease;
}

.content-block :deep(p) {
  margin: 0;
  line-height: 1.8;
}

.content-block :deep(p + p) {
  margin-top: 0.75rem;
}

.content-label {
  font-size: 0.65rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  font-weight: 600;
  margin-bottom: 0.65rem;
}

/* ── Variants ── */
.principle {
  background: var(--ochre-faint);
  border-left: 3px solid var(--ochre);
}

.principle :deep(p) {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  font-style: italic;
}

.principle .content-label {
  color: var(--ochre);
  font-style: normal;
}

.insight {
  background: var(--insight-bg);
  border-left: 3px solid var(--insight-green);
}

.insight :deep(p) {
  color: var(--insight-green);
}

.insight .content-label {
  color: var(--insight-green);
}

.mirror {
  background: var(--mirror-bg);
  border-left: 3px solid var(--mirror-blue);
}

.mirror :deep(p) {
  color: var(--mirror-blue);
}

.mirror .content-label {
  color: var(--mirror-blue);
}

.concession {
  background: var(--concede-bg);
  border-left: 3px solid var(--concede-warm);
}

.concession :deep(p) {
  color: var(--concede-warm);
}

.concession .content-label {
  color: var(--concede-warm);
}

/* ── Mobile ── */
@media (max-width: 480px) {
  .content-block {
    padding: 1.1rem 1.25rem;
    margin: 1.25rem 0;
  }

  .principle :deep(p) {
    font-size: 1rem;
  }
}
</style>
VUEEOF

echo "  ✓ ContentBlock standardized"

# ══════════════════════════════════════
# 8. DIVIDER COMPONENT — ensure consistent styling
# ══════════════════════════════════════

cat > src/components/shared/Divider.vue << 'VUEEOF'
<template>
  <div class="divider" :class="{ centered }">
    <div class="divider-line"></div>
  </div>
</template>

<script setup>
defineProps({
  centered: { type: Boolean, default: false }
})
</script>

<style scoped>
.divider {
  margin: 1.5rem 0;
}

.divider.centered {
  display: flex;
  justify-content: center;
}

.divider-line {
  width: 40px;
  height: 2px;
  background: var(--ochre);
  border-radius: 1px;
  opacity: 0.6;
}

/* Dark mode */
:global(body.dark-mode) .divider-line {
  background: var(--ochre-light);
  opacity: 0.4;
}
</style>
VUEEOF

echo "  ✓ Divider standardized"

# ══════════════════════════════════════
# 9. STEP DOTS — ensure consistent + dark mode
# ══════════════════════════════════════

cat > src/components/shared/StepDots.vue << 'VUEEOF'
<template>
  <div class="step-dots">
    <div
      v-for="n in total"
      :key="n"
      class="dot"
      :class="{ active: n === current, past: n < current }"
    />
  </div>
</template>

<script setup>
defineProps({
  current: { type: Number, required: true },
  total: { type: Number, required: true }
})
</script>

<style scoped>
.step-dots {
  display: flex;
  gap: 6px;
  margin-bottom: 2rem;
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--border-subtle);
  transition: all 0.3s ease;
}

.dot.active {
  background: var(--ochre);
  transform: scale(1.15);
}

.dot.past {
  background: var(--ochre);
  opacity: 0.4;
}

/* Dark mode (for opening screens) */
:global(body.dark-mode) .dot {
  background: rgba(240, 235, 227, 0.15);
}

:global(body.dark-mode) .dot.active {
  background: var(--ochre-light);
}

:global(body.dark-mode) .dot.past {
  background: var(--ochre-light);
  opacity: 0.4;
}
</style>
VUEEOF

echo "  ✓ StepDots standardized"

# ══════════════════════════════════════
# 10. GOOGLE FONTS — add display=swap to prevent FOIT
# ══════════════════════════════════════

# Fix the font import in index.html
if [ -f "index.html" ]; then
  sed -i.bak 's|fonts.googleapis.com/css2?family=Cormorant|fonts.googleapis.com/css2?family=Cormorant\&display=swap|' index.html
  # Make sure we don't double-add display=swap
  sed -i 's|display=swap\&display=swap|display=swap|g' index.html
  sed -i 's|\&display=swap\&display=swap|\&display=swap|g' index.html
  rm -f index.html.bak
  echo "  ✓ Google Fonts display=swap added"
fi

# ══════════════════════════════════════
# 11. SPA REDIRECTS for Cloudflare Pages
# ══════════════════════════════════════

cat > public/_redirects << 'EOF'
/* /index.html 200
EOF

echo "  ✓ _redirects file created for SPA routing"

# ══════════════════════════════════════
# 12. ROBOTS.TXT
# ══════════════════════════════════════

cat > public/robots.txt << 'EOF'
User-agent: *
Allow: /

Sitemap: https://humanrespect.app/sitemap.xml
EOF

echo "  ✓ robots.txt created"

echo ""
echo "✅ Polish pass complete!"
echo ""
echo "What changed:"
echo "  • Typography: dark mode weight 500, proper text colors, italic handling"
echo "  • Tokens: responsive base font (18→16→15px), overflow-x hidden"
echo "  • Animations: mobile-optimized stagger (faster delays, smaller translateY)"
echo "  • Mobile: tap targets 44px min, safe-area insets, content block sizing"
echo "  • useDarkMode composable: shared mount/unmount dark-mode class management"
echo "  • ContentBlock: standardized padding, mobile sizes, deep selector for p"
echo "  • Divider: dark mode ochre-light at reduced opacity"
echo "  • StepDots: dark mode support"
echo "  • Google Fonts: display=swap to prevent invisible text flash"
echo "  • _redirects: SPA routing for direct URL access"
echo "  • robots.txt: allow all crawlers"
echo ""
echo "Push with: git add . && git commit -m 'polish: dark mode, mobile, animations, perf' && git push"
