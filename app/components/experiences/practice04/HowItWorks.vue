<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The practice</p>
    <h2 class="display-medium">Seven days. One observation per day.</h2>
    <Divider />
    <p class="body-text-large">Each day, ask yourself one question before bed:</p>

    <ContentBlock variant="principle">
      <p>Today, was there a moment where I chose persuasion when I could have reached for force? Or a moment where I wished someone would be <em>forced</em> to do what I wanted?</p>
    </ContentBlock>

    <p class="body-text">Force doesn't just mean physical violence. It includes:</p>

    <ScenarioBox label="Forms of force in daily life">
      <p>Wishing a law would make someone behave differently. Wanting a rule to punish someone who annoyed you. Supporting a policy that takes money from people who didn't agree. Hoping authority would compel someone to change. Thinking "there ought to be a law."</p>
    </ScenarioBox>

    <p class="body-text">You don't need to change your behavior. Just <em>notice</em>. Awareness is the first step. The pattern becomes visible only when you start looking for it.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
