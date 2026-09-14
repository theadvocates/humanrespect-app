/**
 * Partner versions of the short test.
 *
 * The statements and the scoring never change by partner — a score from one
 * audience has to mean the same thing as a score from another, or the numbers
 * stop being comparable and the share loop starts spreading different tests
 * under one name. What changes is the framing around them: the intro, one
 * extra line on each result, and where the result sends people next.
 *
 * A partner is chosen by, in order: ?partner=, then utm_source, then the
 * referring host. The first two are in the URL, so the server renders the
 * partner's intro and there is no flash of the default copy. The referrer only
 * exists in the browser, so it can only ever change the result screen, which
 * is client-rendered anyway.
 *
 * Partner copy is written in each partner's own vocabulary, and a partner's
 * name and messaging must not appear on the live site until they have signed
 * off on it. So each partner carries `approved`: until it is true, their
 * version works on preview deployments, where their rep can review it, and
 * the production host serves the default test instead.
 */

export const PRODUCTION_HOSTS = ['humanrespect.app', 'www.humanrespect.app']

export const PARTNERS = {
  yatp: {
    name: 'You Are The Power',
    approved: false,
    sources: ['yatp', 'youarethepower'],
    hosts: ['youarethepower.net'],
    // Their audience is not political and their site avoids party language,
    // but "Human Respect" is already in their mission statement.
    intro: {
      eyebrow: 'The Human Respect Test · with You Are The Power',
      lead:
        "When a local official pushes a family around, it's done in our name. Before you decide what you think about that, find out where you draw the line yourself."
    },
    results: {
      consistent: 'That is the same standard You Are The Power holds local officials to.',
      loophole:
        'That gap is where local government abuse lives: officials doing to families what no neighbor would be allowed to do.',
      weighing:
        'You Are The Power takes on local officials who push families around, and wins with public attention, not force.',
      force:
        'You Are The Power works with the families on the other end of that: people pushed around by officials who were sure they were right.'
    },
    cta: [
      {
        href: 'https://www.youarethepower.net/membership/',
        title: 'Join You Are The Power',
        meta: 'Protect families from local government abuse'
      },
      {
        href: 'https://www.youarethepower.net/victories/',
        title: 'See what they have won',
        meta: 'youarethepower.net'
      }
    ]
  },

  sfl: {
    name: 'Students For Liberty',
    approved: false,
    sources: ['sfl', 'studentsforliberty'],
    hosts: ['studentsforliberty.org', 'join.studentsforliberty.org'],
    intro: {
      eyebrow: 'The Human Respect Test · with Students For Liberty',
      lead:
        'Everyone on campus wants to change something. Fewer have asked themselves how far they would go to make it happen.'
    },
    results: {
      consistent:
        'A standard that holds all the way through is something to build on. Students For Liberty is where liberty leaders take their first step.',
      loophole:
        'Closing that gap is a conversation worth having with people who have already thought hard about it.',
      weighing:
        'Working out where the line is goes faster with people who are working it out too.',
      force:
        'If you want to test that position against the strongest arguments, there are people ready to make them.'
    },
    cta: [
      {
        href: 'https://studentsforliberty.org/get-involved/',
        title: 'Get involved with Students For Liberty',
        meta: 'studentsforliberty.org'
      },
      {
        href: 'https://courses.learnliberty.org/',
        title: 'Take a free Learn Liberty course',
        meta: 'courses.learnliberty.org'
      }
    ]
  }
}

function normalise(value) {
  return String(value || '').trim().toLowerCase().replace(/[^a-z0-9]/g, '')
}

function fromSource(value) {
  const v = normalise(value)
  if (!v) return null
  return Object.keys(PARTNERS).find((id) =>
    id === v || PARTNERS[id].sources.some((s) => normalise(s) === v)) || null
}

function fromReferrer(referrer) {
  let host
  try {
    host = new URL(referrer).hostname.replace(/^www\./, '')
  } catch {
    return null
  }
  return Object.keys(PARTNERS).find((id) =>
    PARTNERS[id].hosts.some((h) => host === h || host.endsWith('.' + h))) || null
}

/**
 * Returns a partner id, or null for the default test. `host` is the hostname
 * serving the page; unapproved partners resolve to null on production.
 */
export function resolvePartner({ query = {}, referrer = '', host = '' } = {}) {
  const first = (v) => (Array.isArray(v) ? v[0] : v)
  const id = fromSource(first(query.partner)) || fromSource(first(query.utm_source)) || fromReferrer(referrer)
  if (!id) return null
  if (!PARTNERS[id].approved && PRODUCTION_HOSTS.includes(String(host).toLowerCase())) return null
  return id
}

/**
 * Outbound partner links carry UTM tags, so the partner can see in their own
 * analytics what the test sent them, broken down by result.
 */
export function partnerHref(href, resultKey) {
  const url = new URL(href)
  url.searchParams.set('utm_source', 'humanrespect.app')
  url.searchParams.set('utm_medium', 'referral')
  url.searchParams.set('utm_campaign', 'respect_test')
  if (resultKey) url.searchParams.set('utm_content', resultKey)
  return url.toString()
}
