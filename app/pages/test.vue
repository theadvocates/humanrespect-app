<template>
  <div>
    <RespectTest />

    <!-- Server-rendered, for the same two audiences as the home page: people
         who scroll past the test wanting to know what it is, and crawlers,
         which never see past the intro screen. -->
    <section class="explain">
      <div class="explain-inner">
        <p class="explain-eyebrow">About this test</p>

        <h2 class="explain-head">
          Almost everyone persuades in their own life. The question is whether
          that changes when someone else does the forcing.
        </h2>

        <p class="explain-body">
          There are three ways to gather what it takes to solve a problem: put
          in your own time and money, persuade others to help, or force them.
          The first half of this test asks which you'd choose when it's up to
          you. The second half asks the same questions when a vote, a law, or a
          leader acts on your behalf.
        </p>

        <p class="explain-body">
          The two halves are matched, topic by topic, so the difference between
          your scores is a real measurement: how much more comfortable you are
          with force once you've delegated it. The <strong>Philosophy of Human
          Respect</strong> holds that the difference shouldn't exist. Force,
          theft, and violence reliably reduce happiness, harmony, and prosperity,
          and none of that changes with whose hand is on them. If you ask
          someone to act for you, what they do is on you.
        </p>

        <p class="explain-body">
          The test doesn't place you left or right. Liberal and conservative
          values are both good values to live by, and most people hold some of
          each. What it measures is the method you'd use to advance yours.
        </p>

        <div class="explain-paths">
          <NuxtLink to="/" class="explain-cta">Try the one-minute argument <span aria-hidden="true">→</span></NuxtLink>
          <NuxtLink to="/about" class="explain-cta explain-cta-quiet">Why this exists</NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import RespectTest from '@/components/test/RespectTest.vue'

definePageMeta({ name: 'test' })
usePageSeo('test')
</script>

<style scoped>
.explain {
  background: var(--paper-warm);
  border-top: 1px solid var(--border-subtle);
  padding: 5rem 1.5rem;
}
.explain-inner { max-width: 40rem; margin: 0 auto; }

.explain-eyebrow {
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin: 0 0 1.5rem;
}

.explain-head {
  font-family: var(--serif);
  font-size: clamp(1.5rem, 3.2vw, 2rem);
  font-weight: 400;
  line-height: 1.3;
  letter-spacing: -0.015em;
  color: var(--ink);
  margin: 0 0 2rem;
  text-wrap: balance;
}

.explain-body {
  font-family: var(--sans);
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin: 0 0 1.4rem;
}
.explain-body strong { color: var(--ink); font-weight: 500; }

.explain-paths { display: flex; flex-wrap: wrap; gap: 1.75rem; margin-top: 2.5rem; }
.explain-cta {
  font-family: var(--serif);
  font-size: 1.08rem;
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s ease;
}
.explain-cta:hover { border-bottom-color: var(--ochre); }
.explain-cta-quiet { color: var(--ink-muted); }
.explain-cta-quiet:hover { border-bottom-color: var(--ink-faint); }

@media (max-width: 640px) {
  .explain { padding: 4rem 1.15rem; }
}
</style>
