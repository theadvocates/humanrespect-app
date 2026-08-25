<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Terms</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">The agreement between us.</h1>
      <Divider />

      <p class="body-text">
        A site arguing that people should be persuaded rather than coerced shouldn't
        bury its terms in unreadable legalese. So here they are, plainly. Using this
        site means you accept them.
      </p>

      <h2 class="section-heading">What this is</h2>
      <Divider />

      <p class="body-text">
        Human Respect is a set of interactive philosophical experiences. It's educational
        material, offered freely. It isn't legal, financial, medical, or professional
        advice of any kind, and nothing here should be treated as a substitute for it.
      </p>

      <p class="body-text">
        The experiences are designed to prompt your own reasoning, not to deliver
        conclusions. We don't score you, grade you, or tell you what to believe.
      </p>

      <h2 class="section-heading">Who you're agreeing with</h2>
      <Divider />

      <p class="body-text">
        Human Respect is published by The Advocates for Self-Government. "We" and "us"
        mean them; "you" means you.
      </p>

      <p class="body-text">
        You need to be at least 16 to create an account. Anyone can read the site.
      </p>

      <h2 class="section-heading">Your account</h2>
      <Divider />

      <p class="body-text">
        You can use the entire site without an account. If you create one, you're
        responsible for the email address you sign in with and for anything done through
        your account. Tell us if you think someone else has access to it.
      </p>

      <p class="body-text">
        You can stop using the site at any time. If you'd like your account and its data
        deleted, email us and we'll remove it — see the
        <router-link to="/privacy" class="inline-link">privacy notice</router-link> for
        what we hold and why.
      </p>

      <h2 class="section-heading">What we ask of you</h2>
      <Divider />

      <p class="body-text">
        Don't attempt to break, overload, or gain unauthorized access to the site or its
        underlying systems. Don't use it to harass anyone. Don't scrape it in ways that
        degrade it for other people. Beyond that, we're not going to invent rules for
        their own sake.
      </p>

      <h2 class="section-heading">The content</h2>
      <Divider />

      <p class="body-text">
        The writing, design, and interactive experiences on this site belong to their
        authors. You're welcome to quote from them, share them, and discuss them —
        that's the point. You may not republish them wholesale as your own work.
      </p>

      <p class="body-text">
        Anything you type into an experience stays on your device unless you explicitly
        submit it. We don't claim ownership of your responses.
      </p>

      <h2 class="section-heading">No guarantees</h2>
      <Divider />

      <p class="body-text">
        The site is provided as-is. We work to keep it accurate and available, but we
        can't promise it will always be online, error-free, or that any particular
        content will remain unchanged. We may add, alter, or remove experiences over time.
      </p>

      <p class="body-text">
        To the extent the law allows, we aren't liable for losses arising from your use
        of the site. Some jurisdictions don't permit certain exclusions, in which case
        those don't apply to you.
      </p>

      <h2 class="section-heading">Ending things</h2>
      <Divider />

      <p class="body-text">
        You can delete your account at any time by emailing us. We may suspend or remove
        an account that is being used to attack the site or harass people — but we're not
        going to remove anyone for disagreeing with the philosophy. Disagreement is the
        entire point of the exercise.
      </p>

      <h2 class="section-heading">The legal boilerplate</h2>
      <Divider />

      <p class="body-text">
        These terms are governed by the laws of the State of Georgia, USA, without regard
        to conflict-of-law rules. If any part of them turns out to be unenforceable, the
        rest still stands.
      </p>

      <p class="body-text">
        Our total liability for any claim relating to this site is limited to what you
        paid us to use it, which is nothing. Nothing here excludes liability that cannot
        lawfully be excluded.
      </p>

      <p class="body-text">
        We link to other people's websites in places. We don't control them and aren't
        responsible for what's on them.
      </p>

      <h2 class="section-heading">Changes</h2>
      <Divider />

      <p class="body-text">
        If these terms change materially, we'll update this page. Continuing to use the
        site after a change means you accept the revised terms.
      </p>

      <h2 class="section-heading">Contact</h2>
      <Divider />

      <p class="body-text">
        Questions about any of this? Reach us at
        <a href="mailto:hello@humanrespect.app" class="inline-link">hello@humanrespect.app</a>.
      </p>

      <p class="body-text meta-note">
        Last updated 25 August 2026. See also our
        <router-link to="/privacy" class="inline-link">privacy notice</router-link>.
      </p>
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'

definePageMeta({ name: 'terms' })
usePageSeo('terms')
</script>

<style scoped>
.page { min-height: 100vh; background: var(--paper); }
.page-container { max-width: 680px; margin: 0 auto; padding: 6rem 1.5rem 5rem; }

.section-heading {
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 500;
  color: var(--ink);
  margin-top: 3rem;
}

.inline-link {
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color var(--transition);
}
.inline-link:hover { border-bottom-color: var(--ochre); }

.meta-note {
  margin-top: 3rem;
  font-size: 0.85rem;
  color: var(--ink-faint);
}

@media (max-width: 480px) {
  .page-container { padding: 5rem 1rem 3rem; }
}
</style>
