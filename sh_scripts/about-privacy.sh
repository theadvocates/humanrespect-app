#!/bin/bash
# About and Privacy pages
# Run from humanrespect-app/ root

set -e

echo "📄 Building About + Privacy pages..."

# ══════════════════════════════════════
# ROUTER — add privacy route
# ══════════════════════════════════════

cat > src/router/index.js << 'JSEOF'
import { createRouter, createWebHistory } from 'vue-router'
import LandingPage from '@/pages/LandingPage.vue'

const routes = [
  { path: '/', name: 'home', component: LandingPage },
  { path: '/experience/the-question', name: 'exp01', component: () => import('@/pages/Experience01.vue') },
  { path: '/experience/the-objection', name: 'exp02', component: () => import('@/pages/Experience02.vue') },
  { path: '/experience/flourishing', name: 'exp03', component: () => import('@/pages/Experience03.vue') },
  { path: '/pillar/your-body-is-not-negotiable', name: 'pillarA', component: () => import('@/pages/PillarA.vue') },
  { path: '/pillar/your-time-is-your-life', name: 'pillarB', component: () => import('@/pages/PillarB.vue') },
  { path: '/pillar/what-you-built', name: 'pillarC', component: () => import('@/pages/PillarC.vue') },
  { path: '/pillar/the-method-is-the-message', name: 'pillarD', component: () => import('@/pages/PillarD.vue') },
  { path: '/pillar/cooperation-is-a-technology', name: 'pillarE', component: () => import('@/pages/PillarE.vue') },
  { path: '/practice/political-footprint', name: 'practice01', component: () => import('@/pages/Practice01.vue') },
  { path: '/practice/persuasion-practice', name: 'practice02', component: () => import('@/pages/Practice02.vue') },
  { path: '/practice/the-conversation', name: 'practice03', component: () => import('@/pages/Practice03.vue') },
  { path: '/practice/respect-audit', name: 'practice04', component: () => import('@/pages/Practice04.vue') },
  { path: '/practice/design-a-solution', name: 'practice05', component: () => import('@/pages/Practice05.vue') },
  { path: '/about', name: 'about', component: () => import('@/pages/AboutPage.vue') },
  { path: '/privacy', name: 'privacy', component: () => import('@/pages/PrivacyPage.vue') },
  { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('@/pages/NotFound.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0 } }
})

export default router
JSEOF

echo "  ✓ Router updated with /privacy"

# ══════════════════════════════════════
# ABOUT PAGE
# ══════════════════════════════════════

cat > src/pages/AboutPage.vue << 'VUEEOF'
<template>
  <div class="page">
    <div class="page-container">

      <p class="caption">About</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">Why this exists.</h1>
      <Divider />

      <p class="body-text-large">We live in an era of permanent political conflict. Left against right. Progressive against conservative. Every election is a battle, every policy debate a war, every disagreement a threat.</p>

      <p class="body-text-large">But the conflict may not actually be about values.</p>

      <p class="body-text">Most people share the same fundamental drive: to live well, to care for the people they love, to build something meaningful, and to be left in peace to do it. Progressive and conservative values are both genuine expressions of that drive. The real divide is not <em>what</em> people want. It's <em>how</em> they propose to get it.</p>

      <p class="body-text">And almost everyone, on every side, has settled on the same method: force. Capture political power. Pass laws. Compel compliance. Punish dissent. Use the machinery of government to impose your values on people who didn't choose them.</p>

      <p class="body-text">The Philosophy of Human Respect asks a different question: <em>What if we advanced our values through persuasion and voluntary cooperation instead?</em></p>

      <!-- THE PHILOSOPHY -->
      <h2 class="section-heading">The Philosophy</h2>
      <Divider />

      <p class="body-text">The Philosophy of Human Respect begins with an observation about human nature: every person possesses three domains of integrity, their body, their resources, and their time. When these domains are respected, people flourish. When they're violated through violence, theft, or coercion, flourishing predictably declines.</p>

      <p class="body-text">This pattern is grounded in psychology, neuroscience, economics, and the lived experience of every human being. You can test it against your own life: the best periods had safety, autonomy, and opportunity present. The worst periods had one or more of those domains under attack.</p>

      <p class="body-text">From this foundation emerges a principle:</p>

      <ContentBlock variant="principle">
        <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
      </ContentBlock>

      <p class="body-text">The implications reach further than you'd expect. Most people already live by this principle in their personal lives. They don't steal from neighbors. They don't threaten coworkers. They solve problems through conversation and voluntary agreement.</p>

      <p class="body-text">The philosophy simply asks: can we extend that same principle to how we organize society?</p>

      <!-- WHAT THIS SITE IS -->
      <h2 class="section-heading">What this site is</h2>
      <Divider />

      <p class="body-text">humanrespect.app is a series of interactive experiences designed to help you discover the Philosophy of Human Respect through your own reasoning. Not by being told what to think, but by examining what you already believe.</p>

      <p class="body-text">Each experience uses questions, scenarios, and reflections to surface insights about the relationship between force, cooperation, and human flourishing. There are no scores, no grades, no personality types. Just your own thinking, reflected back to you.</p>

      <p class="body-text">The experiences are organized in three tiers: a foundation sequence that introduces the core ideas, a set of deeper explorations into specific dimensions of the philosophy, and a practice layer that helps you apply the ideas to your own life.</p>

      <p class="body-text">Everything on this site is free. No ads, no paywalls, no data sold to third parties.</p>

      <!-- THE PHILOSOPHER -->
      <h2 class="section-heading">The philosopher</h2>
      <Divider />

      <p class="body-text">The Philosophy of Human Respect was articulated by Chris J. Rufer, founder of The Morning Star Company and a lifelong advocate for voluntary cooperation. Drawing on decades of observation about human nature and social systems, Rufer identified that sustainable solutions to social challenges come not from forcing values on others, but from persuading people to cooperate voluntarily.</p>

      <p class="body-text">The philosophy builds on insights from psychology, neuroscience, self-determination theory, and economics. But its core claim is simple enough for a child to understand: don't hurt people, don't take their stuff, and don't waste their time.</p>

      <!-- THE PROOF -->
      <h2 class="section-heading">The proof</h2>
      <Divider />

      <p class="body-text">Rufer doesn't just write about voluntary cooperation. He runs a company on it.</p>

      <p class="body-text">The Morning Star Company, which he founded in 1970, is the world's largest tomato processor, with over $800 million in annual revenue, three factories, and thousands of employees. It operates with no bosses, no management hierarchy, and no titles. Every organizational decision rests on two principles that will sound familiar: all interactions should be voluntary, and people should honor their commitments.</p>

      <p class="body-text">Morning Star calls this Mission Focused Self-Management. Colleagues define their own roles, negotiate responsibilities directly with each other, make purchasing decisions in consultation with peers, and set their own compensation through a process of peer evaluation. Conflicts are resolved through direct conversation, not top-down authority. Harvard Business School has studied the model. So have researchers in organizational behavior around the world.</p>

      <p class="body-text">The result: a one-truck operation that grew into a global market leader processing roughly 40% of California's tomato crop, all without anyone being told what to do by a boss.</p>

      <p class="body-text">The Philosophy of Human Respect is not an armchair theory. It's the articulation of principles that have been tested in a real business, with real people, for over fifty years.</p>

      <!-- CONTACT -->
      <h2 class="section-heading">Contact</h2>
      <Divider />

      <p class="body-text">Questions, thoughts, or disagreements are welcome at <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a>.</p>

      <p class="body-text">We mean that. If you went through one of the experiences and found a flaw in the reasoning, an objection we didn't address, or a place where the philosophy falls short, we want to hear it. A philosophy that can't withstand honest criticism isn't worth promoting.</p>

      <!-- CTA -->
      <div style="margin-top: 3rem;">
        <PathCard :to="{ name: 'exp01' }">
          <template #title>Start the experience</template>
          <template #desc>A five-minute philosophical experiment that reveals something about your own moral reasoning.</template>
        </PathCard>
      </div>

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'

onMounted(() => document.body.classList.remove('dark-mode'))
</script>

<style scoped>
.page {
  background: var(--paper);
  min-height: 100vh;
}

.page-container {
  max-width: 640px;
  margin: 0 auto;
  padding: 6rem 1.5rem 4rem;
}

.section-heading {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-weight: 500;
  color: var(--ink);
  margin-top: 3.5rem;
}

.body-text-large {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1.25rem;
}

.body-text {
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1rem;
}

.body-text em {
  color: var(--ink);
}

.text-link {
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s;
}

.text-link:hover {
  border-bottom-color: var(--ochre);
}

/* Footer */
.page-footer {
  padding: 3rem 1.5rem;
  background: var(--ink);
  display: flex;
  justify-content: center;
}

.footer-inner {
  max-width: 640px;
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-left {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: rgba(244, 240, 234, 0.3);
}

.footer-right { display: flex; gap: 2rem; }

.footer-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(244, 240, 234, 0.25);
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 4rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
VUEEOF

echo "  ✓ AboutPage.vue"

# ══════════════════════════════════════
# PRIVACY PAGE
# ══════════════════════════════════════

cat > src/pages/PrivacyPage.vue << 'VUEEOF'
<template>
  <div class="page">
    <div class="page-container">

      <p class="caption">Privacy</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">How we handle your data.</h1>
      <Divider />

      <p class="body-text">We believe in transparency. This page explains exactly what data we collect, why we collect it, and what we do with it. No legal fog. No buried clauses.</p>

      <!-- WHAT WE COLLECT -->
      <h2 class="section-heading">What we collect</h2>
      <Divider />

      <p class="body-text"><strong>Anonymous usage data.</strong> When you go through experiences on this site, we record which screens you visit, which choices you make, and whether you complete each experience. This data is tied to a randomly generated ID stored in your browser, not to your name, email, or any identifying information. We use this data to understand which experiences resonate, where people drop off, and how to improve the content.</p>

      <p class="body-text"><strong>Basic traffic data.</strong> We use Cloudflare Web Analytics to understand how many people visit the site, what devices they use, and where traffic comes from. Cloudflare collects this data without using cookies and without tracking individual users across sites.</p>

      <p class="body-text"><strong>Newsletter signups.</strong> If you choose to subscribe to our weekly email, we store your email address and which experience you subscribed from. This is the only personally identifiable information we collect, and only because you gave it to us voluntarily.</p>

      <p class="body-text"><strong>Local preferences.</strong> Your journey progress (which experiences you've completed, your answers to interactive questions) is stored in your browser's local storage. This stays on your device. It's what allows the site to remember where you left off when you return. You can clear it anytime through your browser settings.</p>

      <!-- WHAT WE DON'T DO -->
      <h2 class="section-heading">What we don't do</h2>
      <Divider />

      <p class="body-text">We don't sell your data to anyone. We don't share it with advertisers. We don't use tracking cookies. We don't run retargeting campaigns. We don't use Google Analytics. We don't build profiles that follow you across the internet.</p>

      <p class="body-text">We don't gate any content behind email capture. Every experience on this site is fully accessible without signing up for anything.</p>

      <!-- WHY WE TRACK -->
      <h2 class="section-heading">Why we track anything at all</h2>
      <Divider />

      <p class="body-text">Honest answer: because we want to know if the philosophy is landing.</p>

      <p class="body-text">If 80% of visitors drop off at the same screen, that screen needs rewriting. If one objection path resonates more than others, that tells us something about what people are actually thinking. If the Pillar on Temporal Integrity has twice the completion rate of the one on Material Integrity, we should understand why.</p>

      <p class="body-text">We track engagement to make the experiences better. That's it.</p>

      <!-- YOUR CHOICES -->
      <h2 class="section-heading">Your choices</h2>
      <Divider />

      <p class="body-text">You can use this entire site without giving us any personal information. Your anonymous usage data helps us improve, but if you prefer not to contribute even that, a standard ad blocker will prevent the analytics scripts from loading. The experiences will still work perfectly.</p>

      <p class="body-text">If you subscribed to the newsletter and want to unsubscribe, every email includes an unsubscribe link. If you want your email removed from our database entirely, send a request to <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a> and we'll delete it.</p>

      <p class="body-text">To clear your local journey data, open your browser's developer tools, go to Application, find Local Storage for humanrespect.app, and delete the entry. Or just use your browser's "clear site data" option.</p>

      <!-- SHORT VERSION -->
      <h2 class="section-heading">The short version</h2>
      <Divider />

      <p class="body-text">We collect anonymous data to improve the site. We collect your email only if you give it to us. We don't sell anything to anyone. We respect your time, your attention, and your privacy. It's kind of our whole philosophy.</p>

      <p class="body-text" style="margin-top: 2rem;">Questions? <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a></p>

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

onMounted(() => document.body.classList.remove('dark-mode'))
</script>

<style scoped>
.page {
  background: var(--paper);
  min-height: 100vh;
}

.page-container {
  max-width: 640px;
  margin: 0 auto;
  padding: 6rem 1.5rem 4rem;
}

.section-heading {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-weight: 500;
  color: var(--ink);
  margin-top: 3.5rem;
}

.body-text {
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1rem;
}

.body-text strong {
  color: var(--ink);
  font-weight: 500;
}

.text-link {
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s;
}

.text-link:hover {
  border-bottom-color: var(--ochre);
}

.page-footer {
  padding: 3rem 1.5rem;
  background: var(--ink);
  display: flex;
  justify-content: center;
}

.footer-inner {
  max-width: 640px;
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-left {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: rgba(244, 240, 234, 0.3);
}

.footer-right { display: flex; gap: 2rem; }

.footer-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(244, 240, 234, 0.25);
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 4rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
VUEEOF

echo "  ✓ PrivacyPage.vue"

# ══════════════════════════════════════
# UPDATE LANDING PAGE FOOTER to link to Privacy
# ══════════════════════════════════════

# We need to update the footer link in LandingPage.vue
# The footer currently has a dead "#" link for Privacy
# We'll use sed to fix just that one line

sed -i.bak 's|<a href="#" class="footer-link">Privacy</a>|<router-link to="/privacy" class="footer-link">Privacy</router-link>|' src/pages/LandingPage.vue
rm -f src/pages/LandingPage.vue.bak

echo "  ✓ Landing page footer links to /privacy"

echo ""
echo "✅ About + Privacy pages complete!"
echo ""
echo "Routes:"
echo "  /about   — philosophy, site description, Chris Rufer, Morning Star, contact"
echo "  /privacy — data practices, what we collect, what we don't, user choices"
echo ""
echo "Push with: git add . && git commit -m 'about + privacy pages' && git push"
