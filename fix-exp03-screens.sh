#!/bin/bash
# Fix Exp03 (Flourishing) Opening + TheBridge for new sequence
# Now the SECOND foundation experience (after new Exp01, before Exp02 Objection)
# Run from humanrespect-app/ root

set -e

echo "🔧 Fixing Exp03 Opening + TheBridge..."

# ══════════════════════════════════════
# SCREEN 0: OPENING — revised for new sequence
# Visitor has completed new Exp01 (relationship-based)
# They discovered they already choose persuasion over force
# Now: ground that discovery in empirical evidence from their own life
# ══════════════════════════════════════

cat > src/components/experiences/exp03/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 02 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">What<br><em>flourishing</em><br>actually means.</h1>
    <Divider :centered="true" />
    <p class="subtitle">You discovered that you already choose persuasion over force in your own life. Now let's look at why. Your own experience holds the evidence.</p>
    <button class="begin-btn" @click="$emit('advance')">
      Continue <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.opening { text-align: center; padding: 2rem 0; }
.overline {
  font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--ochre-light); margin-bottom: 2rem; display: block;
}
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle {
  font-family: var(--sans); font-size: 1rem; line-height: 1.8;
  color: rgba(240,235,227,0.65); max-width: 500px; margin: 0 auto;
}
.begin-btn {
  display: inline-block; margin-top: 3rem; padding: 1rem 3rem;
  background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light);
  border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500;
  cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em;
  -webkit-tap-highlight-color: transparent;
}
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening revised"

# ══════════════════════════════════════
# SCREEN 6: THE BRIDGE — revised for new sequence
# This is NO LONGER the foundation summary.
# It bridges from flourishing → objection (Exp02, now third)
# ══════════════════════════════════════

cat > src/components/experiences/exp03/TheBridge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you've established</p>
    <h2 class="display-medium">Two discoveries, from your own reasoning.</h2>
    <Divider />

    <div class="discoveries">
      <div class="discovery">
        <span class="discovery-number">01</span>
        <div>
          <div class="discovery-title">The method</div>
          <p class="discovery-desc">You already choose persuasion over force in your closest relationships — because you know what force does to people. You learned this from a lifetime of experience.</p>
        </div>
      </div>
      <div class="discovery">
        <span class="discovery-number">02</span>
        <div>
          <div class="discovery-title">The evidence</div>
          <p class="discovery-desc">The best periods of your life had safety, autonomy, and opportunity present. The worst had one or more of those domains — body, resources, time — under threat or taken away.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>

    <p class="body-text">This is a strong claim. You might agree with the pattern but question whether it applies as broadly as the philosophy suggests. You might think there are exceptions important enough to justify force — situations where the cost of coercion is worth the benefit it produces.</p>

    <p class="body-text">Good. The next experience takes your strongest objection seriously.</p>

    <NewsletterSignup
      variant="minimal"
      source="exp03_closing"
      headline="One idea per week, grounded in flourishing."
      description="A short email connecting the Philosophy of Human Respect to something happening in the world right now."
      button-text="Subscribe"
    />

    <JourneyNav current="exp03" />

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
.discoveries { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.5rem; }
.discovery { display: flex; gap: 1.25rem; align-items: flex-start; }
.discovery-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.discovery-title { font-family: var(--serif); font-size: 1.1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.discovery-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.65; margin: 0; }
</style>
VUEEOF

echo "  ✓ TheBridge revised"

echo ""
echo "✅ Exp03 Opening + TheBridge fixed for new sequence"
echo ""
echo "Opening now says:"
echo "  'You discovered that you already choose persuasion over force'"
echo "  'Now let's look at why. Your own experience holds the evidence.'"
echo ""
echo "TheBridge now:"
echo "  Summarizes TWO discoveries (method + evidence), not three"
echo "  Restates the Flourishing Principle"
echo "  Bridges to the Objection: 'You might think there are exceptions'"
echo "  Newsletter signup"
echo "  JourneyNav (which will recommend Exp02 next)"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'exp03: fix opening + bridge for new sequence' && git push"
