-- Rate limiting that survives serverless
--
-- The first version of /api/subscribe kept an in-memory Map. On Vercel (and
-- any serverless host) each function instance has its own memory and instances
-- are recycled, so that limiter is per-instance and effectively unenforced.
-- Postgres is the one piece of shared state every instance already has.

create table if not exists public.rate_limits (
  bucket      text        not null,
  identifier  text        not null,
  window_start timestamptz not null,
  count       integer     not null default 1,

  primary key (bucket, identifier, window_start)
);

create index if not exists rate_limits_window_idx on public.rate_limits (window_start);

alter table public.rate_limits enable row level security;
-- No policies: only the service key touches this table.

/**
 * Records a hit and reports whether the caller has exceeded the limit.
 * Windows are fixed rather than sliding — cheaper, and precise enough here.
 */
create or replace function public.check_rate_limit(
  p_bucket      text,
  p_identifier  text,
  p_max         integer,
  p_window_secs integer
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_window timestamptz := to_timestamp(
    floor(extract(epoch from now()) / p_window_secs) * p_window_secs
  );
  v_count integer;
begin
  insert into public.rate_limits (bucket, identifier, window_start, count)
  values (p_bucket, p_identifier, v_window, 1)
  on conflict (bucket, identifier, window_start)
    do update set count = public.rate_limits.count + 1
  returning count into v_count;

  -- Opportunistic cleanup so the table cannot grow without bound.
  if random() < 0.01 then
    delete from public.rate_limits where window_start < now() - interval '1 day';
  end if;

  return v_count <= p_max;
end;
$$;

revoke all on function public.check_rate_limit(text, text, integer, integer) from public, anon, authenticated;
