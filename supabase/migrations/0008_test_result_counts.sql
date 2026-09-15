-- How results of the short test are distributed, for the "N% landed here"
-- line on the result screen.
--
-- Each visitor counts once, by their latest result, so retaking the test
-- doesn't inflate a result. Only the given test version is counted: version 2
-- reverse-keyed four statements, so version 1 scores aren't comparable.
--
-- Callable by the service role only. The page reads it through
-- /api/test-stats, which caches it and withholds it below a minimum sample.

create or replace function public.test_result_counts(p_version int default 2)
returns table (result text, visitors bigint)
language sql
stable
security definer
set search_path = public
as $$
  select latest.result, count(*)::bigint as visitors
  from (
    select distinct on (e.visitor_id) e.properties->>'result' as result
    from public.events e
    where e.event_name = 'choice_made'
      and e.properties->>'experience' = 'test'
      and e.properties->>'question' = 'result'
      and e.properties->>'version' = p_version::text
      and e.visitor_id is not null
    order by e.visitor_id, e.created_at desc
  ) latest
  where latest.result is not null
  group by latest.result;
$$;

revoke all on function public.test_result_counts(int) from public, anon, authenticated;
grant execute on function public.test_result_counts(int) to service_role;
