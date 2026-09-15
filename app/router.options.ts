import type { RouterConfig } from '@nuxt/schema'

// Nuxt's own scroll behaviour waits for a hook that only <NuxtPage> fires.
// This app renders pages with a plain <router-view>, so that hook never came
// and every link opened the next page at the old scroll depth.
export default <RouterConfig>{
  scrollBehavior(to, from, savedPosition) {
    // Same page: step changes (useStepHistory) and query changes handle their
    // own scrolling. Only a hash moves the view.
    if (to.path === from.path) {
      return to.hash ? { el: to.hash, behavior: 'smooth' } : false
    }
    // Wait for the new page to render, so a saved position or a hash target
    // exists before scrolling to it.
    return new Promise((resolve) => {
      requestAnimationFrame(() => requestAnimationFrame(() => {
        if (savedPosition) resolve(savedPosition)
        else if (to.hash) resolve({ el: to.hash })
        else resolve({ left: 0, top: 0 })
      }))
    })
  }
}
