<template>
  <component
    :is="href ? 'a' : 'router-link'"
    :href="href"
    :to="to"
    class="path-card"
    @click="$emit('click', $event)"
  >
    <div class="path-title"><slot name="title" /></div>
    <div class="path-desc"><slot name="desc" /></div>
  </component>
</template>

<script setup>
defineProps({
  href: { type: String, default: null },
  to: { type: [String, Object], default: null }
})
defineEmits(['click'])
</script>

<style scoped>
.path-card {
  display: block;
  width: 100%;
  padding: 1.5rem;
  margin-bottom: 1rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  text-decoration: none;
  color: inherit;
}
.path-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-2px);
}
.path-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  margin-bottom: 0.35rem;
}
.path-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.6;
}
</style>
