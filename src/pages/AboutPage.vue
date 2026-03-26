<template>
  <div class="page">
    <div class="page-container">

      <p class="caption">About</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">Why this exists.</h1>
      <Divider />

      <p class="body-text-large">We live in an era of permanent political conflict. Left against right. Progressive against conservative. Every election is a battle, every policy debate a war, every disagreement a threat.</p>

      <p class="body-text-large">But the conflict may not actually be about values.</p>

      <p class="body-text">Most people share the same fundamental drive: to live well, to care for the people they love, to build something meaningful, and to be left in peace to do it. Progressive and conservative values are both genuine expressions of that drive. The real divide is not <em>what</em> people want. It's <em>how</em> they propose to get it.</p>

      <p class="body-text">And almost everyone, on every side, has settled on the same method: force. Capture political power. Pass laws. Compel compliance. Punish dissent. Use the machinery of government to impose your values on people who didn't choose them.</p>

      <p class="body-text">The Philosophy of Human Respect asks a different question: <em>What if we advanced our values through persuasion and voluntary cooperation instead?</em></p>

      <!-- THE PHILOSOPHY -->
      <h2 class="section-heading">The Philosophy</h2>
      <Divider />

      <p class="body-text">The Philosophy of Human Respect begins with an observation about human nature: every person possesses three domains of integrity, their body, their resources, and their time. When these domains are respected, people flourish. When they're violated through violence, theft, or coercion, flourishing predictably declines.</p>

      <p class="body-text">This pattern is grounded in psychology, neuroscience, economics, and the lived experience of every human being. You can test it against your own life: the best periods had safety, autonomy, and opportunity present. The worst periods had one or more of those domains under attack.</p>

      <p class="body-text">From this foundation emerges a principle:</p>

      <ContentBlock variant="principle">
        <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
      </ContentBlock>

      <p class="body-text">The implications reach further than you'd expect. Most people already live by this principle in their personal lives. They don't steal from neighbors. They don't threaten coworkers. They solve problems through conversation and voluntary agreement.</p>

      <p class="body-text">The philosophy simply asks: can we extend that same principle to how we organize society?</p>

      <!-- WHAT THIS SITE IS -->
      <h2 class="section-heading">What this site is</h2>
      <Divider />

      <p class="body-text">humanrespect.app is a series of interactive experiences designed to help you discover the Philosophy of Human Respect through your own reasoning. Not by being told what to think, but by examining what you already believe.</p>

      <p class="body-text">Each experience uses questions, scenarios, and reflections to surface insights about the relationship between force, cooperation, and human flourishing. There are no scores, no grades, no personality types. Just your own thinking, reflected back to you.</p>

      <p class="body-text">The experiences are organized in three tiers: a foundation sequence that introduces the core ideas, a set of deeper explorations into specific dimensions of the philosophy, and a practice layer that helps you apply the ideas to your own life.</p>

      <p class="body-text">Everything on this site is free. No ads, no paywalls, no data sold to third parties.</p>

      <!-- THE PHILOSOPHER -->
      <h2 class="section-heading">The philosopher</h2>
      <Divider />

      <p class="body-text">The Philosophy of Human Respect was articulated by Chris J. Rufer, founder of The Morning Star Company and a lifelong advocate for voluntary cooperation. Drawing on decades of observation about human nature and social systems, Rufer identified that sustainable solutions to social challenges come not from forcing values on others, but from persuading people to cooperate voluntarily.</p>

      <p class="body-text">The philosophy builds on insights from psychology, neuroscience, self-determination theory, and economics. But its core claim is simple enough for a child to understand: don't hurt people, don't take their stuff, and don't waste their time.</p>

      <!-- THE PROOF -->
      <h2 class="section-heading">The proof</h2>
      <Divider />

      <p class="body-text">Rufer doesn't just write about voluntary cooperation. He runs a company on it.</p>

      <p class="body-text">The Morning Star Company, which he founded in 1970, is the world's largest tomato processor, with over $800 million in annual revenue, three factories, and thousands of employees. It operates with no bosses, no management hierarchy, and no titles. Every organizational decision rests on two principles that will sound familiar: all interactions should be voluntary, and people should honor their commitments.</p>

      <p class="body-text">Morning Star calls this Mission Focused Self-Management. Colleagues define their own roles, negotiate responsibilities directly with each other, make purchasing decisions in consultation with peers, and set their own compensation through a process of peer evaluation. Conflicts are resolved through direct conversation, not top-down authority. Harvard Business School has studied the model. So have researchers in organizational behavior around the world.</p>

      <p class="body-text">The result: a one-truck operation that grew into a global market leader processing roughly 40% of California's tomato crop, all without anyone being told what to do by a boss.</p>

      <p class="body-text">The Philosophy of Human Respect is not an armchair theory. It's the articulation of principles that have been tested in a real business, with real people, for over fifty years.</p>

      <!-- CONTACT -->
      <h2 class="section-heading">Contact</h2>
      <Divider />

      <p class="body-text">Questions, thoughts, or disagreements are welcome at <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a>.</p>

      <p class="body-text">We mean that. If you went through one of the experiences and found a flaw in the reasoning, an objection we didn't address, or a place where the philosophy falls short, we want to hear it. A philosophy that can't withstand honest criticism isn't worth promoting.</p>

      <!-- CTA -->
      <div style="margin-top: 3rem;">
        <PathCard :to="{ name: 'exp01' }">
          <template #title>Start the experience</template>
          <template #desc>A five-minute philosophical experiment that reveals something about your own moral reasoning.</template>
        </PathCard>
      </div>

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'

onMounted(() => document.body.classList.remove('dark-mode'))
</script>

<style scoped>
.page {
  background: var(--paper);
  min-height: 100vh;
}

.page-container {
  max-width: 640px;
  margin: 0 auto;
  padding: 5rem 1.5rem 4rem;
}

.section-heading {
  font-family: var(--serif);
  font-size: 1.4rem;
  font-weight: 500;
  color: var(--ink);
  margin-top: 3.5rem;
}

.body-text-large {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1.25rem;
}

.body-text {
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1rem;
}

.body-text em {
  color: var(--ink);
}

.text-link {
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s;
}

.text-link:hover {
  border-bottom-color: var(--ochre);
}

/* Footer */
.page-footer {
  padding: 3rem 1.5rem;
  background: var(--ink);
  display: flex;
  justify-content: center;
}

.footer-inner {
  max-width: 640px;
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-left {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: rgba(244, 240, 234, 0.3);
}

.footer-right { display: flex; gap: 2rem; }

.footer-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(244, 240, 234, 0.25);
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 3.5rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
