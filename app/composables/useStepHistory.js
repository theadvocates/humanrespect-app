import { watch, onMounted, onBeforeUnmount } from 'vue'
import { noteNavDirection } from '@/composables/useAnalytics'

/**
 * Makes the browser's back button (and the iPhone back swipe) step back
 * through the screens of a multi-step page, instead of leaving the page.
 *
 * Every change to `step` adds a history entry without changing the URL, so
 * nothing about the address, sharing, or search changes. Going back restores
 * the previous step; going back from the first step leaves the page as usual.
 *
 * The entry keeps Vue Router's own history state and adds one key beside it.
 * Each mount gets a session id, so entries left over from before a reload are
 * recognised and skipped over rather than restoring a screen whose answers no
 * longer exist.
 *
 *   const steps = useStepHistory(currentScreen, { id: 'exp01' })
 *   steps.back()        // an on-screen Back button
 *   steps.reset()       // "start over": return to the first step's entry
 */
const KEY = '__hrStep'

export function useStepHistory(step, { id, initial = 0 } = {}) {
  const sid = Math.random().toString(36).slice(2, 10)
  // The step shown at each history entry this page has made; the last one is
  // the entry the browser is on.
  let stack = [step.value]
  // A step value that should not create a new entry, because it came from
  // history rather than from the visitor moving forward.
  let skip = null
  // Pops this page caused itself (Back button, reset), already applied.
  let ownPops = 0

  const depth = () => stack.length - 1

  function write(method) {
    // Drop the router's saved scroll: steps always open at the top.
    const state = { ...(window.history.state || {}), [KEY]: { id, sid, n: step.value, depth: depth() } }
    delete state.scroll
    window.history[method](state, '')
  }

  function show(n, direction) {
    if (step.value === n) return
    noteNavDirection(direction)
    skip = n
    step.value = n
    window.scrollTo(0, 0)
  }

  watch(step, (n) => {
    if (import.meta.server) return
    if (skip !== null && n === skip) {
      skip = null
      return
    }
    stack.push(n)
    write('pushState')
  })

  function onPop(event) {
    if (ownPops > 0) {
      ownPops -= 1
      return
    }
    const s = event.state?.[KEY]
    // Another page's entry; the router handles it.
    if (s && s.id !== id) return

    // An entry from before a reload: jump past the rest of that old session.
    if (s && s.sid !== sid) {
      if (s.depth > 0) window.history.go(-s.depth)
      else show(initial, 'back')
      return
    }

    const n = s ? s.n : initial
    const to = s ? s.depth : 0
    const direction = to < depth() ? 'back' : 'forward'
    stack = stack.slice(0, to + 1)
    stack[to] = n
    show(n, direction)
  }

  /**
   * For an on-screen Back button: shows the previous step at once and moves
   * the browser back to match. Returns false on the first step.
   */
  function back() {
    if (depth() === 0) return false
    stack.pop()
    ownPops += 1
    show(stack[depth()], 'back')
    window.history.back()
    return true
  }

  /**
   * Returns to the first step's entry, so Back after "start over" leaves the
   * page instead of walking into a finished run with its answers cleared.
   * Call it before changing the step yourself.
   */
  function reset() {
    if (depth() === 0) return
    const d = depth()
    stack = [initial]
    ownPops += 1
    if (step.value !== initial) skip = initial
    window.history.go(-d)
  }

  onMounted(() => {
    stack = [step.value]
    write('replaceState')
    window.addEventListener('popstate', onPop)
  })
  onBeforeUnmount(() => window.removeEventListener('popstate', onPop))

  return { back, reset }
}
