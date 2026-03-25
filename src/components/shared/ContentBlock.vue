<template>
  <div class="block" :class="variantClass">
    <span v-if="label" class="block-label">{{ label }}</span>
    <slot />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'principle',
    validator: v => ['principle', 'insight', 'mirror', 'concession'].includes(v)
  },
  label: { type: String, default: '' }
})

const variantClass = computed(() => `block-${props.variant}`)
</script>

<style scoped>
.block {
  padding: 1.5rem 1.75rem;
  margin: 2rem 0;
  border-radius: 0 var(--radius) var(--radius) 0;
}
.block :deep(p) { line-height: 1.7; }
.block :deep(p + p) { margin-top: 0.75rem; }

.block-label {
  font-size: 0.7rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  display: block;
  margin-bottom: 0.75rem;
  opacity: 0.7;
}

.block-principle {
  background: var(--ochre-faint);
  border-left: 3px solid var(--ochre);
}
.block-principle :deep(p) {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  font-style: italic;
}

.block-insight {
  background: var(--insight-bg);
  border-left: 3px solid var(--insight-green);
}
.block-insight :deep(p) { color: var(--insight-green); }
.block-insight .block-label { color: var(--insight-green); }

.block-mirror {
  background: var(--mirror-bg);
  border-left: 3px solid var(--mirror-blue);
}
.block-mirror :deep(p) { color: var(--mirror-blue); }
.block-mirror .block-label { color: var(--mirror-blue); }

.block-concession {
  background: var(--concede-bg);
  border-left: 3px solid var(--concede-warm);
}
.block-concession :deep(p) { color: var(--concede-warm); }
.block-concession .block-label { color: var(--concede-warm); }

@media (max-width: 480px) {
  .block {
    padding: 1.25rem 1.25rem;
    margin: 1.5rem 0;
  }
}
</style>
