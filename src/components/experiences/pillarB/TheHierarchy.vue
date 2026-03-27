<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hierarchy of irreversibility</p>
    <h2 class="display-medium">Not all losses are equal.</h2>
    <Divider />

    <p class="body-text-large">There's a hierarchy among the things that can be taken from you, and it's determined by one question: <em>can it be restored?</em></p>

    <div class="hierarchy">
      <div class="hierarchy-item level-3">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Money</div>
          <p>Can be re-earned. Losses are recoverable. A financial setback is painful but not permanent.</p>
        </div>
      </div>
      <div class="hierarchy-item level-2">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Property</div>
          <p>Harder to replace. A destroyed home, a stolen business, a wiped savings account — these take years to rebuild. But rebuilding is possible.</p>
        </div>
      </div>
      <div class="hierarchy-item level-1">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Time</div>
          <p>Cannot be replaced. Cannot be replenished. Cannot be stored. Cannot be compensated. Once a moment is taken, it is gone from your life permanently.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Coercion is the deepest violation because no payment can restore a stolen hour. No policy can return a wasted year. No compensation can un-live the life someone was forced to live instead of the one they would have chosen.</p>
    </ContentBlock>

    <p class="body-text">Money flows from property. Property flows from time. Time flows from nothing — it is the original resource, the source of all others. To steal someone's time is to steal the only resource that makes all others possible.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.hierarchy {
  margin: 2.5rem 0;
  display: flex;
  flex-direction: column;
  gap: 0;
}

.hierarchy-item {
  display: flex;
  gap: 1.25rem;
  padding: 1.5rem 0;
  border-bottom: 1px solid var(--border-subtle);
}

.hierarchy-item:last-child {
  border-bottom: none;
}

.hierarchy-bar {
  flex-shrink: 0;
  width: 4px;
  border-radius: 2px;
  min-height: 60px;
}

.level-3 .hierarchy-bar { background: var(--border-subtle); }
.level-2 .hierarchy-bar { background: var(--ochre-light); opacity: 0.5; }
.level-1 .hierarchy-bar { background: var(--ochre); }

.hierarchy-content { flex: 1; }

.hierarchy-label {
  font-family: var(--serif);
  font-size: 1.15rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.35rem;
}

.level-1 .hierarchy-label {
  color: var(--ochre);
}

.hierarchy-content p {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

@media (max-width: 480px) {
  .hierarchy-item { padding: 1.25rem 0; gap: 1rem; }
}
</style>
