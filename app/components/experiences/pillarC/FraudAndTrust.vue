<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hidden violation</p>
    <h2 class="display-medium">Fraud is theft by deception — and it breaks something deeper than a bank account.</h2>
    <Divider />

    <p class="body-text-large">Fraud steals more than resources. It steals time spent in trust, cognitive attention misdirected by lies, and the opportunity cost of false belief. But its deepest damage is to the infrastructure of cooperation itself.</p>

    <p class="body-text">Every act of fraud is parasitism on trust. The scammer exploits the fact that most people operate honestly — and in doing so, makes honest operation more dangerous for everyone. When trust collapses, the cost of every interaction rises: more contracts, more lawyers, more verification, more suspicion.</p>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Fraud is one area where even the Philosophy of Human Respect acknowledges the difficulty of purely voluntary solutions. Detecting and preventing fraud requires information, investigation, and sometimes enforcement. The philosophy argues that these functions should be as voluntary and non-coercive as possible — private certification, reputation systems, voluntary arbitration — but acknowledges that protecting people from deception is one of the harder problems in a non-coercive society.</p>
    </ContentBlock>

    <p class="body-text">What doesn't change is the principle: fraud violates material integrity, damages flourishing, and erodes the trust that makes cooperation possible. A society aligned with Human Respect takes fraud seriously — not as a government prerogative, but as a threat to the social fabric that every community has an interest in preventing.</p>

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

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
