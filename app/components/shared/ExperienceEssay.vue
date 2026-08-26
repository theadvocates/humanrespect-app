<template>
  <!-- Viewport-anchored, so it can sit here in the DOM while appearing over
       the Opening screen above. Shown only on the Opening: past that the
       visitor has already chosen the interactive version, and offering them
       the other one mid-way is just a way out. -->
  <a v-if="showCue" class="essay-cue" :href="`#${anchor}`" @click="trackCue">
    Rather read it? {{ minutes }} min
    <span class="essay-cue-arrow" aria-hidden="true">↓</span>
  </a>

  <section :id="anchor" class="essay-section">
    <div class="essay-inner">
      <header class="essay-head">
        <p class="essay-eyebrow">The argument, in writing</p>
        <p class="essay-standfirst">{{ essay.standfirst }}</p>
        <p class="essay-time">{{ minutes }} minute read</p>
      </header>

      <article class="essay-body">
        <template v-for="(section, s) in essay.sections" :key="s">
          <h2 class="essay-heading">{{ section.heading }}</h2>
          <template v-for="(para, p) in section.body" :key="p">
            <!-- A **wrapped** paragraph is the one claim the section is built
                 around; it reads as a pull-quote rather than prose. -->
            <blockquote v-if="isPullQuote(para)" class="essay-quote">
              {{ stripMarks(para) }}
            </blockquote>
            <p v-else class="essay-para">{{ para }}</p>
          </template>
        </template>
      </article>

      <footer class="essay-foot">
        <p class="essay-attribution">
          From the Philosophy of Human Respect, articulated by Chris J. Rufer.
          <NuxtLink to="/about" class="essay-link">More about the philosophy</NuxtLink>.
        </p>
        <ShareLink
          :path="path"
          :prompt="sharePrompt"
          :source="`essay_${id}`"
          :subject="`${title} — a short read`"
        />
      </footer>
    </div>
  </section>
</template>

<script setup>
import ShareLink from '@/components/shared/ShareLink.vue'
import { readingMinutes } from '@/utils/reading.js'

const props = defineProps({
  /** Experience id, e.g. 'pillarB'. Names the essay file and the anchor. */
  id: { type: String, required: true },
  /** The essay object from app/content/essays/<id>.js. */
  essay: { type: Object, required: true },
  /** This experience's title and path, for the share card. */
  title: { type: String, required: true },
  path: { type: String, required: true },
  sharePrompt: {
    type: String,
    default: 'If the argument held up, send it to someone who would push back.'
  },
  /** True while the Opening screen is showing. Gates the scroll cue. */
  showCue: { type: Boolean, default: false }
})

const { capture } = useAnalytics()

const anchor = computed(() => `read-${props.id}`)
const minutes = computed(() => readingMinutes(props.essay))

const isPullQuote = (s) => s.startsWith('**') && s.endsWith('**')
const stripMarks = (s) => s.slice(2, -2)

// Whether anyone takes the read instead of the module is the whole question
// this section was built to answer, and it is not answerable by guessing.
function trackCue() {
  capture('essay_cue_clicked', { experience: props.id })
}
</script>

<style scoped>
/* The Opening screens are dark, and this is the only thing drawn over them. */
.essay-cue {
  position: fixed;
  left: 50%;
  bottom: 1.5rem;
  transform: translateX(-50%);
  z-index: 5;
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  padding: 0.5rem 1.05rem;
  font-family: var(--sans);
  font-size: 0.78rem;
  letter-spacing: 0.02em;
  color: var(--ochre-light);
  text-decoration: none;
  background: rgba(26, 26, 46, 0.72);
  border: 1px solid rgba(184, 153, 94, 0.3);
  border-radius: 100px;
  backdrop-filter: blur(6px);
  transition: border-color 0.25s ease, color 0.25s ease;
}

.essay-cue:hover {
  border-color: var(--ochre-light);
  color: var(--text-inverse);
}

.essay-cue-arrow {
  display: inline-block;
  animation: essay-cue-nudge 2.4s ease-in-out infinite;
}

@keyframes essay-cue-nudge {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(3px); }
}

/* Always light, whatever the experience above it is doing. The Opening screens
   put the body into dark mode, and this sits below them on the same page. */
.essay-section {
  background: var(--paper);
  color: var(--ink);
  border-top: 1px solid var(--border-subtle);
  padding: 5rem 1.5rem 6rem;
}

.essay-inner {
  max-width: 34rem;
  margin: 0 auto;
}

.essay-head {
  margin-bottom: 3rem;
}

.essay-eyebrow {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--ochre);
  margin: 0 0 1.25rem;
}

.essay-standfirst {
  font-family: var(--serif);
  font-size: 1.5rem;
  line-height: 1.45;
  color: var(--ink);
  margin: 0 0 1.25rem;
  text-wrap: balance;
}

.essay-time {
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-faint);
  margin: 0;
}

.essay-heading {
  font-family: var(--serif);
  font-size: 1.3rem;
  font-weight: 500;
  line-height: 1.35;
  color: var(--ink);
  margin: 2.75rem 0 1rem;
}

.essay-heading:first-child {
  margin-top: 0;
}

.essay-para {
  font-family: var(--sans);
  font-size: 1rem;
  line-height: 1.75;
  color: var(--ink-soft);
  margin: 0 0 1.15rem;
}

.essay-quote {
  margin: 1.9rem 0;
  padding-left: 1.4rem;
  border-left: 2px solid var(--ochre);
  font-family: var(--serif);
  font-size: 1.25rem;
  line-height: 1.5;
  color: var(--ink);
}

.essay-foot {
  margin-top: 3.5rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-subtle);
}

.essay-attribution {
  font-family: var(--sans);
  font-size: 0.85rem;
  line-height: 1.65;
  color: var(--ink-muted);
  margin: 0 0 2rem;
}

.essay-link {
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  text-decoration: none;
  transition: border-color 0.2s ease;
}

.essay-link:hover {
  border-bottom-color: var(--ochre);
}

@media (max-width: 640px) {
  .essay-section { padding: 3.5rem 1.35rem 4.5rem; }
  .essay-standfirst { font-size: 1.3rem; }
  .essay-quote { font-size: 1.12rem; padding-left: 1.1rem; }
}
</style>
