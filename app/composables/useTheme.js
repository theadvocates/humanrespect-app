/**
 * Light or dark, chosen by the visitor.
 *
 * The choice is applied as data-theme on <html>. A small script in app.vue
 * sets it before first paint (from localStorage, or the system setting until
 * the visitor picks), so the page never flashes the wrong theme. This
 * composable only reads that attribute and changes it.
 */
export const THEME_KEY = 'hr-theme'

export function useTheme() {
  const theme = useState('theme', () => 'light')

  function sync() {
    if (import.meta.server) return
    theme.value = document.documentElement.dataset.theme === 'dark' ? 'dark' : 'light'
  }

  function set(next) {
    theme.value = next
    if (import.meta.server) return
    document.documentElement.dataset.theme = next
    try { localStorage.setItem(THEME_KEY, next) } catch (e) { /* private mode */ }
    window.dispatchEvent(new CustomEvent('themechange', { detail: next }))
  }

  function toggle() {
    set(theme.value === 'dark' ? 'light' : 'dark')
  }

  return { theme, sync, set, toggle }
}

/** Runs inline in <head>, before anything paints. Keep it tiny and ES5. */
export const THEME_BOOT_SCRIPT = `(function(){try{var t=localStorage.getItem('${THEME_KEY}');if(t!=='dark'&&t!=='light'){t=window.matchMedia&&matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light'}document.documentElement.dataset.theme=t}catch(e){}})()`
