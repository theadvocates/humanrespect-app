# Database

Postgres on Supabase. Migrations are plain SQL, applied in filename order.

| Migration | Purpose |
| --- | --- |
| `0001_initial_schema.sql` | Tables, indexes, `updated_at` triggers, auto-profile on signup |
| `0002_claim_journey.sql` | Merges an anonymous journey into an account at sign-in |
| `0003_row_level_security.sql` | RLS policies for every table |
| `0004_seed_experience_catalog.sql` | The 15 experiences, tiers, and ordering |
| `0005_certificates.sql` | Tier-completion check, issuance, public verification |

## The identity model

People start anonymous. The browser mints a `visitor_id` (v4 UUID, held in
localStorage) and progress accrues against a `journeys` row with `user_id null`.

When they sign in, the client calls `claim_journey(visitor_id)`. That function:

1. attaches the anonymous journey to the account if it's their first device, or
2. merges it into their existing journey — completions union, earliest
   completion time wins, responses re-pointed, the anonymous row dropped.

Nothing is lost crossing the anonymous/account boundary, which is the point:
the sign-in prompt can come *after* someone has already invested effort.

## Security posture

The anon key ships to every browser, so treat the `anon` role as hostile:

- **No table is readable by `anon`** except the `experiences` catalog.
- `journeys` — anon may insert and update rows where `user_id is null`, but
  never select. A guessed `visitor_id` therefore leaks nothing, and a claimed
  journey leaves the anon policies' scope entirely.
- `events` — insert only, never readable from a client.
- `newsletter_subscribers` — RLS enabled with **zero policies**, so no client
  role can touch it. Only `POST /api/subscribe` writes, using the service key.
- `certificates` — readable only by their owner. Issuance runs through
  `issue_certificate()`, which recomputes completion from the catalog server-side
  instead of trusting a client payload.

RLS applies inside policy subqueries too. Where a policy needs to check a row
the calling role can't see, the check goes through a `security definer` function
that returns only a boolean — see `journey_is_unclaimed()`.

## Applying

With the Supabase CLI, from the repo root:

```sh
supabase link --project-ref <ref>
supabase db push
```

Or paste each file into the SQL editor in dashboard order.

> **Status: written but not yet applied.** These migrations have not been run
> against a live database. Apply `0001` first and check for errors before
> continuing — particularly the `auth.users` trigger in `0001`, which needs the
> Supabase `auth` schema to exist.

## After applying

Enable the auth providers in **Authentication → Providers**:

- **Email** — turn on magic link, turn off "confirm email" (the link *is* the
  confirmation) and off password sign-in.
- **Google** — needs a Google Cloud OAuth client; set the redirect URL to
  `https://<ref>.supabase.co/auth/v1/callback`.

Then add the site URL and redirect allowlist under **Authentication → URL
Configuration**: `https://humanrespect.app` plus `http://localhost:3000` for
development.
