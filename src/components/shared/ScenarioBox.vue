<template>
  <div class="scenario">
    <span v-if="label" class="scenario-label">{{ label }}</span>
    <slot />
  </div>
</template>

<script setup>
defineProps({
  label: { type: String, default: '' }
})
</script>

<style scoped>
.scenario {
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
  padding: 2rem;
  margin: 2rem 0;
  box-shadow: var(--shadow-soft);
}
.scenario-label {
  font-size: 0.7rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 1rem;
  display: block;
}
.scenario :deep(p) { color: var(--ink); line-height: 1.8; }
.scenario :deep(p + p) { margin-top: 1rem; }

@media (max-width: 480px) {
  .scenario {
    padding: 1.5rem;
    margin: 1.5rem 0;
  }
}
</style>
