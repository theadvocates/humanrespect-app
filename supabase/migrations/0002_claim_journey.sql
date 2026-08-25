-- Claiming an anonymous journey
--
-- Someone works through several experiences anonymously, then signs in. Their
-- progress must survive that transition. If they already have a journey on the
-- account (they used another device), the two are merged rather than one
-- overwriting the other.

create or replace function public.tier_rank(t text)
returns integer
language sql
immutable
as $$
  select case t
    when 'foundation' then 1
    when 'argument'   then 2
    when 'pillar'     then 3
    when 'practice'   then 4
    else 0
  end;
$$;

-- Tier ordering helper, mirroring TIER_ORDER in app/stores/journey.js.
create or replace function public.furthest_tier(a text, b text)
returns text
language sql
immutable
as $$
  select case
    when public.tier_rank(a) >= public.tier_rank(b) then a
    else b
  end;
$$;

create or replace function public.claim_journey(p_visitor_id uuid)
returns public.journeys
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id  uuid := auth.uid();
  v_anon     public.journeys;
  v_existing public.journeys;
  v_result   public.journeys;
begin
  if v_user_id is null then
    raise exception 'claim_journey requires an authenticated user'
      using errcode = '42501';
  end if;

  select * into v_anon
    from public.journeys
   where visitor_id = p_visitor_id
     and user_id is null
   for update;

  select * into v_existing
    from public.journeys
   where user_id = v_user_id
   order by created_at
   limit 1
   for update;

  -- Nothing anonymous to claim: hand back whatever the account already has.
  if v_anon.id is null then
    return v_existing;
  end if;

  -- First device for this account: simply attach it.
  if v_existing.id is null then
    update public.journeys
       set user_id    = v_user_id,
           claimed_at = now()
     where id = v_anon.id
    returning * into v_result;
    return v_result;
  end if;

  -- Merge. Completions union; for timestamps the earlier one wins, since it
  -- records when the person actually first finished that experience.
  update public.journeys
     set completions = v_existing.completions || v_anon.completions,
         completion_times = (
           select coalesce(jsonb_object_agg(key, value), '{}'::jsonb)
             from (
               select key, min(value #>> '{}') as value
                 from (
                   select * from jsonb_each(v_existing.completion_times)
                   union all
                   select * from jsonb_each(v_anon.completion_times)
                 ) all_times
               group by key
             ) merged
         ),
         total_experiences = (
           select count(*)
             from jsonb_each(v_existing.completions || v_anon.completions)
            where value = 'true'::jsonb
         ),
         last_experience = coalesce(
           case when v_anon.last_visit >= coalesce(v_existing.last_visit, 'epoch'::timestamptz)
                then v_anon.last_experience end,
           v_existing.last_experience
         ),
         furthest_tier = public.furthest_tier(
           v_existing.furthest_tier, v_anon.furthest_tier
         ),
         first_visit = least(
           coalesce(v_existing.first_visit, v_anon.first_visit),
           coalesce(v_anon.first_visit, v_existing.first_visit)
         ),
         last_visit = greatest(
           coalesce(v_existing.last_visit, v_anon.last_visit),
           coalesce(v_anon.last_visit, v_existing.last_visit)
         ),
         claimed_at = coalesce(v_existing.claimed_at, now())
   where id = v_existing.id
  returning * into v_result;

  -- Re-point the anonymous responses at the surviving journey, then drop it.
  update public.experience_responses
     set journey_id = v_existing.id
   where journey_id = v_anon.id
     and not exists (
       select 1 from public.experience_responses e
        where e.journey_id = v_existing.id
          and e.experience_id = experience_responses.experience_id
          and e.question_key = experience_responses.question_key
     );

  delete from public.journeys where id = v_anon.id;

  return v_result;
end;
$$;

revoke all on function public.claim_journey(uuid) from public, anon;
grant execute on function public.claim_journey(uuid) to authenticated;
