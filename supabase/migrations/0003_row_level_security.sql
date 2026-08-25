-- Row Level Security
--
-- The anon key ships to every browser, so anything reachable with it is
-- effectively public. The rules below assume the anon role is hostile and
-- grant it the narrowest surface that still lets anonymous progress work:
-- write your own journey, append events, read the catalog. No reads of
-- anyone's data, ever.

-- ── Remove the legacy policies first ────────────────────────────────────────
-- The live database carries three policies from the original build. The one on
-- journeys is a data exposure: cmd=ALL, USING=true, WITH CHECK=true for the
-- `public` role, meaning anyone holding the anon key (which ships in the
-- browser by design) can read, modify, or delete every visitor's journey.
-- Despite its name it scopes nothing to the visitor.
--
-- The currently deployed site only ever calls .upsert() on journeys and never
-- .select(), so removing the read path does not break it.

-- Only the journeys policy is dropped. The other two are INSERT-only with no
-- USING clause, so they expose nothing readable, and the still-live Cloudflare
-- site depends on them: it inserts events and newsletter signups straight from
-- the browser with the anon key. Removing them would break the running site.
drop policy if exists "Visitors can upsert own journey" on public.journeys;

alter table public.profiles              enable row level security;
alter table public.experiences           enable row level security;
alter table public.journeys              enable row level security;
alter table public.experience_responses  enable row level security;
alter table public.events                enable row level security;
alter table public.newsletter_subscribers enable row level security;
alter table public.certificates          enable row level security;

-- ── Profiles: yours and only yours ──────────────────────────────────────────

drop policy if exists profiles_select_own on public.profiles;
create policy profiles_select_own on public.profiles
  for select to authenticated
  using (auth.uid() = id);

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ── Experience catalog: public, read-only ───────────────────────────────────

drop policy if exists experiences_read_published on public.experiences;
create policy experiences_read_published on public.experiences
  for select to anon, authenticated
  using (published);

-- ── Journeys ────────────────────────────────────────────────────────────────
-- Anonymous visitors may create and update an unclaimed journey. The visitor_id
-- is a v4 UUID held only by that browser; it is unguessable in practice, which
-- is the same trust model the app had before. Crucially anon cannot SELECT, so
-- a guessed id leaks nothing — and once claimed, user_id is null no longer and
-- the anon policies stop applying entirely.

drop policy if exists journeys_anon_insert on public.journeys;
create policy journeys_anon_insert on public.journeys
  for insert to anon
  with check (user_id is null);

drop policy if exists journeys_anon_update on public.journeys;
create policy journeys_anon_update on public.journeys
  for update to anon
  using (user_id is null)
  with check (user_id is null);

drop policy if exists journeys_owner_all on public.journeys;
create policy journeys_owner_all on public.journeys
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Signed-in users still need to write their unclaimed row in the moment
-- between authenticating and claim_journey() running.
drop policy if exists journeys_auth_insert_unclaimed on public.journeys;
create policy journeys_auth_insert_unclaimed on public.journeys
  for insert to authenticated
  with check (user_id is null or user_id = auth.uid());

-- ── Experience responses ────────────────────────────────────────────────────

-- RLS applies inside policy subqueries too, and anon has no select policy on
-- journeys — so an inline EXISTS here would always be false and every
-- anonymous response would be rejected. A definer function does the lookup
-- with RLS bypassed, while still only ever returning a boolean.
create or replace function public.journey_is_unclaimed(p_journey_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.journeys
     where id = p_journey_id and user_id is null
  );
$$;

grant execute on function public.journey_is_unclaimed(bigint) to anon, authenticated;

drop policy if exists responses_anon_insert on public.experience_responses;
create policy responses_anon_insert on public.experience_responses
  for insert to anon
  with check (public.journey_is_unclaimed(journey_id));

drop policy if exists responses_owner_all on public.experience_responses;
create policy responses_owner_all on public.experience_responses
  for all to authenticated
  using (
    exists (
      select 1 from public.journeys j
       where j.id = journey_id and j.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.journeys j
       where j.id = journey_id and j.user_id = auth.uid()
    )
  );

-- ── Events: append-only, never readable from the client ─────────────────────

-- The legacy "Anyone can insert events" policy already covers the anon role
-- for the live Cloudflare site; this adds the same for signed-in users.
drop policy if exists events_insert on public.events;
create policy events_insert on public.events
  for insert to anon, authenticated
  with check (true);

-- No select/update/delete policy: analytics is read via the service key only.

-- ── Newsletter ──────────────────────────────────────────────────────────────
-- The Nuxt app writes through POST /api/subscribe with the service key, which
-- needs no policy. But the legacy Cloudflare site still inserts from the
-- browser, so its INSERT-only policy ("Anyone can subscribe") is deliberately
-- left in place. It permits no reads, so subscriber addresses stay private.
--
-- TODO: after DNS moves to Vercel and the Cloudflare deployment is retired,
-- drop that policy so this table is reachable only by the service key:
--   drop policy "Anyone can subscribe" on public.newsletter_subscribers;
--   drop policy "Anyone can insert events" on public.events;

-- ── Certificates ────────────────────────────────────────────────────────────

drop policy if exists certificates_select_own on public.certificates;
create policy certificates_select_own on public.certificates
  for select to authenticated
  using (user_id = auth.uid());

-- Issuance goes through a definer function so the criteria can't be forged.
