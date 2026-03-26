<template>
  <component
    :is="to ? 'router-link' : 'a'"
    :to="to || undefined"
    :href="href || undefined"
    class="path-card"
    :class="{ completed, disabled, recommended }"
    v-bind="$attrs"
  >
    <div class="path-card-content">
      <div class="path-card-header">
        <span v-if="recommended" class="recommended-badge">Recommended next</span>
        <span v-else-if="completed" class="completed-badge">✓ Done</span>
      </div>
      <div class="path-card-title"><slot name="title" /></div>
      <div class="path-card-desc"><slot name="desc" /></div>
    </div>
    <span class="path-arrow" v-if="!disabled">→</span>
  </component>
</template>

<script setup>
defineProps({
  to: { type: [Object, String], default: null },
  href: { type: String, default: null },
  completed: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  recommended: { type: Boolean, default: false }
})
</script>

<style scoped>
.path-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  margin-bottom: 0.75rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  text-decoration: none;
  color: var(--ink);
  transition: all 0.25s ease;
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.path-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
}

.path-card:active { transform: translateY(0); }

/* Recommended state */
.path-card.recommended {
  border-color: var(--ochre);
  background: var(--ochre-faint);
  box-shadow: 0 2px 12px rgba(154, 123, 79, 0.12);
}

.path-card.recommended:hover {
  box-shadow: 0 4px 20px rgba(154, 123, 79, 0.2);
}

.recommended-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: white;
  background: var(--ochre);
  padding: 0.2rem 0.6rem;
  border-radius: 3px;
  margin-bottom: 0.35rem;
}

/* Completed state */
.path-card.completed {
  background: var(--paper);
  border-color: var(--border-subtle);
  opacity: 0.75;
}

.path-card.completed:hover {
  opacity: 1;
  border-color: var(--ochre);
}

.path-card.disabled { opacity: 0.4; pointer-events: none; }

.path-card-content { flex: 1; min-width: 0; }
.path-card-header { display: flex; align-items: center; gap: 0.5rem; }

.completed-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--insight-green);
  background: var(--insight-bg);
  padding: 0.2rem 0.5rem;
  border-radius: 3px;
  margin-bottom: 0.35rem;
}

.path-card-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.35;
}

.path-card.completed .path-card-title { color: var(--ink-muted); }

.path-card-desc {
  font-family: var(--sans);
  font-size: 0.82rem;
  color: var(--ink-muted);
  margin-top: 0.3rem;
  line-height: 1.55;
}

.path-arrow {
  flex-shrink: 0;
  font-size: 1rem;
  color: var(--ochre);
  margin-left: 1rem;
  transition: transform 0.2s ease;
}

.path-card:hover .path-arrow { transform: translateX(3px); }

@media (max-width: 480px) {
  .path-card { padding: 1rem 1.25rem; }
}
</style>
