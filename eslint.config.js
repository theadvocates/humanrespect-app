import { defineConfig, globalIgnores } from 'eslint/config'
import globals from 'globals'
import js from '@eslint/js'
import pluginVue from 'eslint-plugin-vue'
import skipFormatting from 'eslint-config-prettier/flat'

// Nuxt auto-imports these into app code; ESLint needs to be told they exist.
const nuxtAutoImports = {
  defineNuxtConfig: 'readonly',
  defineNuxtPlugin: 'readonly',
  definePageMeta: 'readonly',
  defineEventHandler: 'readonly',
  createError: 'readonly',
  readBody: 'readonly',
  getRequestHeader: 'readonly',
  useRuntimeConfig: 'readonly',
  useRoute: 'readonly',
  useRouter: 'readonly',
  useHead: 'readonly',
  useSeoMeta: 'readonly',
  useState: 'readonly',
  useFetch: 'readonly',
  useAsyncData: 'readonly',
  $fetch: 'readonly',
  navigateTo: 'readonly',
  usePageSeo: 'readonly'
}

export default defineConfig([
  { name: 'app/files-to-lint', files: ['**/*.{vue,js,mjs,jsx}'] },

  globalIgnores([
    '**/.nuxt/**',
    '**/.output/**',
    '**/dist/**',
    '**/coverage/**',
    '**/node_modules/**',
    'archive/**'
  ]),

  {
    languageOptions: {
      globals: { ...globals.browser, ...globals.node, ...nuxtAutoImports }
    }
  },

  js.configs.recommended,
  ...pluginVue.configs['flat/essential'],

  {
    rules: {
      // Unused catch bindings are used deliberately for silent-failure paths.
      'no-unused-vars': ['error', { caughtErrors: 'none', args: 'after-used' }],
      // Nuxt pages are route paths, not multi-word component names.
      'vue/multi-word-component-names': 'off'
    }
  },

  skipFormatting
])
