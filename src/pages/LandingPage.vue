<template>
  <div>
    <!-- Hero -->
    <section class="hero">
      <div class="hero-mark"></div>
      <h1 class="hero-headline">
        You live by a moral code<br>
        <em>you've never put into words.</em>
      </h1>
      <p class="hero-sub">A five-minute philosophical experiment</p>
      <router-link :to="{ name: 'exp01' }" class="hero-begin">
        Begin <span class="arrow">→</span>
      </router-link>
      <div class="hero-scroll-hint" ref="scrollHint">
        <span>Or learn more</span>
        <div class="scroll-line"></div>
      </div>
    </section>

    <!-- Context -->
    <section class="context">
      <div class="context-inner reveal">
        <div class="context-label">What this is</div>
        <p class="context-text">
          Most people hold <strong>one moral standard</strong> for their personal life
          and <strong>a completely different one</strong> for politics — without ever
          noticing the gap.
        </p>
        <p class="context-detail">
          This short experience uses a single thought experiment to surface
          that gap in your own thinking. It doesn't tell you what to believe.
          It shows you what you already believe — and asks one question
          you've probably never considered.
        </p>
        <router-link :to="{ name: 'exp01' }" class="context-cta">
          Start the experiment <span class="arrow">→</span>
        </router-link>
      </div>
    </section>

    <!-- Attributes -->
    <section class="attributes">
      <div class="attributes-inner reveal-stagger">
        <div class="attribute">
          <span class="attribute-number">01</span>
          <div class="attribute-title">Five minutes</div>
          <p class="attribute-desc">
            Two questions. One mirror. An insight
            that stays with you longer than it should.
          </p>
        </div>
        <div class="attribute">
          <span class="attribute-number">02</span>
          <div class="attribute-title">No right answers</div>
          <p class="attribute-desc">
            This isn't a quiz. There's no score, no grade,
            no personality type. Just your own thinking,
            reflected back.
          </p>
        </div>
        <div class="attribute">
          <span class="attribute-number">03</span>
          <div class="attribute-title">Worth sharing</div>
          <p class="attribute-desc">
            The best part is finding out how someone you
            disagree with answers the same questions.
          </p>
        </div>
      </div>
    </section>

    <!-- Closing -->
    <section class="closing">
      <p class="closing-headline reveal">
        Every person you've ever argued with about politics
        shares something fundamental with you.<br><br>
        This is how you find out what it is.
      </p>
      <router-link :to="{ name: 'exp01' }" class="closing-begin reveal">
        Begin the experiment <span class="arrow">→</span>
      </router-link>
    </section>

    <!-- Footer -->
    <footer class="footer">
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
import { onMounted, onUnmounted, ref } from 'vue'
import { useScrollReveal } from '@/composables/useScrollReveal'

useScrollReveal()

const scrollHint = ref(null)
let scrollHidden = false

function handleScroll() {
  if (!scrollHidden && window.scrollY > 80 && scrollHint.value) {
    scrollHint.value.style.opacity = '0'
    scrollHint.value.style.transition = 'opacity 0.5s ease'
    scrollHidden = true
  }
}

onMounted(() => {
  // Ensure dark mode is off on landing page
  document.body.classList.remove('dark-mode')
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* ── Hero ── */
.hero {
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 4rem 2rem;
  position: relative;
}

.hero-mark {
  width: 32px;
  height: 1px;
  background: var(--ochre);
  margin-bottom: 3rem;
  opacity: 0;
  animation: fadeIn 1s ease 0.3s forwards;
}

.hero-headline {
  font-family: var(--serif);
  font-size: clamp(2.2rem, 5.5vw, 3.8rem);
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: -0.025em;
  color: var(--ink);
  max-width: 720px;
  opacity: 0;
  animation: revealUp 1.2s cubic-bezier(0.22, 1, 0.36, 1) 0.5s forwards;
}

.hero-headline em {
  font-style: italic;
  font-weight: 300;
  color: var(--ink-soft);
}

.hero-sub {
  font-family: var(--sans);
  font-size: 0.95rem;
  font-weight: 400;
  color: var(--ink-muted);
  margin-top: 2.5rem;
  letter-spacing: 0.01em;
  opacity: 0;
  animation: fadeIn 1s ease 1.4s forwards;
}

.hero-begin {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 3.5rem;
  padding: 0.9rem 2.5rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  letter-spacing: 0.03em;
  color: var(--ochre);
  background: transparent;
  border: 1px solid var(--ochre);
  border-radius: 100px;
  cursor: pointer;
  text-decoration: none;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  opacity: 0;
  animation: fadeIn 0.8s ease 1.8s forwards;
  -webkit-tap-highlight-color: transparent;
}

.hero-begin:hover {
  background: var(--ochre);
  color: var(--cream);
  transform: translateY(-1px);
  box-shadow: 0 4px 20px rgba(154, 123, 79, 0.2);
}

.hero-begin .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
}

.hero-begin:hover .arrow {
  transform: translateX(4px);
}

.hero-scroll-hint {
  position: absolute;
  bottom: 2.5rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  opacity: 0;
  animation: fadeIn 1s ease 3s forwards;
}

.hero-scroll-hint span {
  font-size: 0.65rem;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--ink-faint);
}

.scroll-line {
  width: 1px;
  height: 28px;
  background: linear-gradient(to bottom, var(--ink-faint), transparent);
  animation: pulseDown 2s ease-in-out infinite;
}

/* ── Context ── */
.context {
  padding: 8rem 2rem;
  display: flex;
  justify-content: center;
  background: var(--cream);
  border-top: 1px solid var(--paper-deep);
}

.context-inner { max-width: 560px; width: 100%; }

.context-label {
  font-size: 0.65rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 2rem;
}

.context-text {
  font-family: var(--serif);
  font-size: 1.35rem;
  font-weight: 400;
  line-height: 1.65;
  color: var(--ink-soft);
}

.context-text strong { color: var(--ink); font-weight: 500; }

.context-detail {
  font-family: var(--sans);
  font-size: 0.88rem;
  line-height: 1.8;
  color: var(--ink-muted);
  margin-top: 2.5rem;
}

.context-cta {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 2.5rem;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s ease;
}

.context-cta:hover { border-bottom-color: var(--ochre); }
.context-cta .arrow { display: inline-block; transition: transform 0.3s ease; }
.context-cta:hover .arrow { transform: translateX(4px); }

/* ── Attributes ── */
.attributes {
  padding: 6rem 2rem;
  display: flex;
  justify-content: center;
  background: var(--paper);
}

.attributes-inner {
  max-width: 720px;
  width: 100%;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 3rem;
}

.attribute { text-align: left; }

.attribute-number {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--ochre);
  margin-bottom: 0.75rem;
  display: block;
}

.attribute-title {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.5rem;
  line-height: 1.3;
}

.attribute-desc {
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-muted);
  line-height: 1.65;
}

/* ── Closing ── */
.closing {
  padding: 8rem 2rem;
  text-align: center;
  background: var(--ink);
  color: var(--paper);
  position: relative;
}

.closing::before {
  content: '';
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 1px;
  height: 60px;
  background: linear-gradient(to bottom, var(--paper-deep), var(--ink));
}

.closing-headline {
  font-family: var(--serif);
  font-size: clamp(1.4rem, 3.5vw, 2rem);
  font-weight: 300;
  font-style: italic;
  line-height: 1.45;
  color: var(--paper-warm);
  max-width: 480px;
  margin: 0 auto;
}

.closing-begin {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 3rem;
  padding: 0.85rem 2.5rem;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  letter-spacing: 0.03em;
  color: var(--ochre-light);
  background: transparent;
  border: 1px solid rgba(184, 153, 94, 0.4);
  border-radius: 100px;
  text-decoration: none;
  transition: all 0.4s ease;
  -webkit-tap-highlight-color: transparent;
}

.closing-begin:hover {
  background: var(--ochre);
  color: var(--ink);
  border-color: var(--ochre);
}

.closing-begin .arrow { display: inline-block; transition: transform 0.3s ease; }
.closing-begin:hover .arrow { transform: translateX(4px); }

/* ── Footer ── */
.footer {
  padding: 3rem 2rem;
  background: var(--ink);
  border-top: 1px solid rgba(244, 240, 234, 0.06);
  display: flex;
  justify-content: center;
}

.footer-inner {
  max-width: 720px;
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

/* ── Keyframes ── */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes revealUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes pulseDown {
  0%, 100% { opacity: 0.3; transform: scaleY(1); }
  50% { opacity: 0.7; transform: scaleY(1.2); transform-origin: top; }
}

/* ── Responsive ── */
@media (max-width: 680px) {
  .hero { padding: 3rem 1.5rem; }
  .context { padding: 5rem 1.5rem; }
  .attributes { padding: 4rem 1.5rem; }
  .attributes-inner {
    grid-template-columns: 1fr;
    gap: 2.5rem;
  }
  .attribute {
    padding-left: 1rem;
    border-left: 1px solid var(--paper-deep);
  }
  .closing { padding: 5rem 1.5rem; }
  .footer-inner {
    flex-direction: column;
    gap: 1.5rem;
    text-align: center;
  }
  .hero-scroll-hint { display: none; }
}

@media (max-width: 480px) {
  .hero { padding: 2.5rem 1.25rem; }
  .hero-headline { font-size: clamp(1.8rem, 7vw, 2.4rem); }
  .hero-begin { padding: 0.85rem 2rem; font-size: 1rem; }
  .context { padding: 3.5rem 1.25rem; }
  .context-text { font-size: 1.15rem; }
  .attributes { padding: 3rem 1.25rem; }
  .closing { padding: 3.5rem 1.25rem; }
  .closing-begin { padding: 0.85rem 2rem; }
}
</style>
