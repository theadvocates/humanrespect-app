<template>
  <div class="gr">
    <p class="gr-eyebrow">Where the gap opened</p>
    <p class="gr-lead">
      Each topic was asked twice: once for your own hands, once for a vote, a
      law, or a leader acting for you. Where the two marks part, that's the
      exception.
    </p>
    <div class="gr-legend" aria-hidden="true">
      <span><i class="gr-dot" /> Your own hands</span>
      <span><i class="gr-dot hollow" /> Through others</span>
    </div>
    <div class="gr-rows">
      <div class="gr-row gr-head" aria-hidden="true">
        <span />
        <span class="gr-ends"><span>Force</span><span>Maybe</span><span>Persuade</span></span>
        <span class="gr-gapcol">Gap</span>
      </div>
      <div
        v-for="t in rows"
        :key="t.key"
        class="gr-row"
        role="img"
        :aria-label="`${t.name}: ${t.directly} of 20 on your own hands, ${t.others} of 20 through others${t.gap > 0 ? `, a gap of ${t.gap}` : ''}.`"
      >
        <span class="gr-topic">{{ t.name }}<small>{{ t.note }}</small></span>
        <span class="gr-track">
          <i class="gr-seg" :style="{ left: pct(Math.min(t.directly, t.others)), width: pct(Math.abs(t.gap)) }" />
          <i class="gr-dot hollow" :style="{ left: pct(t.others) }" />
          <i class="gr-dot" :style="{ left: pct(t.directly) }" />
        </span>
        <span class="gr-gapcol gr-gap" :class="{ open: t.gap > 0 }">{{ t.gap > 0 ? `+${t.gap}` : t.gap }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { byTopic } from '@/utils/respectTest'

/**
 * The five matched pairs, one row each, so a result can say which topic the
 * exception was on. Each half of an item scores 0, 10 or 20, and the five
 * rows add up to the two headline numbers on the map.
 */
const props = defineProps({
  /** item id → answer id, as the test collects them */
  answers: { type: Object, required: true }
})

const rows = computed(() => byTopic(props.answers))
const pct = (points) => `${points * 5}%`
</script>

<style scoped>
.gr { width: 100%; margin-top: 2.5rem; padding-top: 1.75rem; border-top: 1px solid var(--border-subtle); }

.gr-eyebrow {
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin: 0 0 0.75rem;
}
.gr-lead {
  font-family: var(--sans);
  font-size: 0.9rem;
  line-height: 1.65;
  color: var(--ink-muted);
  margin: 0 0 1.25rem;
  max-width: 36rem;
}
.gr-legend {
  display: flex;
  gap: 1.4rem;
  flex-wrap: wrap;
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-muted);
  margin-bottom: 0.5rem;
}
.gr-legend span { display: inline-flex; align-items: center; gap: 0.5rem; }
.gr-legend .gr-dot { position: static; margin: 0; }

.gr-rows { display: flex; flex-direction: column; }
.gr-row {
  display: grid;
  grid-template-columns: 7rem minmax(0, 1fr) 3rem;
  gap: 1rem;
  align-items: center;
  padding: 0.85rem 0;
  border-bottom: 1px solid var(--border-subtle);
}
.gr-head { padding: 0.4rem 0 0.6rem; border-bottom-color: var(--ink-muted); }
.gr-ends {
  display: flex;
  justify-content: space-between;
  font-family: var(--sans);
  font-size: 0.66rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ink-muted);
}
.gr-gapcol {
  text-align: right;
  font-family: var(--sans);
  font-size: 0.66rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ink-muted);
}

.gr-topic { font-family: var(--serif); font-size: 1.15rem; line-height: 1.2; color: var(--ink); }
.gr-topic small {
  display: block;
  font-family: var(--sans);
  font-size: 0.72rem;
  color: var(--ink-faint);
  margin-top: 0.15rem;
}

.gr-track { position: relative; display: block; height: 24px; margin: 0 7px; }
.gr-track::before {
  content: '';
  position: absolute;
  left: 0; right: 0; top: 50%;
  height: 1px;
  background: var(--border-subtle);
}
.gr-seg {
  position: absolute;
  top: 50%;
  height: 8px;
  margin-top: -4px;
  border-radius: 8px;
  background: var(--concede-warm);
  opacity: 0.28;
}
.gr-dot {
  position: absolute;
  top: 50%;
  width: 14px;
  height: 14px;
  margin: -7px 0 0 -7px;
  border-radius: 50%;
  background: var(--ochre);
  box-sizing: border-box;
}
.gr-dot.hollow { background: var(--paper); border: 2.5px solid var(--concede-warm); }

.gr-gap {
  font-family: var(--serif);
  font-size: 1.2rem;
  letter-spacing: 0;
  text-transform: none;
  color: var(--ink-faint);
  font-variant-numeric: tabular-nums;
}
.gr-gap.open { color: var(--concede-warm); font-weight: 500; }

@media (max-width: 520px) {
  .gr-row { grid-template-columns: 5.4rem minmax(0, 1fr) 2.4rem; gap: 0.6rem; }
  .gr-topic { font-size: 1rem; }
  .gr-topic small { display: none; }
}
</style>
