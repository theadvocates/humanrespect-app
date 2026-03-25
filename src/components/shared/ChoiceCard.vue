<template>
  <button
    class="choice"
    :class="{ selected }"
    @click="$emit('select')"
  >
    <strong><slot name="label" /></strong>
    <span v-if="$slots.detail" class="choice-detail"><slot name="detail" /></span>
  </button>
</template>

<script setup>
defineProps({
  selected: { type: Boolean, default: false }
})
defineEmits(['select'])
</script>

<style scoped>
.choice {
  display: block;
  width: 100%;
  padding: 1.25rem 1.5rem;
  margin-bottom: 0.75rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
}
.choice:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
}
.choice.selected {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}
.choice strong { color: var(--ink); }
.choice-detail {
  display: block;
  font-size: 0.85rem;
  color: var(--ink-muted);
  margin-top: 0.35rem;
}
</style>
