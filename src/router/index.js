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
  { path: '/experience/human-nature', name: 'exp04', component: () => import('@/pages/Experience04.vue') },
  { path: '/milestone', name: 'milestone', component: () => import('@/pages/MilestonePage.vue') },
  { path: '/about', name: 'about', component: () => import('@/pages/AboutPage.vue') },
  { path: '/privacy', name: 'privacy', component: () => import('@/pages/PrivacyPage.vue') },
  { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('@/pages/NotFound.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0, behavior: 'instant' } }
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
