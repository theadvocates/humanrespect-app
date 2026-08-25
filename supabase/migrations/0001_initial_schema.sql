-- Human Respect — core schema
--
-- Design note on identity: people start anonymous. The browser mints a
-- visitor_id and progress accrues against it. When they later sign in, that
-- row is claimed by setting user_id. Nothing is lost at the boundary.

create extension if not exists "pgcrypto";

-- ── Profiles ────────────────────────────────────────────────────────────────
-- Mirrors auth.users with the app-level fields we control.

create table if not exists public.profiles (
  id           uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  email        text,
  email_opt_in boolean     not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on table public.profiles is
  'App-level user record, one row per auth.users entry.';

-- ── Experience catalog ──────────────────────────────────────────────────────
-- The course structure, in data rather than hardcoded in getTier(). Lets us
-- reorder the curriculum, add experiences, and compute completion without
-- shipping new code.

create type public.experience_tier as enum ('foundation', 'argument', 'pillar', 'practice');

create table if not exists public.experiences (
  id                 text primary key,               -- 'exp01', 'pillarA', ...
  slug               text not null unique,           -- '/experience/the-question'
  title              text not null,
  description        text,
  tier               public.experience_tier not null,
  sort_order         integer not null default 0,
  estimated_minutes  integer not null default 5,
  screen_count       integer,
  required_for_cert  boolean not null default false,
  published          boolean not null default true,
  created_at         timestamptz not null default now()
);

create index if not exists experiences_tier_order_idx
  on public.experiences (tier, sort_order);

-- ── Journeys ────────────────────────────────────────────────────────────────
-- One row per visitor. user_id is null until the journey is claimed.

create table if not exists public.journeys (
  id                 uuid primary key default gen_random_uuid(),
  visitor_id         uuid not null unique,
  user_id            uuid references auth.users (id) on delete set null,

  completions        jsonb       not null default '{}'::jsonb,
  completion_times   jsonb       not null default '{}'::jsonb,
  last_experience    text,
  furthest_tier      text        not null default 'none',
  total_experiences  integer     not null default 0,

  first_visit        timestamptz,
  last_visit         timestamptz,
  claimed_at         timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create index if not exists journeys_user_id_idx on public.journeys (user_id);
create index if not exists journeys_last_visit_idx on public.journeys (last_visit desc);

-- ── Experience responses ────────────────────────────────────────────────────
-- The answers themselves, normalized out of the journey blob. This is what
-- makes "how did others answer this?" and per-question analytics possible.

create table if not exists public.experience_responses (
  id             uuid primary key default gen_random_uuid(),
  journey_id     uuid not null references public.journeys (id) on delete cascade,
  experience_id  text not null,
  question_key   text not null,
  response       jsonb not null,
  created_at     timestamptz not null default now(),

  unique (journey_id, experience_id, question_key)
);

create index if not exists experience_responses_experience_idx
  on public.experience_responses (experience_id, question_key);

-- ── Events ──────────────────────────────────────────────────────────────────
-- Append-only analytics stream. Write-only from the client.

create table if not exists public.events (
  id          bigint generated always as identity primary key,
  visitor_id  uuid,
  user_id     uuid references auth.users (id) on delete set null,
  event_name  text not null,
  properties  jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);

create index if not exists events_name_created_idx on public.events (event_name, created_at desc);
create index if not exists events_visitor_idx on public.events (visitor_id);

-- ── Newsletter ──────────────────────────────────────────────────────────────
-- Written only by the server (service key). No client access at all.

create table if not exists public.newsletter_subscribers (
  id             uuid primary key default gen_random_uuid(),
  email          text not null unique,
  source         text,
  visitor_id     uuid,
  user_id        uuid references auth.users (id) on delete set null,
  subscribed_at  timestamptz not null default now(),
  unsubscribed_at timestamptz
);

-- ── Certificates ────────────────────────────────────────────────────────────
-- Issued when a tier's required experiences are complete. Requires an account,
-- since a certificate needs a name and a durable identity.

create table if not exists public.certificates (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users (id) on delete cascade,
  tier          public.experience_tier not null,
  recipient_name text not null,
  issued_at     timestamptz not null default now(),
  public_code   text not null unique default encode(gen_random_bytes(9), 'hex'),

  unique (user_id, tier)
);

comment on column public.certificates.public_code is
  'Shareable verification code for a public certificate page.';

-- ── updated_at maintenance ──────────────────────────────────────────────────

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists journeys_touch_updated_at on public.journeys;
create trigger journeys_touch_updated_at
  before update on public.journeys
  for each row execute function public.touch_updated_at();

drop trigger if exists profiles_touch_updated_at on public.profiles;
create trigger profiles_touch_updated_at
  before update on public.profiles
  for each row execute function public.touch_updated_at();

-- ── Profile provisioning ────────────────────────────────────────────────────
-- Every new auth user gets a profile row automatically.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
