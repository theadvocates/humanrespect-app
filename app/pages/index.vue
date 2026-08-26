<template>
  <div>
    <TheTurn />

    <!-- Everything below is server-rendered prose. It exists for two audiences:
         people who scroll past the interaction wanting to know what this is,
         and crawlers — which previously found 191 words on this page and
         almost nothing on any other. -->
    <section class="explain">
      <div class="explain-inner">
        <p class="explain-eyebrow">What this is</p>

        <h2 class="explain-head">
          Most people hold one moral standard for their own life
          and a different one for politics.
        </h2>

        <p class="explain-body">
          In your own relationships you already act on a principle you've
          probably never put into words: you don't get what you want by forcing
          the people you care about. You persuade them, or you live with the
          disagreement. You know — from experience, not from theory — that force
          produces compliance rather than agreement, and that it costs you the
          relationship in the process.
        </p>

        <p class="explain-body">
          The <strong>Philosophy of Human Respect</strong> makes a single
          observation about that: the pattern scales. What holds between two
          people holds between two million. Human flourishing reliably increases
          in conditions of voluntary cooperation, and reliably decreases where
          coercion, violence, or the involuntary loss of time or property occur.
          The mechanism changes — a controlling partner, an authoritarian
          employer, a neighbourhood bully, a democratic majority — but the effect
          on the person being forced does not.
        </p>

        <p class="explain-body">
          The philosophy was articulated by Chris J. Rufer, founder of The
          Morning Star Company, whose businesses have operated for decades
          without managers, titles, or command hierarchy — an unusually literal
          test of whether voluntary cooperation actually organises complex work.
        </p>

        <h3 class="explain-sub">What you'll find here</h3>

        <p class="explain-body">
          Fifteen interactive experiences, arranged so that none of them is
          required. The question above takes a minute. The
          <NuxtLink :to="{ name: 'exp02' }" class="explain-link">objection</NuxtLink>
          takes four, and exists because the first response most people have is
          resistance — so it argues the strongest case <em>against</em> the
          philosophy before answering it. The
          <NuxtLink :to="{ name: 'exp03' }" class="explain-link">evidence</NuxtLink>
          takes eight, drawn from your own life rather than from political theory.
        </p>

        <p class="explain-body">
          Beyond those sit five <strong>pillars</strong> — bodily integrity,
          time, property, method, and cooperation as a technology — and five
          <strong>practices</strong> that turn the idea into something you
          actually do: mapping where you currently support coercion, designing a
          persuasion-only approach to an issue you care about, and having the
          conversation with someone who disagrees.
        </p>

        <p class="explain-body">
          There is no score, no personality type, and no answer key. Nothing is
          gated behind an email address. The experiences are designed to surface
          what you already believe and then ask one question about it.
        </p>

        <div class="explain-paths">
          <NuxtLink to="/your-journey" class="explain-cta">See all fifteen <span aria-hidden="true">→</span></NuxtLink>
          <NuxtLink to="/about" class="explain-cta explain-cta-quiet">Why this exists</NuxtLink>
        </div>
      </div>
    </section>

    <footer class="footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <NuxtLink to="/about" class="footer-link">About</NuxtLink>
          <NuxtLink to="/privacy" class="footer-link">Privacy</NuxtLink>
          <NuxtLink to="/terms" class="footer-link">Terms</NuxtLink>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import TheTurn from '@/components/turn/TheTurn.vue'

definePageMeta({ name: 'home' })
usePageSeo('home')
</script>

<style scoped>
.explain {
  background: var(--paper-warm);
  border-top: 1px solid var(--border-subtle);
  padding: 6rem 1.5rem;
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
  font-size: clamp(1.6rem, 3.4vw, 2.2rem);
  font-weight: 400;
  line-height: 1.3;
  letter-spacing: -0.015em;
  color: var(--ink);
  margin: 0 0 2rem;
  text-wrap: balance;
}

.explain-sub {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-weight: 500;
  color: var(--ink);
  margin: 3rem 0 1.25rem;
}

.explain-body {
  font-family: var(--sans);
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin: 0 0 1.4rem;
}
.explain-body strong { color: var(--ink); font-weight: 500; }

.explain-link {
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s ease;
}
.explain-link:hover { border-bottom-color: var(--ochre); }

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

.footer {
  padding: 2.5rem 1.5rem;
  background: var(--paper);
  border-top: 1px solid var(--border-subtle);
}
.footer-inner {
  max-width: 40rem;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}
.footer-left { font-family: var(--serif); font-size: 0.9rem; color: var(--ink-muted); }
.footer-right { display: flex; gap: 1.5rem; }
.footer-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--ink-faint);
  text-decoration: none;
  transition: color 0.2s ease;
}
.footer-link:hover { color: var(--ink-muted); }

@media (max-width: 640px) {
  .explain { padding: 4rem 1.15rem; }
}
</style>
