<template>
  <section class="turn" :aria-label="'The core question'">
    <!-- Progress: honest about how short this is. -->
    <div class="turn-meter" aria-hidden="true">
      <div v-for="i in BEATS" :key="i" class="meter-tick" :class="{ done: i <= beat + 1 }"/>
    </div>

    <Transition name="beat" mode="out-in">
      <!-- ── 1. The recall ─────────────────────────────────────────────── -->
      <div v-if="beat === 0" key="recall" class="beat">
        <h1 class="turn-head">
          Think of the last real disagreement you had with someone you love.
        </h1>
        <p class="turn-body">
          Not about where to eat. Something that mattered — money, a child, a
          decision you'd both have to live with. You were certain you were right.
          They were just as certain.
        </p>
        <p class="turn-body turn-body-quiet">Hold it in mind. Have you got one?</p>
        <button class="turn-btn" @click="advance('recall')">Yes, I've got one <span aria-hidden="true">→</span></button>
      </div>

      <!-- ── 2. The button ─────────────────────────────────────────────── -->
      <div v-else-if="beat === 1" key="button" class="beat">
        <h2 class="turn-head">Now imagine a button.</h2>
        <p class="turn-body">
          Press it and they simply comply. No argument, no compromise, no
          conversation. They do what you wanted — and face real consequences if
          they refuse.
        </p>
        <p class="turn-body turn-ask">In that disagreement, would you have pressed it?</p>
        <div class="turn-choices">
          <button class="turn-choice" @click="choose('no')">No, I wouldn't</button>
          <button class="turn-choice" @click="choose('yes')">Honestly, I might</button>
        </div>
      </div>

      <!-- ── 3. Why not ────────────────────────────────────────────────── -->
      <div v-else-if="beat === 2" key="why" class="beat">
        <h2 class="turn-head">
          {{ wouldPress ? 'Say you did press it.' : 'Why not?' }}
        </h2>
        <p class="turn-body">
          {{ wouldPress
            ? 'What would it cost you? Pick whatever rings true.'
            : 'Pick whatever rings true. There are no wrong answers here.' }}
        </p>
        <ul class="reason-list">
          <li v-for="r in REASONS" :key="r.id">
            <button
              class="reason"
              :class="{ picked: reasons.includes(r.id) }"
              :aria-pressed="reasons.includes(r.id)"
              @click="toggle(r.id)"
            >
              <span class="reason-mark" aria-hidden="true">{{ reasons.includes(r.id) ? '✓' : '' }}</span>
              <span>{{ r.text }}</span>
            </button>
          </li>
        </ul>
        <button class="turn-btn" :disabled="!reasons.length" @click="advance('reasons')">
          Continue <span aria-hidden="true">→</span>
        </button>
      </div>

      <!-- ── 4. The turn ───────────────────────────────────────────────── -->
      <div v-else-if="beat === 3" key="turn" class="beat">
        <h2 class="turn-head">You just described what force does to people.</h2>
        <ul class="echo-list">
          <li v-for="r in pickedReasons" :key="r.id" class="echo">{{ r.echo }}</li>
        </ul>
        <p class="turn-body">
          You didn't get that from a philosophy book. You got it from living
          among other human beings. You've run that experiment your whole life —
          in your family, your friendships, your work — and reached the same
          answer every time.
        </p>
        <p class="turn-body turn-emphasis">Persuasion builds. Force diminishes.</p>
        <button class="turn-btn" @click="advance('turn')">Go on <span aria-hidden="true">→</span></button>
      </div>

      <!-- ── 5. The pivot ──────────────────────────────────────────────── -->
      <div v-else-if="beat === 4" key="pivot" class="beat">
        <h2 class="turn-head">Now hold that next to this.</h2>
        <p class="turn-body">
          When millions of people disagree — about healthcare, schools, drugs,
          immigration — the system we built to settle it <em>is</em> the button.
          Pass a law. Compel compliance. Fine or imprison those who refuse.
        </p>
        <p class="turn-body">
          The people on the receiving end are every bit as certain they're right,
          every bit as complex, and every bit as resentful of being overridden as
          the person you were thinking about a minute ago.
        </p>
        <button class="turn-btn" @click="advance('pivot')">
          So what's the question? <span aria-hidden="true">→</span>
        </button>
      </div>

      <!-- ── 6. The question ───────────────────────────────────────────── -->
      <div v-else key="question" class="beat">
        <p class="turn-eyebrow">The Philosophy of Human Respect</p>
        <h2 class="turn-head turn-head-final">
          If you already know force doesn't work on someone you love —
          <em>why do we build everything else on it?</em>
        </h2>
        <p class="turn-body">
          That's the whole idea. It took about a minute. Everything past this
          point is evidence, objections, and what to do about it — and none of it
          is required.
        </p>

        <div class="paths">
          <NuxtLink :to="{ name: 'exp02' }" class="path path-primary" @click="track('path', { to: 'objection' })">
            <span class="path-label">Most people push back here</span>
            <span class="path-title">The strongest objection to this</span>
            <span class="path-meta">4 minutes</span>
          </NuxtLink>
          <NuxtLink :to="{ name: 'exp03' }" class="path" @click="track('path', { to: 'flourishing' })">
            <span class="path-title">Is any of this actually true?</span>
            <span class="path-meta">8 minutes · the evidence</span>
          </NuxtLink>
          <NuxtLink to="/your-journey" class="path" @click="track('path', { to: 'all' })">
            <span class="path-title">Show me everything</span>
            <span class="path-meta">15 experiences · go at your own pace</span>
          </NuxtLink>
        </div>

        <button class="restart" @click="restart">Start over</button>
      </div>
    </Transition>
  </section>
</template>

<script setup>
const BEATS = 6

const REASONS = [
  { id: 'damage', text: 'It would damage what we have', echo: 'Force breaks the relationship.' },
  { id: 'mind', text: "They'd comply, but they wouldn't change their mind", echo: 'Force produces compliance, not agreement.' },
  { id: 'resent', text: "They'd resent me for it", echo: 'Force breeds resentment.' },
  { id: 'wrong', text: 'I might be the one who\'s wrong', echo: 'Force removes the correction that disagreement provides.' },
  { id: 'hollow', text: "Winning that way isn't really winning", echo: 'Force wins the argument and loses the point.' },
  { id: 'trust', text: "They'd never fully trust me again", echo: 'Force erodes trust.' }
]

const emit = defineEmits(['progress'])
const { trackChoice, trackScreenView } = useAnalytics()

const beat = ref(0)
const wouldPress = ref(false)
const reasons = ref([])
const startedAt = ref(null)

const pickedReasons = computed(() => REASONS.filter((r) => reasons.value.includes(r.id)))

function track(name, props = {}) {
  trackChoice('turn', name, { ...props, beat: beat.value, seconds: elapsed() })
}

function elapsed() {
  return startedAt.value ? Math.round((Date.now() - startedAt.value) / 1000) : 0
}

function advance(from) {
  if (from) track(from, { reasons: reasons.value })
  beat.value = Math.min(beat.value + 1, BEATS - 1)
}

function choose(answer) {
  wouldPress.value = answer === 'yes'
  track('would_press', { answer })
  beat.value = 2
}

function toggle(id) {
  const i = reasons.value.indexOf(id)
  if (i === -1) reasons.value.push(id)
  else reasons.value.splice(i, 1)
}

function restart() {
  beat.value = 0
  reasons.value = []
  startedAt.value = Date.now()
}

// Each beat is a screen for analytics purposes, so the funnel is visible
// without querying Postgres by hand.
watch(beat, (b) => {
  const names = ['recall', 'the-button', 'why-not', 'the-turn', 'the-pivot', 'the-question']
  trackScreenView('turn', names[b])
  emit('progress', { beat: b, of: BEATS, seconds: elapsed() })
  if (b === BEATS - 1) track('reached_insight', { seconds: elapsed() })
})

onMounted(() => {
  startedAt.value = Date.now()
  trackScreenView('turn', 'recall')
})
</script>

<style scoped>
/* Nothing here starts hidden. The first beat must paint immediately — the
   previous landing page kept its call to action invisible for 1.8s, against a
   median attention window under 10 seconds. */
.turn {
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 40rem;
  margin: 0 auto;
  padding: 5rem 1.5rem 4rem;
}

.turn-meter { display: flex; gap: 5px; margin-bottom: 3rem; }
.meter-tick {
  height: 2px; flex: 1; border-radius: 2px;
  background: var(--paper-deep);
  transition: background 0.5s ease;
}
.meter-tick.done { background: var(--ochre); }

.beat { display: flex; flex-direction: column; align-items: flex-start; }

.turn-eyebrow {
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 1.5rem;
}

.turn-head {
  font-family: var(--serif);
  font-size: clamp(1.9rem, 4.6vw, 2.9rem);
  font-weight: 400;
  line-height: 1.22;
  letter-spacing: -0.02em;
  color: var(--ink);
  margin: 0 0 1.75rem;
  text-wrap: balance;
}
.turn-head em { font-style: italic; color: var(--ochre); }
.turn-head-final { font-size: clamp(1.7rem, 4vw, 2.5rem); }

/* ~66 characters per line — the readable range. */
.turn-body {
  font-family: var(--sans);
  font-size: 1.02rem;
  line-height: 1.75;
  color: var(--ink-soft);
  max-width: 34rem;
  margin: 0 0 1.25rem;
}
.turn-body-quiet { color: var(--ink-muted); }
.turn-ask { color: var(--ink); font-size: 1.08rem; margin-top: 0.75rem; }
.turn-emphasis {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-style: italic;
  color: var(--ink);
  margin-top: 0.5rem;
}

.turn-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 1.5rem;
  padding: 0.85rem 2rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  letter-spacing: 0.02em;
  color: var(--ochre);
  background: transparent;
  border: 1px solid var(--ochre);
  border-radius: 100px;
  cursor: pointer;
  transition: background 0.3s ease, color 0.3s ease, opacity 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.turn-btn:hover:not(:disabled) { background: var(--ochre); color: var(--paper); }
.turn-btn:disabled { opacity: 0.35; cursor: default; }

.turn-choices { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-top: 1.75rem; }
.turn-choice {
  padding: 0.85rem 1.75rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  cursor: pointer;
  transition: border-color 0.25s ease, background 0.25s ease;
}
.turn-choice:hover { border-color: var(--ochre); background: #fff; }

.reason-list { list-style: none; padding: 0; margin: 0.5rem 0 0; width: 100%; }
.reason-list li { margin-bottom: 0.6rem; }
.reason {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  width: 100%;
  padding: 0.9rem 1.15rem;
  font-family: var(--sans);
  font-size: 0.97rem;
  line-height: 1.5;
  text-align: left;
  color: var(--ink-soft);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: border-color 0.2s ease, color 0.2s ease;
}
.reason:hover { border-color: var(--ink-faint); }
.reason.picked { border-color: var(--ochre); color: var(--ink); }
.reason-mark {
  flex: 0 0 18px;
  height: 18px;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.7rem;
  color: var(--ochre);
  border: 1.5px solid var(--border-subtle);
  border-radius: 50%;
}
.reason.picked .reason-mark { border-color: var(--ochre); }

.echo-list { list-style: none; padding: 0; margin: 0 0 1.75rem; }
.echo {
  font-family: var(--serif);
  font-size: 1.18rem;
  line-height: 1.5;
  color: var(--ink);
  padding: 0.45rem 0 0.45rem 1.15rem;
  border-left: 2px solid var(--ochre-light);
  margin-bottom: 0.5rem;
}

.paths { display: flex; flex-direction: column; gap: 0.75rem; width: 100%; margin-top: 2.25rem; }
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
.path-label {
  font-family: var(--sans);
  font-size: 0.68rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--ochre);
}
.path-title { font-family: var(--serif); font-size: 1.18rem; color: var(--ink); }
.path-meta { font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); }

.restart {
  margin-top: 2rem;
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-faint);
  background: none;
  border: none;
  border-bottom: 1px solid transparent;
  cursor: pointer;
  padding: 0 0 2px;
}
.restart:hover { color: var(--ink-muted); border-bottom-color: var(--border-subtle); }

/* Motion between beats only — never gating the first paint. */
.beat-enter-active, .beat-leave-active { transition: opacity 0.3s ease, transform 0.3s ease; }
.beat-enter-from { opacity: 0; transform: translateY(10px); }
.beat-leave-to { opacity: 0; transform: translateY(-6px); }

@media (prefers-reduced-motion: reduce) {
  .beat-enter-active, .beat-leave-active { transition: none; }
  .path:hover { transform: none; }
}

@media (max-width: 640px) {
  .turn { padding: 4.5rem 1.15rem 3rem; }
  .turn-choices { flex-direction: column; align-items: stretch; }
  .turn-choice { text-align: center; }
}
</style>
