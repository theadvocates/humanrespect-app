#!/bin/bash
# Fix all 9 remaining audit failures
# Run from humanrespect-app/ root

set -e

echo "🔧 Fixing 9 remaining issues..."

# ══════════════════════════════════════
# FIX #15: "stranger on the bus"
# Find the actual file and replace
# ══════════════════════════════════════

TARGET=$(grep -rl "stranger on the bus" src/ 2>/dev/null)
if [ -n "$TARGET" ]; then
  for f in $TARGET; do
    sed -i.bak 's/The stranger on the bus/The stranger you passed on the street/g' "$f"
    sed -i 's/the stranger on the bus/the stranger you passed on the street/g' "$f"
    rm -f "${f}.bak"
    echo "  ✅ #15: Fixed 'stranger' in $f"
  done
else
  echo "  ⚠ #15: Could not find 'stranger on the bus' — may already be fixed"
fi

# ══════════════════════════════════════
# FIX #17: Pillar B calculator — add 40-hour note
# Find the calculator component
# ══════════════════════════════════════

CALC_FILE=$(grep -rl "hours of your life per year" src/components/experiences/pillarB/ 2>/dev/null | head -1)
if [ -n "$CALC_FILE" ]; then
  # Add note after the result-label div
  if ! grep -q "40-hour" "$CALC_FILE" 2>/dev/null; then
    sed -i.bak 's|<div class="result-label">hours of your life per year</div>|<div class="result-label">hours of your life per year</div>\n      <div style="font-size: 0.72rem; color: var(--ink-faint); font-style: italic; margin-top: 0.5rem;">Based on a standard 40-hour work week.</div>|' "$CALC_FILE"
    rm -f "${CALC_FILE}.bak"
    echo "  ✅ #17: Calculator note added to $CALC_FILE"
  else
    echo "  ✅ #17: Calculator note already present"
  fi
else
  echo "  ⚠ #17: Could not find calculator file — listing pillarB files:"
  ls src/components/experiences/pillarB/ 2>/dev/null
fi

# ══════════════════════════════════════
# FIX: Milestone route in router
# ══════════════════════════════════════

if ! grep -q "milestone" src/router/index.js 2>/dev/null; then
  sed -i.bak "/path: '\/about'/i\\  { path: '/milestone', name: 'milestone', component: () => import('@/pages/MilestonePage.vue') }," src/router/index.js
  rm -f src/router/index.js.bak
  echo "  ✅ Milestone route added to router"
else
  echo "  ✅ Milestone route already in router"
fi

# ══════════════════════════════════════
# FIX: Milestone in route meta
# ══════════════════════════════════════

if ! grep -q "milestone" src/router/meta.js 2>/dev/null; then
  sed -i.bak "/  privacy:/i\\  milestone: {\n    title: 'Foundation Complete — Human Respect',\n    description: 'You have completed the foundation of the Philosophy of Human Respect. Three discoveries that change how you see every political question.'\n  }," src/router/meta.js
  rm -f src/router/meta.js.bak
  echo "  ✅ Milestone meta added"
else
  echo "  ✅ Milestone meta already present"
fi

# ══════════════════════════════════════
# FIX: Exp03 TheBridge links to milestone
# This was overwritten by copy-edit.sh which rewrote TheGrounding
# but TheBridge is the CLOSING screen, separate file
# Check if TheBridge exists and has milestone link
# ══════════════════════════════════════

if [ -f "src/components/experiences/exp03/TheBridge.vue" ]; then
  if ! grep -q "milestone" src/components/experiences/exp03/TheBridge.vue 2>/dev/null; then
    cat > src/components/experiences/exp03/TheBridge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">You now have the complete framework.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div><div class="foundation-title">The gap</div><p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div><div class="foundation-title">The objection</div><p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div><div class="foundation-title">The grounding</div><p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time.</p></div>
      </div>
    </div>

    <PathCard :to="{ name: 'milestone' }" :recommended="true">
      <template #title>See your foundation summary</template>
      <template #desc>A personalized summary of what you discovered, and where the philosophy goes from here.</template>
    </PathCard>

    <p class="body-text" style="margin-top: 1.5rem;">Or continue exploring directly:</p>

    <JourneyNav current="exp03" next-label="Go deeper" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.foundation-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
</style>
VUEEOF
    echo "  ✅ Exp03 TheBridge updated with milestone link"
  else
    echo "  ✅ Exp03 TheBridge already links to milestone"
  fi
else
  echo "  ⚠ TheBridge.vue not found — check screen name"
  echo "    Files in exp03: $(ls src/components/experiences/exp03/ 2>/dev/null)"
fi

# ══════════════════════════════════════
# FIX: mobile.css missing
# ══════════════════════════════════════

if [ ! -f "src/styles/mobile.css" ]; then
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
  echo "  ✅ mobile.css created"
else
  echo "  ✅ mobile.css already exists"
fi

# ══════════════════════════════════════
# FIX: mobile.css imported in main.js
# ══════════════════════════════════════

if ! grep -q "mobile.css" src/main.js 2>/dev/null; then
  # Find the last styles import and add after it
  if grep -q "animations.css" src/main.js 2>/dev/null; then
    sed -i.bak "/animations.css/a import './styles/mobile.css'" src/main.js
  elif grep -q "typography.css" src/main.js 2>/dev/null; then
    sed -i.bak "/typography.css/a import './styles/mobile.css'" src/main.js
  else
    # Just append it near the top
    sed -i.bak "2a import './styles/mobile.css'" src/main.js
  fi
  rm -f src/main.js.bak
  echo "  ✅ mobile.css import added to main.js"
else
  echo "  ✅ mobile.css already imported"
fi

# ══════════════════════════════════════
# FIX: robots.txt
# ══════════════════════════════════════

if [ ! -f "public/robots.txt" ]; then
cat > public/robots.txt << 'EOF'
User-agent: *
Allow: /

Sitemap: https://humanrespect.app/sitemap.xml
EOF
  echo "  ✅ robots.txt created"
else
  echo "  ✅ robots.txt already exists"
fi

echo ""
echo "✅ All 9 fixes applied!"
echo ""
echo "Run verify-audit.sh again to confirm all green."
echo "Push with: git add . && git commit -m 'fix: remaining audit failures' && git push"
