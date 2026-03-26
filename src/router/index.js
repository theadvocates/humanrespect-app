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
  { path: '/:pathMatch(.*)*', name: 'not-found', component: () => import('@/pages/NotFound.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0 } }
})

export default router
