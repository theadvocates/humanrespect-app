<template>
  <div class="page">
    <div class="cert-container">
      <template v-if="cert">
        <div class="cert">
          <div class="cert-mark"/>
          <p class="cert-eyebrow">The Philosophy of Human Respect</p>
          <p class="cert-preamble">This certifies that</p>
          <h1 class="cert-name">{{ cert.recipient_name }}</h1>
          <p class="cert-preamble">has completed the</p>
          <p class="cert-tier">{{ tierLabel }}</p>
          <div class="cert-rule"/>
          <p class="cert-date">{{ issuedDate }}</p>
        </div>

        <p class="cert-verify">
          Verified certificate · humanrespect.app/certificate/{{ code }}
        </p>

        <div class="cert-cta">
          <p class="body-text">
            This is a record of someone working through a set of questions about
            force, cooperation, and how people should treat one another.
          </p>
          <router-link :to="{ name: 'exp01' }" class="cta-link">
            Begin the experiment yourself →
          </router-link>
        </div>
      </template>

      <template v-else>
        <h1 class="display-medium">No certificate found.</h1>
        <p class="body-text" style="margin-top: 1rem;">
          This code doesn't match any certificate we've issued.
        </p>
        <router-link to="/" class="cta-link">Return home →</router-link>
      </template>
    </div>
  </div>
</template>

<script setup>
import { getSupabase } from '@/lib/supabase'
import { SITE_URL } from '@/utils/seo'

definePageMeta({ name: 'certificate' })

const route = useRoute()
const code = computed(() => route.params.code)

const TIER_LABELS = {
  foundation: 'Foundation',
  argument: 'Arguments',
  pillar: 'Pillars',
  practice: 'Practices'
}

// Fetched with useAsyncData so the certificate renders server-side — these
// pages get shared, and a share preview needs the recipient's name in the HTML.
const { data: cert } = await useAsyncData(
  () => `certificate-${code.value}`,
  async () => {
    const supabase = getSupabase()
    if (!supabase) return null
    const { data, error } = await supabase.rpc('verify_certificate', { p_code: code.value })
    if (error || !data?.length) return null
    return data[0]
  }
)

const tierLabel = computed(() =>
  cert.value ? `${TIER_LABELS[cert.value.tier] || cert.value.tier} of the philosophy` : ''
)

const issuedDate = computed(() => {
  if (!cert.value?.issued_at) return ''
  return new Date(cert.value.issued_at).toLocaleDateString('en-US', {
    year: 'numeric', month: 'long', day: 'numeric'
  })
})

const seoTitle = computed(() =>
  cert.value
    ? `${cert.value.recipient_name} — ${TIER_LABELS[cert.value.tier] || ''} Certificate`
    : 'Certificate'
)

useSeoMeta({
  title: () => `${seoTitle.value} — Human Respect`,
  description: () =>
    cert.value
      ? `${cert.value.recipient_name} completed the ${TIER_LABELS[cert.value.tier]} of the Philosophy of Human Respect.`
      : 'Verify a Human Respect certificate.',
  ogTitle: seoTitle,
  ogUrl: () => `${SITE_URL}/certificate/${code.value}`,
  ogImage: `${SITE_URL}/og-default.png`,
  twitterCard: 'summary_large_image'
})
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--paper);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 5rem 1.5rem;
}
.cert-container { max-width: 620px; width: 100%; text-align: center; }

.cert {
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
  padding: 4rem 2.5rem;
  box-shadow: var(--shadow-soft);
}

.cert-mark { width: 32px; height: 1px; background: var(--ochre); margin: 0 auto 2.5rem; }

.cert-eyebrow {
  font-family: var(--sans);
  font-size: 0.7rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 2.5rem;
}

.cert-preamble {
  font-family: var(--sans);
  font-size: 0.85rem;
  color: var(--ink-muted);
  letter-spacing: 0.02em;
}

.cert-name {
  font-family: var(--serif);
  font-size: clamp(2rem, 6vw, 3rem);
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: -0.02em;
  color: var(--ink);
  margin: 0.75rem 0 1.75rem;
}

.cert-tier {
  font-family: var(--serif);
  font-size: 1.35rem;
  font-style: italic;
  font-weight: 300;
  color: var(--ink-soft);
  margin-top: 0.5rem;
}

.cert-rule { width: 60px; height: 1px; background: var(--border-subtle); margin: 2.5rem auto 1.5rem; }

.cert-date { font-family: var(--sans); font-size: 0.82rem; color: var(--ink-faint); letter-spacing: 0.03em; }

.cert-verify {
  margin-top: 1.25rem;
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.05em;
  color: var(--ink-faint);
}

.cert-cta { margin-top: 3.5rem; }
.cta-link {
  display: inline-block;
  margin-top: 1.5rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color var(--transition);
}
.cta-link:hover { border-bottom-color: var(--ochre); }

@media (max-width: 480px) {
  .cert { padding: 3rem 1.5rem; }
}

@media print {
  .page { padding: 0; }
  .cert { border: none; box-shadow: none; }
  .cert-cta, .cert-verify { display: none; }
}
</style>
