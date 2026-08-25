#!/bin/bash
# OG image + meta tags for social sharing
# Run from humanrespect-app/ root

set -e

echo "🖼️  Setting up social sharing..."

# ══════════════════════════════════════
# 1. COPY OG IMAGES TO PUBLIC FOLDER
# ══════════════════════════════════════

cp /mnt/user-data/uploads/og-default.png public/og-default.png 2>/dev/null || echo "  ⚠ Copy og-default.png to public/ manually"
cp /mnt/user-data/uploads/og-dark.png public/og-dark.png 2>/dev/null || echo "  ⚠ Copy og-dark.png to public/ manually"
cp /mnt/user-data/uploads/og-square.png public/og-square.png 2>/dev/null || echo "  ⚠ Copy og-square.png to public/ manually"

echo "  ✓ OG images in public/"

# ══════════════════════════════════════
# 2. UPDATE INDEX.HTML WITH FULL META TAGS
# ══════════════════════════════════════

cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Human Respect — Discover the principle you already live by</title>

    <!-- Primary meta -->
    <meta name="description" content="A series of interactive philosophical experiences exploring how voluntary cooperation relates to human flourishing. The Philosophy of Human Respect, articulated by Chris J. Rufer." />
    <meta name="author" content="Human Respect" />
    <meta name="theme-color" content="#1E1C19" />

    <!-- Open Graph (Facebook, LinkedIn, iMessage, Slack) -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://humanrespect.app/" />
    <meta property="og:title" content="The Philosophy of Human Respect" />
    <meta property="og:description" content="Discover the principle you already live by. Interactive philosophical experiences exploring force, cooperation, and human flourishing." />
    <meta property="og:image" content="https://humanrespect.app/og-default.png" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
    <meta property="og:image:alt" content="The Philosophy of Human Respect — Discover the principle you already live by" />
    <meta property="og:site_name" content="Human Respect" />
    <meta property="og:locale" content="en_US" />

    <!-- Twitter/X -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="The Philosophy of Human Respect" />
    <meta name="twitter:description" content="Discover the principle you already live by. A five-minute thought experiment that reveals something about your own moral reasoning." />
    <meta name="twitter:image" content="https://humanrespect.app/og-default.png" />
    <meta name="twitter:image:alt" content="The Philosophy of Human Respect — Discover the principle you already live by" />

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />
    <link rel="icon" type="image/png" sizes="32x32" href="/hr-monogram-32.png" />
    <link rel="apple-touch-icon" sizes="192x192" href="/hr-monogram-192.png" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400;1,500&family=Karla:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&display=swap" rel="stylesheet" />

    <!-- Canonical -->
    <link rel="canonical" href="https://humanrespect.app/" />
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
HTMLEOF

echo "  ✓ index.html updated with full meta tags"

# ══════════════════════════════════════
# 3. DYNAMIC META TAGS PER ROUTE
#    Vue router afterEach hook updates title + meta
# ══════════════════════════════════════

cat > src/router/meta.js << 'JSEOF'
// Per-route metadata for SEO and social sharing
// og:image stays the same (static OG image) but title/description change

export const routeMeta = {
  home: {
    title: 'Human Respect — Discover the principle you already live by',
    description: 'A series of interactive philosophical experiences exploring how voluntary cooperation relates to human flourishing.'
  },
  exp01: {
    title: 'The Question — Human Respect',
    description: 'A five-minute thought experiment that reveals the gap between your personal morality and your political beliefs.'
  },
  exp02: {
    title: 'The Objection — Human Respect',
    description: 'Pick your strongest objection to voluntary cooperation. It gets steelmanned, responded to, and honestly conceded.'
  },
  exp03: {
    title: 'What Flourishing Actually Means — Human Respect',
    description: 'Discover the empirical grounding for the principle of Human Respect — traced through your own life experience.'
  },
  pillarA: {
    title: 'Your Body Is Not Negotiable — Human Respect',
    description: 'Bodily integrity: why physical safety is the precondition for all human flourishing.'
  },
  pillarB: {
    title: 'Your Time Is Your Life — Human Respect',
    description: 'Time as the irreplaceable substance of life — the Philosophy of Human Respect\'s most original insight.'
  },
  pillarC: {
    title: 'What You Built Is Who You Were — Human Respect',
    description: 'Property as crystallized time: why material integrity matters for human flourishing.'
  },
  pillarD: {
    title: 'The Method Is the Message — Human Respect',
    description: 'Your values aren\'t the problem. The question is whether you advance them through force or persuasion.'
  },
  pillarE: {
    title: 'Cooperation Is a Technology — Human Respect',
    description: 'Real evidence that voluntary cooperation solves problems people assume require government force.'
  },
  practice01: {
    title: 'Your Political Footprint — Human Respect',
    description: 'Map where you currently support coercion in your political life.'
  },
  practice02: {
    title: 'The Persuasion Practice — Human Respect',
    description: 'Take an issue you care about and design a persuasion-only approach to solving it.'
  },
  practice03: {
    title: 'The Conversation — Human Respect',
    description: 'A framework for discussing Human Respect with someone who disagrees with you.'
  },
  practice04: {
    title: 'The Respect Audit — Human Respect',
    description: 'Track where you choose persuasion vs. force for seven days.'
  },
  practice05: {
    title: 'Design a Voluntary Solution — Human Respect',
    description: 'Pick a real problem in your community and design a solution that doesn\'t use force.'
  },
  about: {
    title: 'About — Human Respect',
    description: 'Why this exists: the Philosophy of Human Respect, articulated by Chris J. Rufer, founder of The Morning Star Company.'
  },
  privacy: {
    title: 'Privacy — Human Respect',
    description: 'How we handle your data. Anonymous analytics, no tracking cookies, no data sales.'
  }
}
JSEOF

echo "  ✓ Route metadata created"

# ══════════════════════════════════════
# 4. WIRE META INTO ROUTER
# ══════════════════════════════════════

cat > src/router/index.js << 'JSEOF'
import { createRouter, createWebHistory } from 'vue-router'
import LandingPage from '@/pages/LandingPage.vue'
import { routeMeta } from './meta.js'

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

// Update document title and meta description on each navigation
router.afterEach((to) => {
  const meta = routeMeta[to.name] || routeMeta.home
  
  document.title = meta.title
  
  // Update meta description
  let descTag = document.querySelector('meta[name="description"]')
  if (descTag) descTag.setAttribute('content', meta.description)
  
  // Update OG tags
  let ogTitle = document.querySelector('meta[property="og:title"]')
  if (ogTitle) ogTitle.setAttribute('content', meta.title.replace(' — Human Respect', ''))
  
  let ogDesc = document.querySelector('meta[property="og:description"]')
  if (ogDesc) ogDesc.setAttribute('content', meta.description)

  let ogUrl = document.querySelector('meta[property="og:url"]')
  if (ogUrl) ogUrl.setAttribute('content', 'https://humanrespect.app' + to.path)
  
  // Update Twitter tags
  let twTitle = document.querySelector('meta[name="twitter:title"]')
  if (twTitle) twTitle.setAttribute('content', meta.title.replace(' — Human Respect', ''))
  
  let twDesc = document.querySelector('meta[name="twitter:description"]')
  if (twDesc) twDesc.setAttribute('content', meta.description)
})

export default router
JSEOF

echo "  ✓ Router wired with dynamic meta tags"

echo ""
echo "✅ Social sharing setup complete!"
echo ""
echo "IMPORTANT: Copy the OG images to public/ manually if the script couldn't:"
echo "  cp ~/Downloads/og-default.png public/"
echo "  cp ~/Downloads/og-dark.png public/"
echo "  cp ~/Downloads/og-square.png public/"
echo ""
echo "Also copy favicon assets to public/ if not already there:"
echo "  cp ~/Downloads/favicon.ico public/"
echo "  cp ~/Downloads/hr-monogram-32.png public/"
echo "  cp ~/Downloads/hr-monogram-192.png public/"
echo ""
echo "What you get:"
echo "  • OG image: 1200x630 branded card with lockup + tagline"
echo "  • Per-route title + description (updates on navigation)"
echo "  • Twitter card: summary_large_image"
echo "  • Favicon: multi-resolution ICO + PNG + Apple touch icon"
echo "  • Canonical URL"
echo ""
echo "Test after deploy:"
echo "  • https://developers.facebook.com/tools/debug/ (paste your URL)"
echo "  • https://cards-dev.twitter.com/validator (paste your URL)"
echo "  • Share a link in iMessage or Slack and check the preview"
echo ""
echo "Push with: git add . && git commit -m 'og: social sharing images + meta tags' && git push"
