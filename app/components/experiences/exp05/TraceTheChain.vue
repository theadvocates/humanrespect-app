<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Trace the chain</p>
    <h2 class="display-medium">Pick a policy. Then follow the enforcement chain to the end.</h2>
    <Divider />

    <p class="body-text">Most political language hides the chain between a vote and the force it produces. Pick one policy and we'll walk through it together.</p>

    <div class="policy-choices">
      <button
        v-for="p in policies"
        :key="p.id"
        class="policy-btn"
        :class="{ selected: chosenPolicy === p.id }"
        @click="choosePolicy(p.id)"
      >{{ p.label }}</button>
    </div>

    <div v-if="chosenPolicy" class="chain">
      <!-- Only the revealed links are in the layout; the hidden ones would
           otherwise hold their height and push the button down the page. -->
      <div
        v-for="(step, idx) in currentChain.slice(0, revealedSteps)"
        :key="`${chosenPolicy}-${idx}`"
        class="chain-step"
      >
        <div class="chain-num">{{ idx + 1 }}</div>
        <div class="chain-content">
          <div class="chain-actor">{{ step.actor }}</div>
          <p class="chain-action">{{ step.action }}</p>
        </div>
      </div>

      <button
        v-if="revealedSteps < currentChain.length"
        class="reveal-btn"
        @click="revealNext"
      >
        Then what happens? <span class="arrow">→</span>
      </button>

      <div v-if="revealedSteps >= currentChain.length" class="chain-complete">
        <ContentBlock variant="mirror">
          <p>That is the full chain. Most people comply long before the last link, which is why the last link is easy to forget. It is still what makes the first one work. Every link exists because the link before it authorized it. The first link, the one that set the entire chain in motion, is a person who believed they were choosing something good.</p>
        </ContentBlock>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosenPolicy || revealedSteps < currentChain.length"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const chosenPolicy = ref(null)
const revealedSteps = ref(0)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const policies = [
  { id: 'income-tax', label: 'Income tax' },
  { id: 'drug-prohibition', label: 'Drug prohibition' },
  { id: 'gun-regulation', label: 'Firearm restrictions' },
  { id: 'environmental', label: 'Environmental regulation' },
]

const chains = {
  'income-tax': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to fund programs through income taxation.' },
    { actor: 'The legislature', action: 'Passes a tax law requiring people to surrender a percentage of their earnings.' },
    { actor: 'The IRS', action: 'Sends a notice to your neighbor demanding payment.' },
    { actor: 'Your neighbor', action: 'Believes the programs are wrong and declines to pay for them.' },
    { actor: 'The IRS', action: 'Adds penalties and interest. Garnishes wages. Places a lien on the house. Empties the bank account.' },
    { actor: 'Your neighbor', action: 'Still refuses. They have not threatened anyone. They have declined to hand over their earnings.' },
    { actor: 'Prosecutors and marshals', action: 'Willful refusal is a crime. A court convicts. If your neighbor will not report to prison, armed marshals come to take them there.' },
  ],
  'drug-prohibition': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who supports criminalizing drug possession.' },
    { actor: 'The legislature', action: 'Passes a law making possession of certain substances a felony.' },
    { actor: 'Police', action: 'Identify your neighbor as a suspected user based on a tip or a traffic stop.' },
    { actor: 'A judge', action: 'Issues a search warrant based on probable cause.' },
    { actor: 'Officers', action: 'Serve the warrant at your neighbor\'s home, often at dawn, sometimes forcing the door with weapons drawn while the family is inside.' },
    { actor: 'Your neighbor', action: 'Is handcuffed in their own home for possessing a substance they chose to use.' },
    { actor: 'The court system', action: 'Prosecutes. Jail or probation follows, and a felony record follows for life: jobs they can\'t get, apartments they can\'t rent, loans they can\'t take out.' },
  ],
  'gun-regulation': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to ban certain firearms.' },
    { actor: 'The legislature', action: 'Passes a law requiring owners of newly prohibited weapons to surrender them.' },
    { actor: 'The government', action: 'Sends notices to registered owners: turn in your firearms by the deadline or face felony charges.' },
    { actor: 'Your neighbor', action: 'A lifelong hunter and target shooter who has never threatened anyone. Believes the ban is wrong, and refuses to comply.' },
    { actor: 'Law enforcement', action: 'Obtains a warrant. Arrives at your neighbor\'s home to search it and seize the weapons.' },
    { actor: 'Your neighbor', action: 'Faces a choice: surrender property they\'ve owned legally for decades, or resist armed officers who have come to take it.' },
    { actor: 'The situation', action: 'Armed agents enforcing a law against a citizen who has not threatened anyone. If your neighbor resists, the law\'s only answer is more force.' },
  ],
  'environmental': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises stricter environmental protections.' },
    { actor: 'A regulatory agency', action: 'Issues new rules classifying a portion of your neighbor\'s land as protected wetland. They cannot build, farm, or develop it.' },
    { actor: 'Your neighbor', action: 'A small farmer who bought this land with thirty years of savings. The protected portion is 60% of it. They were not asked, and rules like this rarely come with compensation.' },
    { actor: 'Your neighbor', action: 'Plants crops on the restricted portion because the family depends on the income. The agency says farming there damages the wetland. Your neighbor says it is their land.' },
    { actor: 'The agency', action: 'Issues a cease-and-desist order. Civil penalties under federal water law can exceed $60,000 per day of violation.' },
    { actor: 'Your neighbor', action: 'Cannot afford the penalties or a lawyer to fight them. Cannot sell the restricted land for anything like what they paid.' },
    { actor: 'The courts', action: 'Order the penalties paid and the land restored. If your neighbor still refuses, the court can seize assets or jail them for contempt.' },
  ]
}
const currentChain = computed(() => chains[chosenPolicy.value] || [])

function choosePolicy(id) {
  chosenPolicy.value = id
  revealedSteps.value = 1
  trackChoice('exp05', 'chain-policy', id)
}

function revealNext() {
  if (revealedSteps.value < currentChain.value.length) {
    revealedSteps.value++
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.policy-choices { margin: 1.5rem 0; display: flex; flex-wrap: wrap; gap: 0.5rem; }
.policy-btn { padding: 0.6rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.policy-btn:hover { border-color: var(--ochre); }
.policy-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }

.chain { margin: 2rem 0; }
.chain-step { display: flex; gap: 1rem; align-items: flex-start; padding: 0.75rem 0; animation: chain-in 0.4s ease both; }
@keyframes chain-in {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
@media (prefers-reduced-motion: reduce) { .chain-step { animation: none; } }
.chain-num { flex-shrink: 0; width: 24px; height: 24px; border-radius: 50%; background: var(--ochre-faint); color: var(--ochre); font-family: var(--serif); font-size: 0.75rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.chain-actor { font-family: var(--serif); font-size: 0.88rem; font-weight: 500; color: var(--ink); margin-bottom: 0.1rem; }
.chain-action { font-size: 0.82rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.reveal-btn { display: block; margin: 1.5rem auto; padding: 0.7rem 1.5rem; background: transparent; border: 1.5px solid var(--ochre); border-radius: 100px; font-family: var(--serif); font-size: 0.88rem; color: var(--ochre); cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.reveal-btn:hover { background: var(--ochre-faint); }
.reveal-btn .arrow { display: inline-block; transition: transform 0.2s ease; }
.reveal-btn:hover .arrow { transform: translateX(3px); }
.chain-complete { margin-top: 1.5rem; }
</style>
