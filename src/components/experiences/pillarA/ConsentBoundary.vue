<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The moral boundary</p>
    <h2 class="display-medium">"My body is mine, and only I decide what happens to it."</h2>
    <Divider />

    <p class="body-text-large">Consent is the moral language of bodily integrity. It draws the line between legitimate interaction and violation.</p>

    <p class="body-text">Consent is meaningful only when it is voluntary, informed, revocable, and free from coercion. Without these conditions, "consent" is just compliance wearing a mask.</p>

    <ScenarioBox label="Where this leads">
      <p>This principle — that your body belongs to you and no one may use it without your genuine consent — is the one moral claim that virtually every human being accepts intuitively.</p>
      <p>Children understand it before they understand government: <em>"Don't hit me. That's my body."</em></p>
      <p>The Philosophy of Human Respect simply asks: if this principle is true for individuals, does it stop being true when the one violating it wears a uniform, holds an office, or acts on behalf of a majority?</p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="The honest tension">
      <p>Protecting bodily integrity sometimes requires the use of defensive force. Stopping an attacker, restraining a violent person, defending against invasion — these are uses of force that the philosophy permits, because they respond to a violation already initiated by someone else. The line isn't between "force" and "no force." It's between <em>initiated</em> force and <em>defensive</em> force.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
