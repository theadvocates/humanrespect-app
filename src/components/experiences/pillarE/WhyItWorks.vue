<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The mechanism</p>
    <h2 class="display-medium">Why voluntary cooperation outperforms coercion.</h2>
    <Divider />

    <p class="body-text-large">This isn't idealism. There are structural reasons why voluntary systems produce better outcomes than coercive ones.</p>

    <div class="mechanisms">
      <div class="mechanism">
        <div class="mechanism-name">Feedback loops</div>
        <p>Voluntary systems get immediate feedback. If a voluntary school is bad, families leave. If a voluntary charity wastes money, donors stop giving. Coercive systems insulate providers from consequences — bad government schools keep getting funded regardless.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Accountability</div>
        <p>When participation is voluntary, providers must earn trust continuously. When participation is compulsory, providers can afford to be unresponsive. This is why the DMV experience differs from the Apple Store experience.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Innovation pressure</div>
        <p>Competition between voluntary solutions drives constant improvement. Monopolies — whether corporate or governmental — stagnate. The reason open-source software evolves faster than government IT systems is the same reason markets outperform central planning.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Trust-building</div>
        <p>Coercion erodes trust. Cooperation builds it. Every successful voluntary interaction strengthens the social fabric. Every act of compulsion weakens it. Over time, this difference compounds dramatically.</p>
      </div>

      <div class="mechanism">
        <div class="mechanism-name">Adaptation</div>
        <p>Voluntary systems are distributed and adaptive — thousands of approaches tested simultaneously, with successful ones spreading naturally. Coercive systems are centralized and rigid — one approach mandated for everyone, changed only through political battle.</p>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>Cooperation is a technology for producing human flourishing — in the same category as language, markets, and communication networks. It works better because it's aligned with human nature rather than fighting against it.</p>
    </ContentBlock>

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

.mechanisms { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }

.mechanism {
  padding: 1.25rem 1.5rem;
  background: var(--cream);
  border-left: 3px solid var(--insight-green);
  border-radius: 0 var(--radius) var(--radius) 0;
}

.mechanism-name {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.4rem;
}

.mechanism p {
  font-size: 0.88rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

@media (max-width: 480px) {
  .mechanism { padding: 1rem 1.25rem; }
}
</style>
