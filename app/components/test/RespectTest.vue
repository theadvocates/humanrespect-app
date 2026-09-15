<template>
  <section class="rt" aria-label="Persuade or force? The short Human Respect Test">
    <div class="rt-meter" aria-hidden="true">
      <div
        v-for="(tick, i) in ITEMS"
        :key="tick.id"
        class="meter-tick"
        :class="{ done: stage === 'result' || (stage === 'questions' && i <= index), split: i === SPLIT }"
      />
    </div>

    <Transition name="step" mode="out-in">
      <!-- ── Intro ─────────────────────────────────────────────────────── -->
      <div v-if="stage === 'intro'" key="intro" class="step">
        <p class="rt-eyebrow">{{ introPartner?.intro.eyebrow || 'The Human Respect Test' }}</p>
        <h1 class="rt-head">Persuade or force?</h1>
        <p v-if="shared" class="rt-shared">
          Whoever sent you this scored <strong>{{ shared.directly }}</strong> when
          it's up to them and <strong>{{ shared.others }}</strong> when someone
          acts for them: <em>{{ RESULTS[shared.key].name }}</em>. Take it, then
          compare.
        </p>
        <p v-if="introPartner" class="rt-body">{{ introPartner.intro.lead }}</p>
        <p v-else class="rt-body">
          When you want to change something, there are only a few ways to get it
          done. You can put in your own time and money. You can persuade others to
          help. Or you can make them.
        </p>
        <p class="rt-body rt-quiet">
          Ten statements. Agree, maybe, or disagree. This isn't about defending
          yourself from someone who attacks first. It's about what you'd do to get
          something you want or believe in.
        </p>
        <button class="rt-btn" @click="start">Start <span aria-hidden="true">→</span></button>
        <p class="rt-meta">Under a minute · nothing to sign up for</p>
      </div>

      <!-- ── One statement at a time ───────────────────────────────────── -->
      <div v-else-if="stage === 'questions'" :key="item.id" class="step">
        <p class="rt-eyebrow">
          {{ index < SPLIT ? 'Part 1' : 'Part 2' }} · {{ PARTS[item.part].label }}
          <span class="rt-count">{{ index + 1 }} of {{ ITEMS.length }}</span>
        </p>
        <p class="rt-note" :class="{ 'rt-note-turn': index === SPLIT }">
          {{ index === SPLIT ? 'Now, ' + lowerFirst(PARTS.others.note) : PARTS[item.part].note }}
        </p>
        <h2 class="rt-statement">{{ item.text }}</h2>
        <div class="rt-answers" role="group" :aria-label="'Your answer to statement ' + (index + 1)">
          <button
            v-for="a in ANSWERS"
            :key="a.id"
            class="rt-answer"
            :class="{ picked: answers[item.id] === a.id }"
            :aria-pressed="answers[item.id] === a.id"
            @click="answer(a.id)"
          >
            {{ a.label }}
          </button>
        </div>
        <!-- Always laid out, so the answers do not shift when it first appears. -->
        <button class="rt-back" :class="{ invisible: index === 0 }" :tabindex="index === 0 ? -1 : 0" @click="back">← Back</button>
      </div>

      <!-- ── The reveal ────────────────────────────────────────────────── -->
      <div v-else key="result" class="step">
        <p class="rt-eyebrow">Your result</p>

        <div
          class="scale"
          :class="`phase-${phase}`"
          role="img"
          :aria-label="`On a line from force to persuasion: directly, ${scores.directly} out of 100. Through others, ${scores.others} out of 100.`"
        >
          <div class="scale-track">
            <div class="scale-gap" :style="gapStyle" />
            <div class="marker marker-you" :class="edge(youAt)" :style="{ left: youAt + '%' }">
              <span class="marker-label">You <strong>{{ scores.directly }}</strong></span>
              <span class="marker-dot" />
            </div>
            <div class="marker marker-others" :class="edge(othersAt)" :style="{ left: othersAt + '%' }">
              <span class="marker-dot" />
              <span class="marker-label">Through others <strong>{{ scores.others }}</strong></span>
            </div>
          </div>
          <div class="scale-ends">
            <span>Force</span>
            <span>Persuade</span>
          </div>
        </div>

        <div class="reveal-late">
          <p class="rt-legend">
            100 means you'd persuade every time. 0 means you'd force every time.
            On your own, you'd {{ describeScore(scores.directly) }}. Through a
            vote, a law, or a leader, you'd {{ describeScore(scores.others) }}.
          </p>

          <p v-if="scores.gap > 0" class="rt-gap">
            Your gap: <strong>{{ scores.gap }} points</strong>
          </p>

          <p v-if="shared" class="rt-compare">
            The person who sent you this: {{ shared.directly }} on their own,
            {{ shared.others }} through others<template v-if="shared.gap > 0">, a gap of {{ shared.gap }}</template>.
            <template v-if="shared.key === resultKey">You landed in the same place.</template>
            <template v-else>They landed on <em>{{ RESULTS[shared.key].name }}</em>.</template>
          </p>

          <p class="rt-result-name">{{ result.name }}</p>
          <p v-if="landedShare !== null" class="rt-stat">
            {{ landedShare }}% of the {{ stats.total.toLocaleString('en-US') }} people who've taken this test landed here.
          </p>
          <div class="rt-result-grid">
            <div class="rt-result-text">
              <h2 class="rt-head rt-head-result">{{ result.head }}</h2>
              <p v-for="(p, i) in result.body" :key="i" class="rt-body">{{ p }}</p>
              <p v-if="partner" class="rt-body rt-partner">{{ partner.results[resultKey] }}</p>

              <p class="rt-map">
                This test doesn't measure whether your values lean liberal or
                conservative. Both hold good values, and most people share some of
                each. It measures how you'd advance yours.
              </p>
            </div>
            <!-- Each result has its plate, from the same set as the experiences. -->
            <Plate :name="RESULT_PLATE[resultKey]" class="rt-plate" :alt="`${PLATE_TITLE[RESULT_PLATE[resultKey]]}, an engraving`">
              <i>{{ PLATE_TITLE[RESULT_PLATE[resultKey]] }}.</i> {{ PLATE_NOTE[resultKey] }}
            </Plate>
          </div>

          <ShareLink
            class="rt-share"
            :path="sharePath"
            source="test_result"
            prompt="Send your result to someone who'd answer differently."
            :text="shareText"
            subject="Persuade or force? A one-minute test"
          />

          <div class="paths">
            <a
              v-for="(c, i) in partnerLinks"
              :key="c.href"
              :href="c.href"
              target="_blank"
              rel="noopener"
              class="path"
              :class="{ 'path-primary': i === 0 }"
              @click="track('partner_link', { to: c.href })"
            >
              <span class="path-title">{{ c.title }} <span aria-hidden="true">↗</span></span>
              <span class="path-meta">{{ c.meta }}</span>
            </a>
            <NuxtLink
              v-for="(p, i) in paths"
              :key="p.to"
              :to="p.to"
              class="path"
              :class="{ 'path-primary': i === 0 && !partner }"
              @click="track('path', { to: p.to })"
            >
              <span class="path-title">{{ p.title }}</span>
              <span class="path-meta">{{ p.meta }}</span>
            </NuxtLink>
          </div>

          <button class="rt-back" @click="restart">Take it again</button>
        </div>
      </div>
    </Transition>
  </section>
</template>

<script setup>
import ShareLink from '@/components/shared/ShareLink.vue'
import Plate from '@/components/shared/Plate.vue'
import { RESULT_PLATE, PLATE_TITLE } from '@/utils/plates'
import { ANSWERS, PARTS, ITEMS, RESULTS, TEST_VERSION, score, classify, describeScore, parseShared, sharedResultPath } from '@/utils/respectTest'
import { EXPERIENCES } from '@/utils/experiences'
import { PARTNERS, resolvePartner, partnerHref } from '@/utils/testPartners'
import { useStepHistory } from '@/composables/useStepHistory'

// One line under each result's plate.
const PLATE_NOTE = {
  consistent: 'Nobody made to sit.',
  loophole: 'Same button, someone else\'s finger.',
  weighing: 'Nothing settled yet.',
  force: 'One ends the argument. Only one wins it.'
}

const SPLIT = ITEMS.findIndex((i) => i.part === 'others')

const minutes = Object.fromEntries(EXPERIENCES.map((e) => [e.path, e.minutes]))
const PATH = {
  turn: { to: '/', title: 'The question behind this test', meta: '1 minute · a thought experiment on the home page' },
  agency: { to: '/experience/human-agency', title: 'If you hire someone to steal, who stole?', meta: 'on delegating force' },
  conversation: { to: '/practice/the-conversation', title: 'Talking with someone who takes the loophole', meta: 'a practice' },
  objection: { to: '/experience/the-objection', title: 'Hang on — I have an objection', meta: 'the strongest case against' },
  evidence: { to: '/experience/flourishing', title: 'Is any of this actually true?', meta: 'the evidence' }
}
const PATHS_FOR = {
  consistent: ['conversation', 'agency'],
  loophole: ['agency', 'turn'],
  weighing: ['turn', 'objection'],
  force: ['turn', 'evidence']
}

const { trackChoice, trackScreenView } = useAnalytics()
const route = useRoute()

// The URL is readable during SSR, so a tagged link renders the partner's intro
// on first paint. The referrer only exists once mounted; letting it swap the
// intro would flash, so it only reaches the result screen.
const host = useRequestURL().hostname
const urlPartnerId = resolvePartner({ query: route.query, host })
const introPartner = urlPartnerId ? PARTNERS[urlPartnerId] : null
const partnerId = ref(urlPartnerId)
const partner = computed(() => (partnerId.value ? PARTNERS[partnerId.value] : null))

// Someone's result, carried in the link they sent.
const shared = parseShared(route.query)

// How the result compares with everyone else's. Only shown once the sample is
// big enough to mean something; the endpoint returns nothing below that.
const stats = ref(null)
const landedShare = computed(() => {
  const n = stats.value?.counts?.[resultKey.value]
  if (!stats.value?.total || n === undefined) return null
  return Math.round((n / stats.value.total) * 100)
})

const stage = ref('intro')
const index = ref(0)
const answers = ref({})
const phase = ref(0)
const startedAt = ref(null)
let timers = []

const item = computed(() => ITEMS[index.value])

// The whole test as one number for browser history: 0 is the intro, 1–10 the
// statements, 11 the result. Back from the result returns to the last
// statement with the answers still there.
const RESULT_STEP = ITEMS.length + 1
const step = computed({
  get: () => (stage.value === 'intro' ? 0 : stage.value === 'questions' ? index.value + 1 : RESULT_STEP),
  set: (n) => {
    if (n <= 0) {
      stage.value = 'intro'
      index.value = 0
    } else if (n < RESULT_STEP) {
      stage.value = 'questions'
      index.value = n - 1
    } else {
      stage.value = 'result'
      clearTimers()
      phase.value = 3
    }
  }
})
const steps = useStepHistory(step, { id: 'test' })
const scores = computed(() => score(answers.value))
const resultKey = computed(() => classify(scores.value))
const result = computed(() => RESULTS[resultKey.value])

const partnerLinks = computed(() =>
  (partner.value?.cta || []).map((c) => ({ ...c, href: partnerHref(c.href, resultKey.value) })))

// With a partner, their links lead and one Human Respect path follows.
const paths = computed(() =>
  PATHS_FOR[resultKey.value].slice(0, partner.value ? 1 : 2).map((k) => {
    const p = PATH[k]
    const m = minutes[p.to]
    return { ...p, meta: m ? `${m} minutes · ${p.meta}` : p.meta }
  }))

// Before the reveal both markers wait at the middle; "through others" then
// sets off from wherever "you" landed, so the gap visibly opens rather than
// simply being drawn.
const youAt = computed(() => (phase.value >= 1 ? scores.value.directly : 50))
const othersAt = computed(() => (phase.value >= 2 ? scores.value.others : youAt.value))
const gapStyle = computed(() => {
  const a = youAt.value
  const b = othersAt.value
  return { left: Math.min(a, b) + '%', width: Math.abs(a - b) + '%' }
})

const sharePath = computed(() => {
  const path = sharedResultPath({ key: resultKey.value, ...scores.value })
  return partnerId.value ? `${path}&partner=${partnerId.value}` : path
})

const shareText = computed(() => {
  const { directly, others } = scores.value
  const name = result.value.name
  return directly > others
    ? `I'd persuade, not force: ${directly} out of 100 on my own. Through a vote, a law, or a leader, I dropped to ${others}. "${name}." Where do you land?`
    : `Persuade or force? I scored ${directly} out of 100 on my own and ${others} through a vote, a law, or a leader. "${name}." Where do you land?`
})

/** Near either end a centred label would hang off the page; anchor it inward. */
function edge(at) {
  return at <= 15 ? 'edge-left' : at >= 85 ? 'edge-right' : ''
}

function lowerFirst(s) {
  return s.charAt(0).toLowerCase() + s.slice(1)
}

function elapsed() {
  return startedAt.value ? Math.round((Date.now() - startedAt.value) / 1000) : 0
}

function track(name, props = {}) {
  trackChoice('test', name, { ...props, partner: partnerId.value, seconds: elapsed() })
}

function start() {
  startedAt.value = Date.now()
  track('start')
  stage.value = 'questions'
}

function answer(id) {
  answers.value = { ...answers.value, [item.value.id]: id }
  trackChoice('test', item.value.id, { answer: id, partner: partnerId.value })
  if (index.value < ITEMS.length - 1) index.value += 1
  else finish()
}

function back() {
  if (index.value > 0 && !steps.back()) index.value -= 1
}

function finish() {
  stage.value = 'result'
  track('result', { result: resultKey.value, ...scores.value, version: TEST_VERSION, shared_from: shared?.key || null })
  reveal()
  loadStats()
}

function reveal() {
  clearTimers()
  phase.value = 0
  const reduced = typeof window !== 'undefined' &&
    window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
  if (reduced) {
    phase.value = 3
    return
  }
  // Timings leave room for the step transition, then give each marker its
  // own moment. The words arrive last, once the picture has said it.
  timers = [
    setTimeout(() => { phase.value = 1 }, 450),
    setTimeout(() => { phase.value = 2 }, 1450),
    setTimeout(() => { phase.value = 3 }, 2450)
  ]
}

async function loadStats() {
  try {
    stats.value = await $fetch('/api/test-stats')
  } catch (e) {
    stats.value = null
  }
}

function clearTimers() {
  timers.forEach(clearTimeout)
  timers = []
}

function restart() {
  steps.reset()
  clearTimers()
  answers.value = {}
  index.value = 0
  phase.value = 0
  track('restart')
  stage.value = 'intro'
  window.scrollTo({ top: 0 })
}

watch([stage, index], ([s, i]) => {
  trackScreenView('test', s === 'questions' ? `q${i + 1}` : s, { partner: partnerId.value })
})

onMounted(() => {
  if (!partnerId.value) partnerId.value = resolvePartner({ referrer: document.referrer, host })
  trackScreenView('test', 'intro', { partner: partnerId.value })
})
onBeforeUnmount(clearTimers)
</script>

<style scoped>
.rt {
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 40rem;
  margin: 0 auto;
  padding: 5rem 1.5rem 4rem;
}

.rt-meter { display: flex; gap: 5px; margin-bottom: 3rem; }
.meter-tick {
  height: 2px; flex: 1; border-radius: 2px;
  background: var(--paper-deep);
  transition: background 0.4s ease;
}
.meter-tick.done { background: var(--ochre); }
/* A wider gap where Part 2 begins — the test's structure, visible at a glance. */
.meter-tick.split { margin-left: 10px; }

.step { display: flex; flex-direction: column; align-items: flex-start; }

.rt-eyebrow {
  display: flex;
  gap: 1rem;
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin: 0 0 1.25rem;
}
.rt-count { color: var(--ink-faint); }

.rt-head {
  font-family: var(--serif);
  font-size: clamp(2.2rem, 5.4vw, 3.3rem);
  font-weight: 400;
  line-height: 1.15;
  letter-spacing: -0.02em;
  color: var(--ink);
  margin: 0 0 1.75rem;
  text-wrap: balance;
}
.rt-head-result { font-size: clamp(1.7rem, 4vw, 2.4rem); line-height: 1.22; }

.rt-body {
  font-family: var(--sans);
  font-size: 1.02rem;
  line-height: 1.75;
  color: var(--ink-soft);
  max-width: 34rem;
  margin: 0 0 1.25rem;
}
.rt-quiet { color: var(--ink-muted); font-size: 0.95rem; }
.rt-meta { font-family: var(--sans); font-size: 0.8rem; color: var(--ink-faint); margin: 1rem 0 0; }

.rt-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 1rem;
  padding: 0.85rem 2.2rem;
  font-family: var(--serif);
  font-size: 1.1rem;
  letter-spacing: 0.02em;
  color: var(--paper);
  background: var(--ochre);
  border: 1px solid var(--ochre);
  border-radius: 100px;
  cursor: pointer;
  transition: background 0.3s ease;
  -webkit-tap-highlight-color: transparent;
}
.rt-btn:hover { background: var(--ochre-deep); }

.rt-note {
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink-muted);
  margin: 0 0 1rem;
  min-height: 1.5em;
}
.rt-note-turn { color: var(--ink); font-style: italic; }

/* Fixed minimum height so the answer buttons do not jump between statements
   of different lengths — the thumb stays where it was. */
.rt-statement {
  font-family: var(--serif);
  font-size: clamp(1.55rem, 3.8vw, 2.15rem);
  font-weight: 400;
  line-height: 1.3;
  color: var(--ink);
  margin: 0 0 2rem;
  min-height: 4.2em;
  text-wrap: pretty;
}

.rt-answers { display: flex; gap: 0.75rem; width: 100%; }
.rt-answer {
  flex: 1;
  padding: 0.95rem 1rem;
  font-family: var(--serif);
  font-size: 1.12rem;
  color: var(--ink);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  cursor: pointer;
  transition: border-color 0.2s ease, background 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.rt-answer:hover { border-color: var(--ochre); background: var(--cream); }
.rt-answer.picked { border-color: var(--ochre); color: var(--ochre); }

.rt-back {
  margin-top: 1.75rem;
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-faint);
  background: none;
  border: none;
  border-bottom: 1px solid transparent;
  cursor: pointer;
  padding: 0 0 2px;
}
.rt-back:hover { color: var(--ink-muted); border-bottom-color: var(--border-subtle); }
.rt-back.invisible { visibility: hidden; }

/* ── The scale ─────────────────────────────────────────────────────────── */
.scale { width: 100%; margin: 1.5rem 0 2.25rem; }

/* Room above for "You", below for "Through others", so the two labels never
   collide however close the scores are. */
.scale-track {
  position: relative;
  height: 4px;
  /* Inset by a dot's radius so a marker at 0 or 100 stays inside the gutter. */
  margin: 3.2rem 10px;
  border-radius: 4px;
  background: linear-gradient(to right, var(--paper-deep), var(--ochre-light));
}

.scale-gap {
  position: absolute;
  top: -3px;
  height: 10px;
  border-radius: 10px;
  background: var(--concede-warm);
  opacity: 0.28;
  transition: left 0.9s cubic-bezier(0.22, 1, 0.36, 1), width 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}

.marker {
  position: absolute;
  top: 2px;
  display: flex;
  flex-direction: column;
  align-items: center;
  transform: translate(-50%, -50%);
  transition: left 0.9s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.4s ease;
  white-space: nowrap;
}
.marker-label { position: absolute; left: 50%; transform: translateX(-50%); }
.marker-you .marker-label { bottom: 1.5rem; }
.marker-others .marker-label { top: 1.5rem; }
.edge-left .marker-label { left: 0; transform: none; }
.edge-right .marker-label { left: auto; right: 0; transform: none; }

.marker-dot {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  box-sizing: border-box;
}
.marker-you .marker-dot { background: var(--ochre); box-shadow: 0 0 0 4px var(--paper); }
.marker-others .marker-dot { background: transparent; border: 3px solid var(--concede-warm); }

.marker-label {
  font-family: var(--sans);
  font-size: 0.78rem;
  color: var(--ink-muted);
}
.marker-label strong {
  font-family: var(--serif);
  font-size: 1.25rem;
  font-weight: 500;
  color: var(--ink);
  margin-left: 0.2rem;
}

.phase-0 .marker { opacity: 0; }
.phase-1 .marker-others { opacity: 0; }

.scale-ends {
  display: flex;
  justify-content: space-between;
  font-family: var(--sans);
  font-size: 0.68rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ink-faint);
}

.reveal-late { width: 100%; transition: opacity 0.6s ease, transform 0.6s ease; }
.scale:not(.phase-3) + .reveal-late { opacity: 0; transform: translateY(8px); }

.rt-gap {
  font-family: var(--sans);
  font-size: 0.95rem;
  color: var(--ink-muted);
  margin: 0 0 1.75rem;
}
.rt-gap strong { color: var(--concede-warm); font-weight: 600; }

.rt-legend,
.rt-compare,
.rt-stat {
  font-family: var(--sans);
  font-size: 0.9rem;
  line-height: 1.65;
  color: var(--ink-muted);
  margin: 0 0 1.25rem;
  max-width: 36rem;
}
.rt-compare em,
.rt-shared em { font-style: italic; color: var(--ink); }
.rt-stat { margin-top: -0.4rem; font-size: 0.85rem; }

.rt-shared {
  font-family: var(--sans);
  font-size: 0.95rem;
  line-height: 1.65;
  color: var(--ink-soft);
  padding: 0.9rem 1.1rem;
  border-left: 2px solid var(--ochre);
  background: var(--paper-warm);
  margin: 0 0 1.5rem;
  max-width: 36rem;
}
.rt-shared strong { color: var(--ink); font-weight: 600; }

.rt-result-name {
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin: 0 0 0.9rem;
}

.rt-partner {
  color: var(--ink);
  padding-left: 1rem;
  border-left: 2px solid var(--ochre-light);
}

.rt-map {
  font-family: var(--sans);
  font-size: 0.85rem;
  line-height: 1.65;
  color: var(--ink-muted);
  padding-left: 1rem;
  border-left: 2px solid var(--paper-deep);
  margin: 1.5rem 0 0;
  max-width: 34rem;
}

.rt-share {
  margin-top: 2rem;
  padding-top: 1.75rem;
  border-top: 1px solid var(--border-subtle);
}

.paths { display: flex; flex-direction: column; gap: 0.75rem; width: 100%; margin-top: 2rem; }
.path {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  padding: 1.1rem 1.4rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  text-decoration: none;
  transition: border-color 0.25s ease, transform 0.25s ease;
}
.path:hover { border-color: var(--ochre); transform: translateX(3px); }
.path-primary { border-color: var(--ochre-light); }
.path-title { font-family: var(--serif); font-size: 1.18rem; color: var(--ink); }
.path-meta { font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); }

.step-enter-active, .step-leave-active { transition: opacity 0.22s ease, transform 0.22s ease; }
.step-enter-from { opacity: 0; transform: translateX(14px); }
.step-leave-to { opacity: 0; transform: translateX(-10px); }

@media (prefers-reduced-motion: reduce) {
  .step-enter-active, .step-leave-active,
  .marker, .scale-gap, .reveal-late { transition: none; }
  .path:hover { transform: none; }
}

@media (max-width: 640px) {
  .rt { padding: 4.5rem 1.15rem 3rem; justify-content: flex-start; }
  .rt-meter { margin-bottom: 2.25rem; }
  .rt-statement { min-height: 5.2em; }
}

/* The result's plate hangs in the right margin on a wide screen, and drops
   under the text on a narrow one. */
.rt-result-grid {
  display: grid;
  grid-template-columns: 1fr 11rem;
  gap: 2.5rem;
  align-items: start;
  margin-right: -13.5rem;
  width: 100%;
}
.rt-result-text { min-width: 0; }
@media (max-width: 1160px) { .rt-result-grid { margin-right: 0; } }
@media (max-width: 680px) {
  .rt-result-grid { grid-template-columns: 1fr; }
  .rt-plate { width: min(12rem, 60vw); }
}
</style>
