-- Certificate issuance
--
-- Completion is recomputed from the catalog on the server rather than trusted
-- from the client, so a certificate can't be claimed by posting a payload.

create or replace function public.tier_progress(p_tier public.experience_tier)
returns table (completed integer, total integer)
language sql
stable
security definer
set search_path = public
as $$
  with required as (
    select id from public.experiences
     where tier = p_tier and published
  ),
  journey as (
    select completions from public.journeys
     where user_id = auth.uid()
     order by created_at
     limit 1
  )
  select
    (select count(*)::integer from required r, journey j
      where j.completions -> r.id = 'true'::jsonb),
    (select count(*)::integer from required);
$$;

create or replace function public.issue_certificate(p_tier public.experience_tier)
returns public.certificates
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_done    integer;
  v_total   integer;
  v_name    text;
  v_cert    public.certificates;
begin
  if v_user_id is null then
    raise exception 'issue_certificate requires an authenticated user'
      using errcode = '42501';
  end if;

  select completed, total into v_done, v_total
    from public.tier_progress(p_tier);

  if v_total = 0 or v_done < v_total then
    raise exception 'tier % is not complete (% of %)', p_tier, v_done, v_total
      using errcode = 'P0001';
  end if;

  select coalesce(nullif(trim(display_name), ''), split_part(email, '@', 1))
    into v_name
    from public.profiles
   where id = v_user_id;

  if v_name is null or v_name = '' then
    raise exception 'a display name is required before a certificate can be issued'
      using errcode = 'P0001';
  end if;

  insert into public.certificates (user_id, tier, recipient_name)
  values (v_user_id, p_tier, v_name)
  on conflict (user_id, tier) do update
    set recipient_name = excluded.recipient_name
  returning * into v_cert;

  return v_cert;
end;
$$;

-- Public verification: given a code, confirm the certificate is genuine.
-- Deliberately returns only what a verification page needs — never the user_id.
create or replace function public.verify_certificate(p_code text)
returns table (recipient_name text, tier public.experience_tier, issued_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select c.recipient_name, c.tier, c.issued_at
    from public.certificates c
   where c.public_code = p_code;
$$;

revoke all on function public.issue_certificate(public.experience_tier) from public, anon;
grant execute on function public.issue_certificate(public.experience_tier) to authenticated;

revoke all on function public.tier_progress(public.experience_tier) from public, anon;
grant execute on function public.tier_progress(public.experience_tier) to authenticated;

grant execute on function public.verify_certificate(text) to anon, authenticated;
