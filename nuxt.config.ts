export default defineNuxtConfig({
  compatibilityDate: '2025-08-25',
  devtools: { enabled: true },

  modules: ['@pinia/nuxt', '@nuxt/eslint'],

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
      supabaseAnonKey: process.env.NUXT_PUBLIC_SUPABASE_ANON_KEY || '',
      // PostHog project key. Public by design — it is write-only and ships in
      // the browser bundle. Analytics no-op entirely when it is unset.
      posthogKey: process.env.NUXT_PUBLIC_POSTHOG_KEY || '',
      posthogHost: process.env.NUXT_PUBLIC_POSTHOG_HOST || '/ingest',
      // Google Search Console verification token, if using the meta-tag method.
      googleSiteVerification: process.env.NUXT_PUBLIC_GOOGLE_SITE_VERIFICATION || ''
    }
  },

  routeRules: {
    // Security headers for every route.
    //
    // These lived in public/_headers, which is a Cloudflare Pages format that
    // Vercel silently ignores — so from the DNS cutover until now the site
    // sent none of them. Route rules are the Nitro-native equivalent and work
    // on any host.
    '/**': {
      headers: {
        // The site is never legitimately framed, and framing is how
        // clickjacking works.
        'X-Frame-Options': 'DENY',
        'X-Content-Type-Options': 'nosniff',
        // Send the origin cross-site but never the full path — visiting
        // /certificate/<code> should not leak that code in a referer header.
        'Referrer-Policy': 'strict-origin-when-cross-origin',
        // Nothing here needs a camera, a microphone, or a location.
        'Permissions-Policy': 'camera=(), microphone=(), geolocation=(), interest-cohort=()'
      }
    },

    // Analytics served from our own domain. PostHog's own domains are on every
    // blocker list, so a large share of requests never arrive. The order
    // matters: the static rule must precede the catch-all.
    '/ingest/static/**': { proxy: 'https://us-assets.i.posthog.com/static/**' },
    '/ingest/**': { proxy: 'https://us.i.posthog.com/**' },

    // The account page reads session state, which only exists in the browser —
    // server-rendering it would always evaluate as signed-out and bounce the
    // user to sign-in. It is noindex, so nothing is lost by client-rendering.
    // /account/sign-in and /account/callback render fine without a session and
    // keep SSR.
    '/account': { ssr: false }
  },

  nitro: {
    prerender: {
      crawlLinks: true,
      routes: ['/', '/about', '/privacy'],
      ignore: ['/account', '/certificate'],
      failOnError: false
    }
  }
})
