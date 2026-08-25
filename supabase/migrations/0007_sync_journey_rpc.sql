-- Journey sync through a function instead of a direct upsert
--
-- PostgreSQL requires a SELECT policy that makes the conflicting row visible
-- before it will run INSERT ... ON CONFLICT DO UPDATE — which is exactly what
-- supabase-js .upsert() emits. The only SELECT policy that satisfies it here
-- (`user_id is null`) would expose every unclaimed journey to anyone holding
-- the anon key, which is the hole 0003 exists to close.
--
-- Routing writes through a security definer function resolves the conflict:
-- the upsert runs inside the function with RLS bypassed, while anon keeps no
-- read access to the table whatsoever. It also lets us validate the payload
-- rather than trusting whatever the client posts.
--
-- The trust model for visitor_id is unchanged: it is a v4 UUID held only by
-- that browser. Unguessable in practice, and a guess still reveals nothing
-- because the function returns no journey data.

create or replace function public.sync_journey(
  p_visitor_id        uuid,
  p_completions       jsonb       default '{}'::jsonb,
  p_completion_times  jsonb       default '{}'::jsonb,
  p_last_experience   text        default null,
  p_furthest_tier     text        default null,
  p_total_experiences integer     default null,
  p_first_visit       timestamptz default null,
  p_last_visit        timestamptz default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner uuid;
begin
  if p_visitor_id is null then
    raise exception 'visitor_id is required' using errcode = '22004';
  end if;

  select user_id into v_owner
    from public.journeys
   where visitor_id = p_visitor_id;

  -- Once a journey belongs to an account, only that account may write to it.
  -- Without this, knowing a visitor_id would let anyone overwrite a signed-in
  -- person's progress.
  if v_owner is not null and v_owner is distinct from auth.uid() then
    raise exception 'this journey belongs to another account'
      using errcode = '42501';
  end if;

  insert into public.journeys as j (
    visitor_id, completions, completion_times, last_experience,
    furthest_tier, total_experiences, first_visit, last_visit
  )
  values (
    p_visitor_id,
    coalesce(p_completions, '{}'::jsonb),
    coalesce(p_completion_times, '{}'::jsonb),
    p_last_experience,
    coalesce(p_furthest_tier, 'none'),
    coalesce(p_total_experiences, 0),
    p_first_visit,
    coalesce(p_last_visit, now())
  )
  on conflict (visitor_id) do update set
    -- Merge rather than replace: a device that is behind must not erase
    -- progress another device has already synced.
    completions       = j.completions || coalesce(excluded.completions, '{}'::jsonb),
    completion_times  = j.completion_times || coalesce(excluded.completion_times, '{}'::jsonb),
    last_experience   = coalesce(excluded.last_experience, j.last_experience),
    furthest_tier     = public.furthest_tier(j.furthest_tier, excluded.furthest_tier),
    total_experiences = greatest(coalesce(excluded.total_experiences, 0),
                                 coalesce(j.total_experiences, 0)),
    first_visit       = least(coalesce(j.first_visit, excluded.first_visit),
                              coalesce(excluded.first_visit, j.first_visit)),
    last_visit        = greatest(coalesce(excluded.last_visit, j.last_visit),
                                 coalesce(j.last_visit, excluded.last_visit));
end;
$$;

revoke all on function public.sync_journey(uuid, jsonb, jsonb, text, text, integer, timestamptz, timestamptz) from public;
grant execute on function public.sync_journey(uuid, jsonb, jsonb, text, text, integer, timestamptz, timestamptz) to anon, authenticated;

-- Events go through a function too, so the table needs no anon INSERT policy
-- once the legacy site is retired.
create or replace function public.record_event(
  p_visitor_id uuid,
  p_event_name text,
  p_properties jsonb default '{}'::jsonb
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_event_name is null or length(p_event_name) > 64 then
    raise exception 'invalid event name' using errcode = '22023';
  end if;

  insert into public.events (visitor_id, user_id, event_name, properties)
  values (p_visitor_id, auth.uid(), p_event_name, coalesce(p_properties, '{}'::jsonb));
end;
$$;

revoke all on function public.record_event(uuid, text, jsonb) from public;
grant execute on function public.record_event(uuid, text, jsonb) to anon, authenticated;

-- The anon insert/update policies on journeys are deliberately left in place
-- for now. They are harmless (neither grants a read), and the legacy
-- Cloudflare site still writes directly.
--
-- TODO: after DNS moves to Vercel and the legacy site is retired, drop them so
-- the validated functions are the only anon-reachable write path:
--   drop policy journeys_anon_insert on public.journeys;
--   drop policy journeys_anon_update on public.journeys;
--   drop policy "Anyone can insert events" on public.events;
--   drop policy "Anyone can subscribe" on public.newsletter_subscribers;
