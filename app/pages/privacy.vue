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

      <p class="body-text"><strong>Basic traffic data.</strong> We use PostHog to understand how many people visit the site, which pages they read, and where traffic comes from. It runs without cookies — the anonymous ID it uses is the same one described above, kept in your browser's local storage and never shared with other sites. We don't record your screen, we don't build heatmaps, and we never transmit anything you type into the interactive questions.</p>

      <p class="body-text"><strong>Where those requests go.</strong> We should be straightforward about one detail, because we'd rather you heard it from us. Analytics requests are sent to <code class="inline-code">humanrespect.app/ingest</code> and forwarded from there, rather than going to PostHog's own address. This is ordinary practice and it makes the numbers more accurate, but it has a consequence worth stating: a content blocker that blocks PostHog by name will no longer stop these requests, because they no longer carry PostHog's name.</p>

      <p class="body-text">So that you keep a real choice: we honour your browser's <strong>Do Not Track</strong> setting, and when it's on we collect nothing at all. Blocking <code class="inline-code">humanrespect.app/ingest</code> also works and breaks nothing — the experiences run exactly the same either way. What we collect through that route is unchanged from what's described above: anonymous, first-party, never sold, never shared.</p>

      <p class="body-text"><strong>Account information.</strong> You don't need an account to use this site. If you create one, we store your email address so we can sign you in, and — if you sign in with Google — the name on your Google account, which we use only to put a name on a certificate. We never receive your Google password, and we ask Google for nothing beyond your email address and name.</p>

      <p class="body-text"><strong>Your progress, once you have an account.</strong> Signing in links the anonymous progress described above to your account so it follows you between devices. That means the choices you made in the experiences stop being purely anonymous to us and become associated with your email address. If you'd rather that didn't happen, simply don't create an account — everything on the site works without one.</p>

      <p class="body-text"><strong>Newsletter signups.</strong> If you choose to subscribe to our weekly email, we store your email address and which experience you subscribed from. This is the only personally identifiable information we collect, and only because you gave it to us voluntarily.</p>

      <p class="body-text"><strong>Local preferences.</strong> Your journey progress (which experiences you've completed, your answers to interactive questions) is stored in your browser's local storage. This stays on your device. It's what allows the site to remember where you left off when you return. You can clear it anytime through your browser settings.</p>

      <!-- WHAT WE DON'T DO -->
      <h2 class="section-heading">What we don't do</h2>
      <Divider />

      <p class="body-text">We don't route your data to advertisers. We don't sell your data to anyone. We don't share it with advertisers. We don't use tracking cookies. We don't run retargeting campaigns. We don't use Google Analytics. We don't record your screen or replay your sessions. We honour your browser's Do Not Track setting. We don't build profiles that follow you across the internet.</p>

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

      <!-- WHO ELSE TOUCHES IT -->
      <h2 class="section-heading">Who else handles your data</h2>
      <Divider />

      <p class="body-text">We run this site on services built by other companies. Each of them processes some data on our behalf, and none of them are permitted to use it for their own purposes:</p>

      <p class="body-text"><strong>Vercel</strong> hosts the site and processes the ordinary request information any web server sees. <strong>Supabase</strong> stores accounts, progress, and newsletter addresses. <strong>PostHog</strong> receives the anonymous usage data. <strong>Google</strong> is involved only if you choose to sign in with Google. <strong>Buttondown</strong> sends the newsletter, if you subscribe to it.</p>

      <p class="body-text">These services store data on servers in the United States. If you're reading this from elsewhere, that means your data is transferred there.</p>

      <!-- HOW LONG -->
      <h2 class="section-heading">How long we keep it</h2>
      <Divider />

      <p class="body-text">Anonymous usage data is kept indefinitely in aggregate, because its whole value is in long-run comparison. Account data is kept until you ask us to delete it. Newsletter addresses are kept until you unsubscribe. Ask us to delete your account and we remove it, along with the progress attached to it, within 30 days.</p>

      <!-- YOUR RIGHTS -->
      <h2 class="section-heading">Your rights over your data</h2>
      <Divider />

      <p class="body-text">Wherever you live, you can ask us what we hold about you, ask for a copy of it, ask us to correct it, or ask us to delete it. Email <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a> and we'll do it — we're not going to make you cite a regulation first.</p>

      <p class="body-text">If you're in the EU, UK, or California, you have these rights under law rather than merely by our goodwill, including the right to object to processing and the right not to be discriminated against for exercising them. We don't sell personal information, so there's nothing to opt out of on that front.</p>

      <!-- CHILDREN -->
      <h2 class="section-heading">Children</h2>
      <Divider />

      <p class="body-text">This site is written for adults and isn't directed at children. We don't knowingly collect personal information from anyone under 16. If you believe a child has given us their email address, tell us and we'll delete it.</p>

      <!-- SECURITY -->
      <h2 class="section-heading">Security</h2>
      <Divider />

      <p class="body-text">Data is transmitted over encrypted connections and stored in access-controlled databases. That said, no system is perfectly secure, and we won't pretend otherwise. If we ever discover a breach affecting your personal information, we'll tell you.</p>

      <!-- CHANGES -->
      <h2 class="section-heading">Changes to this policy</h2>
      <Divider />

      <p class="body-text">If we change how we handle data, we'll update this page and change the date at the bottom. If a change is significant and we have your email address, we'll tell you directly rather than quietly editing the page.</p>

      <!-- SHORT VERSION -->
      <h2 class="section-heading">The short version</h2>
      <Divider />

      <p class="body-text">We collect anonymous data to improve the site. We collect your email only if you give it to us. We don't sell anything to anyone. We respect your time, your attention, and your privacy. It's kind of our whole philosophy.</p>

      <p class="body-text" style="margin-top: 2rem;">Questions? <a href="mailto:hello@humanrespect.app" class="text-link">hello@humanrespect.app</a></p>

      <p class="body-text meta-note">Last updated 25 August 2026. See also our <router-link to="/terms" class="text-link">terms</router-link>.</p>

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
          <router-link to="/terms" class="footer-link">Terms</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'

definePageMeta({ name: 'privacy' })
usePageSeo('privacy')

</script>

<style scoped>
.meta-note { margin-top: 2.5rem; font-size: 0.85rem; color: var(--ink-faint); }
.inline-code {
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 0.88em;
  padding: 0.1em 0.35em;
  background: var(--paper-deep);
  border-radius: 3px;
}

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
