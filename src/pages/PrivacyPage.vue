<template>
  <div class="page">
    <div class="page-container">

      <p class="caption">Privacy</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">How we handle your data.</h1>
      <Divider />

      <p class="body-text">We believe in transparency. This page explains exactly what data we collect, why we collect it, and what we do with it. No legal fog. No buried clauses.</p>

      <!-- WHAT WE COLLECT -->
      <h2 class="section-heading">What we collect</h2>
      <Divider />

      <p class="body-text"><strong>Anonymous usage data.</strong> When you go through experiences on this site, we record which screens you visit, which choices you make, and whether you complete each experience. This data is tied to a randomly generated ID stored in your browser, not to your name, email, or any identifying information. We use this data to understand which experiences resonate, where people drop off, and how to improve the content.</p>

      <p class="body-text"><strong>Basic traffic data.</strong> We use Cloudflare Web Analytics to understand how many people visit the site, what devices they use, and where traffic comes from. Cloudflare collects this data without using cookies and without tracking individual users across sites.</p>

      <p class="body-text"><strong>Newsletter signups.</strong> If you choose to subscribe to our weekly email, we store your email address and which experience you subscribed from. This is the only personally identifiable information we collect, and only because you gave it to us voluntarily.</p>

      <p class="body-text"><strong>Local preferences.</strong> Your journey progress (which experiences you've completed, your answers to interactive questions) is stored in your browser's local storage. This stays on your device. It's what allows the site to remember where you left off when you return. You can clear it anytime through your browser settings.</p>

      <!-- WHAT WE DON'T DO -->
      <h2 class="section-heading">What we don't do</h2>
      <Divider />

      <p class="body-text">We don't sell your data to anyone. We don't share it with advertisers. We don't use tracking cookies. We don't run retargeting campaigns. We don't use Google Analytics. We don't build profiles that follow you across the internet.</p>

      <p class="body-text">We don't gate any content behind email capture. Every experience on this site is fully accessible without signing up for anything.</p>

      <!-- WHY WE TRACK -->
      <h2 class="section-heading">Why we track anything at all</h2>
      <Divider />

      <p class="body-text">Honest answer: because we want to know if the philosophy is landing.</p>

      <p class="body-text">If 80% of visitors drop off at the same screen, that screen needs rewriting. If one objection path resonates more than others, that tells us something about what people are actually thinking. If the Pillar on Temporal Integrity has twice the completion rate of the one on Material Integrity, we should understand why.</p>

      <p class="body-text">We track engagement to make the experiences better. That's it.</p>

      <!-- YOUR CHOICES -->
      <h2 class="section-heading">Your choices</h2>
      <Divider />

      <p class="body-text">You can use this entire site without giving us any personal information. Your anonymous usage data helps us improve, but if you prefer not to contribute even that, a standard ad blocker will prevent the analytics scripts from loading. The experiences will still work perfectly.</p>

      <p class="body-text">If you subscribed to the newsletter and want to unsubscribe, every email includes an unsubscribe link. If you want your email removed from our database entirely, send a request to <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a> and we'll delete it.</p>

      <p class="body-text">To clear your local journey data, open your browser's developer tools, go to Application, find Local Storage for humanrespect.app, and delete the entry. Or just use your browser's "clear site data" option.</p>

      <!-- SHORT VERSION -->
      <h2 class="section-heading">The short version</h2>
      <Divider />

      <p class="body-text">We collect anonymous data to improve the site. We collect your email only if you give it to us. We don't sell anything to anyone. We respect your time, your attention, and your privacy. It's kind of our whole philosophy.</p>

      <p class="body-text" style="margin-top: 2rem;">Questions? <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a></p>

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

.body-text {
  font-size: 1rem;
  line-height: 1.8;
  color: var(--ink-soft);
  margin-top: 1rem;
}

.body-text strong {
  color: var(--ink);
  font-weight: 500;
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
