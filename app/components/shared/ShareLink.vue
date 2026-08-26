<template>
  <div class="share">
    <p v-if="prompt" class="share-prompt">{{ prompt }}</p>

    <div class="share-actions">
      <!-- Native sheet where it exists — on mobile it opens the apps people
           actually use, which no hand-built list can match. -->
      <button v-if="canShareNatively" class="share-btn share-btn-primary" @click="shareNative">
        <svg class="share-icon" viewBox="0 0 24 24" aria-hidden="true">
          <path
            d="M12 3v13M12 3l-4 4M12 3l4 4M5 14v5a2 2 0 002 2h10a2 2 0 002-2v-5"
            fill="none" stroke="currentColor" stroke-width="1.6"
            stroke-linecap="round" stroke-linejoin="round"
          />
        </svg>
        Share
      </button>

      <button class="share-btn" :class="{ done: copied }" @click="copy">
        <svg v-if="!copied" class="share-icon" viewBox="0 0 24 24" aria-hidden="true">
          <rect x="9" y="9" width="11" height="11" rx="2" fill="none" stroke="currentColor" stroke-width="1.6"/>
          <path d="M5 15V5a2 2 0 012-2h10" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
        </svg>
        <span v-else class="share-icon" aria-hidden="true">✓</span>
        {{ copied ? 'Link copied' : 'Copy link' }}
      </button>

      <a class="share-btn" :href="xUrl" target="_blank" rel="noopener noreferrer" @click="track('x')">
        <span class="share-icon" aria-hidden="true">𝕏</span>
        Post
      </a>

      <a class="share-btn" :href="emailUrl" @click="track('email')">
        <svg class="share-icon" viewBox="0 0 24 24" aria-hidden="true">
          <rect x="3" y="5" width="18" height="14" rx="2" fill="none" stroke="currentColor" stroke-width="1.6"/>
          <path d="M3 7l9 6 9-6" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
        </svg>
        Email
      </a>
    </div>
  </div>
</template>

<script setup>
import { SITE_URL } from '@/utils/seo'

const props = defineProps({
  /** Path to share. Defaults to the home page, where the Turn lives. */
  path: { type: String, default: '/' },
  /** The line above the buttons. Set to '' to hide it. */
  prompt: { type: String, default: 'Send it to someone you disagree with.' },
  /** Text used by the native sheet, X, and the email body. */
  text: {
    type: String,
    default: "You wouldn't force someone you know to agree with you. So why is politics built on it? It's a one-minute question:"
  },
  subject: { type: String, default: 'A question I think you\'ll have an answer to' },
  /** Where this share happened, for analytics. */
  source: { type: String, default: 'unknown' }
})

const { trackShare } = useAnalytics()
const copied = ref(false)
const canShareNatively = ref(false)

// ?ref=share marks arrivals from the loop, so its actual contribution is
// measurable rather than assumed.
const url = computed(() => `${SITE_URL}${props.path}?ref=share`)
const xUrl = computed(() =>
  `https://x.com/intent/post?text=${encodeURIComponent(props.text)}&url=${encodeURIComponent(url.value)}`)
const emailUrl = computed(() =>
  `mailto:?subject=${encodeURIComponent(props.subject)}&body=${encodeURIComponent(props.text + '\n\n' + url.value)}`)

function track(method) {
  trackShare(method, props.source)
}

onMounted(() => {
  canShareNatively.value = typeof navigator !== 'undefined' && !!navigator.share
})

async function shareNative() {
  try {
    await navigator.share({ title: 'Human Respect', text: props.text, url: url.value })
    track('native')
  } catch (e) {
    // AbortError just means they closed the sheet; not worth reporting.
    if (e?.name !== 'AbortError') track('native_failed')
  }
}

async function copy() {
  try {
    await navigator.clipboard.writeText(url.value)
  } catch (e) {
    // Clipboard API needs a secure context and can be refused; fall back so
    // the button is never simply dead.
    const el = document.createElement('textarea')
    el.value = url.value
    el.setAttribute('readonly', '')
    el.style.position = 'fixed'
    el.style.opacity = '0'
    document.body.appendChild(el)
    el.select()
    try { document.execCommand('copy') } catch (err) { /* nothing left to try */ }
    document.body.removeChild(el)
  }
  copied.value = true
  track('copy')
  setTimeout(() => { copied.value = false }, 2200)
}
</script>

<style scoped>
.share { width: 100%; }

.share-prompt {
  font-family: var(--sans);
  font-size: 0.88rem;
  color: var(--ink-muted);
  margin: 0 0 0.9rem;
}

.share-actions { display: flex; flex-wrap: wrap; gap: 0.55rem; }

.share-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.6rem 1.1rem;
  font-family: var(--sans);
  font-size: 0.85rem;
  color: var(--ink-soft);
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: 100px;
  cursor: pointer;
  text-decoration: none;
  transition: border-color 0.2s ease, color 0.2s ease, background 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.share-btn:hover { border-color: var(--ochre); color: var(--ink); }
.share-btn-primary { border-color: var(--ochre-light); color: var(--ochre); }
.share-btn.done { border-color: var(--insight-green); color: var(--insight-green); }

.share-icon {
  width: 15px;
  height: 15px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.85rem;
  flex-shrink: 0;
}

@media (max-width: 640px) {
  .share-actions { gap: 0.45rem; }
  .share-btn { padding: 0.6rem 0.95rem; font-size: 0.82rem; }
}
</style>
