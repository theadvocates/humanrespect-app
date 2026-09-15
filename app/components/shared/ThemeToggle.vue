<template>
  <button
    class="theme-toggle"
    type="button"
    :aria-label="theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'"
    :title="theme === 'dark' ? 'Light mode' : 'Dark mode'"
    @click="onClick"
  >
    <!-- Shows the mode you'd switch to: a moon in light mode, a sun in dark. -->
    <svg v-if="theme === 'dark'" viewBox="0 0 24 24" aria-hidden="true">
      <circle cx="12" cy="12" r="4.2" fill="none" stroke="currentColor" stroke-width="1.6" />
      <path
        d="M12 2.5v2.2M12 19.3v2.2M4.6 4.6l1.6 1.6M17.8 17.8l1.6 1.6M2.5 12h2.2M19.3 12h2.2M4.6 19.4l1.6-1.6M17.8 6.2l1.6-1.6"
        stroke="currentColor" stroke-width="1.6" stroke-linecap="round"
      />
    </svg>
    <svg v-else viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z"
        fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"
      />
    </svg>
  </button>
</template>

<script setup>
const { theme, sync, toggle } = useTheme()
const { capture } = useAnalytics()

function onClick() {
  toggle()
  capture('theme_changed', { theme: theme.value })
}

onMounted(sync)
</script>

<style scoped>
.theme-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  min-height: 0;
  margin: -0.4rem -0.55rem -0.4rem 0;
  padding: 0;
  border: none;
  border-radius: 50%;
  background: transparent;
  color: var(--ink-muted);
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
  transition: color 0.2s ease, background 0.2s ease;
}
.theme-toggle:hover { color: var(--ink); background: var(--paper-deep); }
.theme-toggle:focus-visible { outline: 2px solid var(--ochre); outline-offset: 2px; }
.theme-toggle svg { width: 1.2rem; height: 1.2rem; display: block; }

</style>

<style>
body.dark-mode .theme-toggle { color: rgba(240, 235, 227, 0.7); }
body.dark-mode .theme-toggle:hover { color: rgba(240, 235, 227, 0.95); background: rgba(240, 235, 227, 0.08); }
</style>
