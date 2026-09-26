-- Where everyone's two scores landed, for the crowd on the map version of
-- the test's result screen.
--
-- Same rules as test_result_counts: each visitor counts once, by their latest
-- result, and only the given test version is counted. Returns one row per
-- (directly, others) pair that anyone has landed on, so the page can draw a
-- faint dot for each, sized by how many.
--
-- Callable by the service role only. The page reads it through
-- /api/test-stats, which caches it and withholds it below a minimum sample.

create or replace function public.test_score_counts(p_version int default 2)
returns table (directly int, others int, visitors bigint)
language sql
stable
security definer
set search_path = public
as $$
  select latest.directly, latest.others, count(*)::bigint as visitors
  from (
    select distinct on (e.visitor_id)
      (e.properties->>'directly')::int as directly,
      (e.properties->>'others')::int as others
    from public.events e
    where e.event_name = 'choice_made'
      and e.properties->>'experience' = 'test'
      and e.properties->>'question' = 'result'
      and e.properties->>'version' = p_version::text
      and e.properties->>'directly' ~ '^\d+$'
      and e.properties->>'others' ~ '^\d+$'
      and e.visitor_id is not null
    order by e.visitor_id, e.created_at desc
  ) latest
  group by latest.directly, latest.others;
$$;

revoke all on function public.test_score_counts(int) from public, anon, authenticated;
grant execute on function public.test_score_counts(int) to service_role;
