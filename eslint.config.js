// Nuxt generates the base config, including globals for every auto-imported
// composable and Vue reactivity API, so that list never drifts from the code.
import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt({
  ignores: ['archive/**', 'supabase/**', '.output/**', 'dist/**'],
  rules: {
    // Unused catch bindings are deliberate on silent-failure paths.
    'no-unused-vars': ['error', { caughtErrors: 'none', args: 'after-used' }],
    // Nuxt pages are route paths, not multi-word component names.
    'vue/multi-word-component-names': 'off'
  }
})
