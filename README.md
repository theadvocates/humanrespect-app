# Human Respect

An interactive introduction to the Philosophy of Human Respect — a sequence of
guided experiences that lead people to examine, through their own reasoning, how
voluntary cooperation relates to human flourishing.

Live at **[humanrespect.app](https://humanrespect.app)**.

## Stack

- **[Nuxt 4](https://nuxt.com)** (Vue 3) — server-rendered, file-based routing
- **[Pinia](https://pinia.vuejs.org)** — journey/progress state
- **[Supabase](https://supabase.com)** — progress sync, event analytics, subscribers
- **[Buttondown](https://buttondown.com)** — newsletter, called server-side only

## Content structure

Experiences are grouped into four tiers, defined in `app/stores/journey.js`:

| Tier | Route prefix | Contents |
| --- | --- | --- |
| Foundation | `/experience/` | The Question, The Objection, Flourishing |
| Arguments | `/experience/` | Human Nature, Human Agency |
| Pillars | `/pillar/` | Five pillars of the philosophy |
| Practices | `/practice/` | Five applied exercises |

Each experience is a page under `app/pages/` that sequences screen components
from `app/components/experiences/<id>/`.

## Project layout

```
app/
  pages/         file-based routes; each calls definePageMeta + usePageSeo
  components/
    experiences/ per-experience screen components
    shared/      nav, cards, dividers, newsletter form
  composables/   useScreenNav, useAnalytics, useScrollReveal, usePageSeo
  stores/        journey.js — progress, completion, tiers
  styles/        tokens, base, typography, animations, mobile
  utils/seo.js   per-route titles and descriptions
server/api/      server routes (secrets live here, never in app/)
archive/         one-off scripts used to generate the original build
```

## Setup

```sh
npm install
cp .env.example .env   # fill in the values below
npm run dev
```

Requires Node 20.19+ or 22.12+.

> `.npmrc` sets `legacy-peer-deps=true` — npm 10.x crashes resolving Nuxt 4's
> peer graph (`Cannot read properties of null (reading 'edgesOut')`).

## Environment

| Variable | Exposed to browser | Purpose |
| --- | --- | --- |
| `NUXT_PUBLIC_SITE_URL` | yes | Canonical/OG URL base |
| `NUXT_PUBLIC_SUPABASE_URL` | yes | Supabase project URL |
| `NUXT_PUBLIC_SUPABASE_ANON_KEY` | yes | Supabase anon key (RLS-protected) |
| `BUTTONDOWN_API_KEY` | **no** | Newsletter API key — server only |
| `SUPABASE_SERVICE_KEY` | **no** | Service-role key — server only |

**Never prefix a secret with `NUXT_PUBLIC_`.** Anything public is compiled into
the client bundle and readable by anyone. Secrets belong in `server/api/`, read
via `useRuntimeConfig()`.

Supabase is optional in development: with no URL/key configured, sync and event
tracking no-op cleanly rather than erroring.

## Commands

```sh
npm run dev        # dev server
npm run build      # production build (.output/)
npm run preview    # serve the production build
npm run generate   # fully static build
npm run lint       # eslint --fix
npm run format     # prettier
```

## Adding an experience

1. Create screen components under `app/components/experiences/<id>/`.
2. Add a page at the route path in `app/pages/`; open its `<script setup>` with
   `definePageMeta({ name: '<id>' })` and `usePageSeo('<id>')`.
3. Add title/description to `app/utils/seo.js`.
4. Add the id to the tier mapping in `getTier()` in `app/stores/journey.js`.
