import { defineVitestConfig } from '@nuxt/test-utils/config'

export default defineVitestConfig({
  test: {
    environment: 'nuxt',
    environmentOptions: {
      nuxt: { domEnvironment: 'happy-dom' }
    },
    include: ['test/**/*.test.js'],
    // Nuxt's test environment boots a real Nuxt app per file; the default
    // 5s timeout is not enough for the first one to compile.
    testTimeout: 20_000,
    hookTimeout: 60_000
  }
})
