<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you just revealed</p>

    <!-- GAP: no/yes (most common) -->
    <template v-if="pattern === 'gap'">
      <h2 class="display-medium">Read your two answers back to yourself.</h2>
      <ContentBlock variant="mirror">
        <p><strong>Personally:</strong> You said taking James's money is wrong — even to help Sarah.</p>
        <p><strong>Politically:</strong> You said the government <em>should</em> take James's money — to help people just like Sarah.</p>
      </ContentBlock>
      <p class="body-text-large">The money still comes from someone who earned it. It still goes to someone who needs it. The cause is equally compassionate in both cases.</p>
      <p class="body-text">The only thing that changed is who does the taking. And somehow, that changed your answer.</p>
      <ContentBlock variant="insight">
        <p>You may have seen where this was headed. That's fine — it doesn't change the fact that you gave two different answers to what is, at its core, the same moral question. <strong>Most people do.</strong> We hold one standard for personal conduct and a different one for political action, and we rarely stop to ask why.</p>
      </ContentBlock>
    </template>

    <!-- CONSISTENT VOLUNTARY: no/no -->
    <template v-else-if="pattern === 'consistent-voluntary'">
      <h2 class="display-medium">Your answers are remarkably consistent.</h2>
      <ContentBlock variant="insight">
        <p>You said taking James's money is wrong — whether done personally or through government. You apply the same moral standard to both situations.</p>
      </ContentBlock>
      <p class="body-text-large">This puts you in a minority. Most people hold one moral code for their personal life and a different one for political action. They would never personally take a neighbor's money, but they'll vote for a government to do exactly that.</p>
      <p class="body-text">You've already noticed something that most people never examine. The question is: what does that consistency tell you about how society could work?</p>
    </template>

    <!-- CONSISTENT COERCIVE: yes/yes -->
    <template v-else-if="pattern === 'consistent-coercive'">
      <h2 class="display-medium">Your answers are consistent — and worth examining.</h2>
      <ContentBlock variant="mirror">
        <p>You said Sarah's need justifies taking James's money — both personally and through government. You believe urgent need can override individual consent.</p>
      </ContentBlock>
      <p class="body-text-large">This is a coherent position. But consider: if <em>you</em> can decide when someone else's need justifies taking from James, so can everyone else. And their definition of "urgent need" may be very different from yours.</p>
      <p class="body-text">When everyone has the right to take from others for causes they consider justified, what happens to trust? To cooperation? To the willingness to produce in the first place?</p>
    </template>

    <!-- UNUSUAL: yes/no -->
    <template v-else>
      <h2 class="display-medium">Your answers form an interesting pattern.</h2>
      <ContentBlock variant="mirror">
        <p>You'd personally take James's money for Sarah — but you wouldn't vote for a government to do the same thing at scale. You hold yourself to a <em>different</em> standard than you hold institutions.</p>
      </ContentBlock>
      <p class="body-text-large">This suggests you see personal compassion and institutional force as fundamentally different — that scale changes the ethics. That's worth sitting with.</p>
    </template>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const pattern = computed(() => journey.mirrorPattern)
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
