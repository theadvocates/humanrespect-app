<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Seeing coercion clearly</p>
    <h2 class="display-medium">Every mandate is a claim on your life.</h2>
    <Divider />

    <p class="body-text-large">Once you see time as the fundamental human resource, forms of coercion that seemed routine begin to look different.</p>

    <div class="recognitions">
      <div class="recognition-item">
        <div class="recognition-surface">A tax</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">A claim on the hours you spent earning that money</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A regulation</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Hours spent complying instead of building, creating, or resting</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A mandate</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Your life-hours redirected toward someone else's priorities</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A bureaucratic process</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Irreplaceable moments consumed by procedures you didn't choose</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A prison sentence</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Years of a human life permanently confiscated</div>
      </div>
    </div>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>This doesn't mean every claim on your time is unjust. You voluntarily trade time for wages. You choose to spend time on relationships, community, and obligations you value. The moral line isn't between "spending time" and "not spending time." It's between <em>choosing</em> how to spend your time and having that choice <em>made for you by someone else under threat of punishment</em>.</p>
    </ContentBlock>

    <p class="body-text">Society needs coordination. The question is whether that coordination must come through coercion — the involuntary seizure of life-hours — or whether it can emerge from voluntary cooperation, where every participant has chosen to contribute their time.</p>

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

.recognitions {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.recognition-item {
  display: grid;
  grid-template-columns: 1fr auto 1.8fr;
  gap: 0.75rem;
  align-items: center;
  padding: 1rem 1.25rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
}

.recognition-surface {
  font-family: var(--serif);
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--ink);
}

.recognition-arrow {
  color: var(--ochre);
  font-size: 0.85rem;
}

.recognition-deep {
  font-size: 0.85rem;
  color: var(--ink-soft);
  line-height: 1.5;
  font-style: italic;
}

@media (max-width: 480px) {
  .recognition-item {
    grid-template-columns: 1fr;
    gap: 0.25rem;
    padding: 0.85rem 1rem;
  }
  .recognition-arrow { display: none; }
  .recognition-surface { font-size: 0.9rem; }
  .recognition-deep { font-size: 0.8rem; }
}
</style>
