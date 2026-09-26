<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hidden violation</p>
    <h2 class="display-medium">Fraud is theft by deception — and it breaks something deeper than a bank account.</h2>
    <Divider />

    <p class="body-text-large">Fraud steals more than resources. It steals time spent in trust, cognitive attention misdirected by lies, and the opportunity cost of false belief. But its deepest damage is to the infrastructure of cooperation itself.</p>

    <p class="body-text">Every act of fraud feeds on honest dealing. The scammer exploits the fact that most people keep their word, and makes keeping it more dangerous for everyone. Strangers trade without trusting each other because ratings, warranties, and contracts mean something. Fraud attacks exactly that.</p>

    <ContentBlock variant="insight" label="Who stops fraud">
      <p>Fraud is itself a taking, so stopping it and making victims whole is defense, not the kind of force the principle rules out. Day to day, what stops fraud among strangers is reputation: ratings, credit bureaus, testing labs, escrow, chargebacks, the cost of losing every future customer. Regulators miss most fraud too, and add false confidence. The SEC received repeated, detailed warnings about Madoff for years and did nothing.</p>
    </ContentBlock>

    <p class="body-text">A society aligned with Human Respect takes fraud seriously — not as a government prerogative, but as a taking every community has an interest in stopping.</p>

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
