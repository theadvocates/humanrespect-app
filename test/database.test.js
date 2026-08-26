import { describe, it, expect, beforeAll } from 'vitest'

/**
 * Database tests against a disposable Supabase project.
 *
 * claim_journey is the most intricate thing in the schema and the most
 * expensive to get wrong: it decides what happens to someone's progress at the
 * moment they sign in. Until now it had been verified exactly once, by hand,
 * in a rolled-back transaction against production.
 *
 * Branching needs the Pro plan, so this points at a separate free project
 * (`humanrespect-test`) whose schema is asserted identical to production's.
 * Every test runs inside a transaction that is rolled back, so the tests are
 * order-independent and leave nothing behind.
 *
 * Skipped when unconfigured, so CI without the secret still passes.
 */

const REF = process.env.SUPABASE_TEST_REF || 'mmsmdamtsimzxcisppww'
const TOKEN = process.env.SUPABASE_ACCESS_TOKEN
const enabled = Boolean(TOKEN)

async function sql(query) {
  const res = await fetch(`https://api.supabase.com/v1/projects/${REF}/database/query`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${TOKEN}`,
      'Content-Type': 'application/json',
      'User-Agent': 'humanrespect-tests/1.0'
    },
    body: JSON.stringify({ query })
  })
  const text = await res.text()
  if (!res.ok) throw new Error(`SQL failed: ${text.slice(0, 300)}`)
  return text ? JSON.parse(text) : []
}

/**
 * Runs statements inside a transaction that is always rolled back.
 *
 * The management API returns only the final statement's rows, flat — not one
 * result set per statement — so each test ends with the single SELECT it
 * asserts on.
 */
function inRollback(body) {
  return sql(`begin;\n${body}\nrollback;`)
}

const USER = '11111111-1111-1111-1111-111111111111'
const OTHER = '22222222-2222-2222-2222-222222222222'

const makeUser = (id, email) => `
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, created_at, updated_at)
values ('${id}', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
        '${email}', 'x', now(), now());`

const asUser = (id) => `set local request.jwt.claims = '{"sub":"${id}"}';`

describe.skipIf(!enabled)('claim_journey', () => {
  beforeAll(async () => {
    const rows = await sql("select count(*)::int as n from public.experiences")
    expect(rows[0].n, 'test database is not migrated').toBe(15)
  })

  it('attaches an anonymous journey when the account has none', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'first@example.invalid')}
      insert into public.journeys (visitor_id, completions, total_experiences)
      values ('aaaaaaaa-0000-0000-0000-000000000001', '{"exp01":true}'::jsonb, 1);
      ${asUser(USER)}
      select (user_id = '${USER}') as attached, (claimed_at is not null) as stamped,
             total_experiences
        from public.claim_journey('aaaaaaaa-0000-0000-0000-000000000001');`)
    const r = out[0]
    expect(r.attached).toBe(true)
    expect(r.stamped).toBe(true)
    expect(r.total_experiences).toBe(1)
  })

  it('merges two devices without losing either', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'merge@example.invalid')}
      insert into public.journeys (visitor_id, completions, completion_times, furthest_tier,
                                   total_experiences, first_visit, last_visit, last_experience)
      values ('aaaaaaaa-0000-0000-0000-000000000001', '{"exp01":true}'::jsonb,
              '{"exp01":"2026-01-01T00:00:00Z"}'::jsonb, 'foundation', 1,
              '2026-01-01', '2026-01-02', 'exp01');
      insert into public.journeys (visitor_id, user_id, completions, completion_times, furthest_tier,
                                   total_experiences, first_visit, last_visit, last_experience)
      values ('aaaaaaaa-0000-0000-0000-000000000002', '${USER}',
              '{"exp02":true,"pillarA":true}'::jsonb,
              '{"exp02":"2026-02-01T00:00:00Z","pillarA":"2026-02-02T00:00:00Z"}'::jsonb,
              'pillar', 2, '2026-01-15', '2026-02-02', 'pillarA');
      ${asUser(USER)}
      select visitor_id::text, completions, completion_times, furthest_tier,
             total_experiences, first_visit::text, last_visit::text
        from public.claim_journey('aaaaaaaa-0000-0000-0000-000000000001');`)
    const r = out[0]

    // Nothing from either device may be dropped.
    expect(Object.keys(r.completions).sort()).toEqual(['exp01', 'exp02', 'pillarA'])
    expect(r.total_experiences).toBe(3)

    // The higher tier survives — a device that is behind must not demote it.
    expect(r.furthest_tier).toBe('pillar')

    // Earliest first visit, latest last visit.
    expect(r.first_visit).toMatch(/^2026-01-01/)
    expect(r.last_visit).toMatch(/^2026-02-02/)

    // The account's existing row survives, which is why applyRemote() adopts
    // the returned visitor_id — writing to the old one would resurrect it.
    expect(r.visitor_id).toBe('aaaaaaaa-0000-0000-0000-000000000002')
  })

  it('keeps the earliest completion time for an experience done on both devices', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'times@example.invalid')}
      insert into public.journeys (visitor_id, completions, completion_times, total_experiences)
      values ('aaaaaaaa-0000-0000-0000-000000000001', '{"exp01":true}'::jsonb,
              '{"exp01":"2026-01-01T00:00:00Z"}'::jsonb, 1);
      insert into public.journeys (visitor_id, user_id, completions, completion_times, total_experiences)
      values ('aaaaaaaa-0000-0000-0000-000000000002', '${USER}', '{"exp01":true}'::jsonb,
              '{"exp01":"2026-06-01T00:00:00Z"}'::jsonb, 1);
      ${asUser(USER)}
      select completion_times from public.claim_journey('aaaaaaaa-0000-0000-0000-000000000001');`)
    // January, not June: the timestamp records when they actually first
    // finished it, so the later one must not win.
    expect(out[0].completion_times.exp01).toMatch(/^2026-01-01/)
  })

  it('removes the anonymous row after a merge', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'cleanup@example.invalid')}
      insert into public.journeys (visitor_id, completions) values
        ('aaaaaaaa-0000-0000-0000-000000000001', '{"exp01":true}'::jsonb);
      insert into public.journeys (visitor_id, user_id, completions) values
        ('aaaaaaaa-0000-0000-0000-000000000002', '${USER}', '{"exp02":true}'::jsonb);
      ${asUser(USER)}
      select public.claim_journey('aaaaaaaa-0000-0000-0000-000000000001');
      reset role;
      select count(*)::int as leftover from public.journeys
       where visitor_id = 'aaaaaaaa-0000-0000-0000-000000000001';`)
    expect(out[0].leftover).toBe(0)
  })

  it('refuses to run without an authenticated user', async () => {
    await expect(inRollback(`
      insert into public.journeys (visitor_id) values ('aaaaaaaa-0000-0000-0000-000000000009');
      select public.claim_journey('aaaaaaaa-0000-0000-0000-000000000009');`))
      .rejects.toThrow(/authenticated/i)
  })

  it('will not claim a journey that already belongs to someone else', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'a@example.invalid')}
      ${makeUser(OTHER, 'b@example.invalid')}
      insert into public.journeys (visitor_id, user_id, completions)
      values ('aaaaaaaa-0000-0000-0000-000000000003', '${OTHER}', '{"exp01":true}'::jsonb);
      ${asUser(USER)}
      select public.claim_journey('aaaaaaaa-0000-0000-0000-000000000003');
      reset role;
      select user_id::text from public.journeys
       where visitor_id = 'aaaaaaaa-0000-0000-0000-000000000003';`)
    // claim_journey only selects rows where user_id is null, so the other
    // person's journey must be untouched.
    expect(out[0].user_id).toBe(OTHER)
  })
})

describe.skipIf(!enabled)('sync_journey', () => {
  it('merges rather than replaces, so a stale device cannot erase progress', async () => {
    const out = await inRollback(`
      set local role anon;
      select public.sync_journey('bbbbbbbb-0000-0000-0000-000000000001'::uuid,
        '{"exp01":true,"exp02":true}'::jsonb, '{}'::jsonb, 'exp02', 'argument', 2, now(), now());
      select public.sync_journey('bbbbbbbb-0000-0000-0000-000000000001'::uuid,
        '{"exp03":true}'::jsonb, '{}'::jsonb, 'exp03', 'foundation', 1, now(), now());
      reset role;
      select completions, furthest_tier, total_experiences from public.journeys
       where visitor_id = 'bbbbbbbb-0000-0000-0000-000000000001';`)
    const r = out[0]
    expect(Object.keys(r.completions).sort()).toEqual(['exp01', 'exp02', 'exp03'])
    // The second call reported a lower tier and count; neither may regress.
    expect(r.furthest_tier).toBe('argument')
    expect(r.total_experiences).toBe(2)
  })

  it('refuses to write to a journey owned by another account', async () => {
    await expect(inRollback(`
      ${makeUser(OTHER, 'owner@example.invalid')}
      insert into public.journeys (visitor_id, user_id) values
        ('bbbbbbbb-0000-0000-0000-000000000002', '${OTHER}');
      set local role anon;
      select public.sync_journey('bbbbbbbb-0000-0000-0000-000000000002'::uuid,
        '{"exp01":true}'::jsonb, '{}'::jsonb, null, null, 1, now(), now());`))
      .rejects.toThrow(/another account/i)
  })
})

describe.skipIf(!enabled)('row level security', () => {
  it('shows the anon role nothing in journeys, events or subscribers', async () => {
    const out = await inRollback(`
      insert into public.journeys (visitor_id) values ('cccccccc-0000-0000-0000-000000000001');
      insert into public.events (visitor_id, event_name) values ('cccccccc-0000-0000-0000-000000000001','t');
      insert into public.newsletter_subscribers (email) values ('rls@example.invalid');
      set local role anon;
      select (select count(*)::int from public.journeys) as journeys,
             (select count(*)::int from public.events) as events,
             (select count(*)::int from public.newsletter_subscribers) as subscribers;`)
    const r = out[0]
    expect(r.journeys, 'anon can read journeys').toBe(0)
    expect(r.events, 'anon can read events').toBe(0)
    expect(r.subscribers, 'anon can read subscribers').toBe(0)
  })

  it('lets the anon role read the published experience catalogue', async () => {
    const out = await inRollback(`
      set local role anon;
      select count(*)::int as n from public.experiences;`)
    expect(out[0].n).toBe(15)
  })

  it('does not let the anon role delete journeys', async () => {
    const out = await inRollback(`
      insert into public.journeys (visitor_id) values ('cccccccc-0000-0000-0000-000000000002');
      set local role anon;
      delete from public.journeys;
      reset role;
      select count(*)::int as remaining from public.journeys
       where visitor_id = 'cccccccc-0000-0000-0000-000000000002';`)
    expect(out[0].remaining, 'anon deleted a journey').toBe(1)
  })
})

describe.skipIf(!enabled)('certificates', () => {
  it('refuses to issue one before the tier is complete', async () => {
    await expect(inRollback(`
      ${makeUser(USER, 'incomplete@example.invalid')}
      insert into public.journeys (visitor_id, user_id, completions)
      values ('dddddddd-0000-0000-0000-000000000001', '${USER}', '{"exp01":true}'::jsonb);
      ${asUser(USER)}
      select public.issue_certificate('foundation');`))
      .rejects.toThrow(/not complete/i)
  })

  it('issues one with a URL-safe code once the tier is finished', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'complete@example.invalid')}
      insert into public.journeys (visitor_id, user_id, completions)
      values ('dddddddd-0000-0000-0000-000000000002', '${USER}',
              '{"exp01":true,"exp02":true,"exp03":true}'::jsonb);
      ${asUser(USER)}
      select recipient_name, public_code, tier::text from public.issue_certificate('foundation');`)
    const r = out[0]
    expect(r.tier).toBe('foundation')
    expect(r.recipient_name).toBe('complete')
    // Hex, not base64 — base64 emits / and + which break in a URL path.
    expect(r.public_code).toMatch(/^[0-9a-f]{18}$/)
  })

  it('lets anyone verify a certificate they have the code for', async () => {
    // The code is stashed with set_config while still privileged, because anon
    // cannot read the certificates table — which is the point of the next test.
    // The real page passes the code in from the URL, exactly like this.
    const out = await inRollback(`
      ${makeUser(USER, 'verify@example.invalid')}
      insert into public.journeys (visitor_id, user_id, completions)
      values ('dddddddd-0000-0000-0000-000000000003', '${USER}',
              '{"exp01":true,"exp02":true,"exp03":true}'::jsonb);
      ${asUser(USER)}
      select public.issue_certificate('foundation');
      select set_config('test.code', (select public_code from public.certificates limit 1), true);
      set local role anon;
      select recipient_name, tier::text as tier, (issued_at is not null) as dated
        from public.verify_certificate(current_setting('test.code'));`)

    const r = out[0]
    expect(r, 'anon could not verify a genuine certificate by code').toBeDefined()
    expect(r.recipient_name).toBe('verify')
    expect(r.tier).toBe('foundation')
    expect(r.dated).toBe(true)
    // Verification returns only what a public page needs — never the owner.
    expect(r).not.toHaveProperty('user_id')
  })

  it('does not let anyone enumerate certificates', async () => {
    const out = await inRollback(`
      ${makeUser(USER, 'enum@example.invalid')}
      insert into public.journeys (visitor_id, user_id, completions)
      values ('dddddddd-0000-0000-0000-000000000005', '${USER}',
              '{"exp01":true,"exp02":true,"exp03":true}'::jsonb);
      ${asUser(USER)}
      select public.issue_certificate('foundation');
      set local role anon;
      select count(*)::int as visible from public.certificates;`)
    // A certificate is verifiable by code but must not be discoverable —
    // otherwise the codes could simply be listed.
    expect(out[0].visible).toBe(0)
  })

  it('returns nothing for a code that was never issued', async () => {
    const out = await inRollback(`
      set local role anon;
      select count(*)::int as found
        from public.verify_certificate('deadbeefdeadbeef00');`)
    expect(out[0].found).toBe(0)
  })
})
