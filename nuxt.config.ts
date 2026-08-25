export default defineNuxtConfig({
  compatibilityDate: '2025-08-25',
  devtools: { enabled: true },

  modules: ['@pinia/nuxt'],

  css: [
    '~/styles/tokens.css',
    '~/styles/base.css',
    '~/styles/typography.css',
    '~/styles/animations.css',
    '~/styles/mobile.css'
  ],

  app: {
    head: {
      htmlAttrs: { lang: 'en' },
      meta: [
        { charset: 'UTF-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1.0' },
        { name: 'author', content: 'Human Respect' },
        { name: 'theme-color', content: '#1E1C19' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
        { rel: 'icon', type: 'image/png', sizes: '32x32', href: '/hr-monogram-32.png' },
        { rel: 'apple-touch-icon', sizes: '192x192', href: '/hr-monogram-192.png' },
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Cormorant:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400;1,500&family=Karla:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&display=swap'
        }
      ]
    }
  },

  runtimeConfig: {
    // Server-only — never exposed to the client bundle.
    buttondownApiKey: process.env.BUTTONDOWN_API_KEY || '',
    supabaseServiceKey: process.env.SUPABASE_SERVICE_KEY || '',

    public: {
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || 'https://humanrespect.app',
      supabaseUrl: process.env.NUXT_PUBLIC_SUPABASE_URL || '',
      supabaseAnonKey: process.env.NUXT_PUBLIC_SUPABASE_ANON_KEY || ''
    }
  },

  nitro: {
    prerender: {
      crawlLinks: true,
      routes: ['/', '/about', '/privacy'],
      failOnError: false
    }
  }
})
