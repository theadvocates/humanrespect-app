<template>
  <div class="screen-inner stagger" ref="el">
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
      <div
        v-for="(step, idx) in currentChain"
        :key="idx"
        class="chain-step"
        :class="{ revealed: revealedSteps > idx }"
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
          <p>That is the full chain. It begins with a vote and ends with armed agents and a cage. Every link exists because the link before it authorized it. The first link — the one that set the entire chain in motion — is a person who believed they were choosing something good.</p>
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
    { actor: 'The legislature', action: 'Passes a tax law requiring citizens to surrender a percentage of their earnings.' },
    { actor: 'The IRS', action: 'Sends a notice to your neighbor demanding payment.' },
    { actor: 'Your neighbor', action: 'Believes the amount is unjust and declines to pay.' },
    { actor: 'The IRS', action: 'Sends threatening letters. Imposes penalties. Garnishes wages. Places liens on property.' },
    { actor: 'Your neighbor', action: 'Still refuses. They haven\'t harmed anyone. They simply declined to surrender their earnings.' },
    { actor: 'Federal agents', action: 'Arrive at your neighbor\'s home. Armed. They seize property, freeze bank accounts, or arrest your neighbor and put them in a cell.' },
  ],
  'drug-prohibition': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who supports criminalizing drug possession.' },
    { actor: 'The legislature', action: 'Passes a law making possession of certain substances a felony.' },
    { actor: 'Police', action: 'Identify your neighbor as a suspected user based on a tip or a traffic stop.' },
    { actor: 'A judge', action: 'Issues a warrant based on probable cause.' },
    { actor: 'A SWAT team', action: 'Breaks down your neighbor\'s door before dawn. Weapons drawn. Flash grenades deployed. Children screaming.' },
    { actor: 'Your neighbor', action: 'Is handcuffed on the floor of their own home. Their only action was consuming a substance in private.' },
    { actor: 'The court system', action: 'Prosecutes. Mandatory minimum: five years. Their career, their family, their children\'s stability — destroyed. For a choice that harmed no one but themselves.' },
  ],
  'gun-regulation': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to ban certain firearms.' },
    { actor: 'The legislature', action: 'Passes a law requiring owners of newly prohibited weapons to surrender them.' },
    { actor: 'The government', action: 'Sends notices to registered owners: turn in your firearms by the deadline or face felony charges.' },
    { actor: 'Your neighbor', action: 'A lifelong hunter and target shooter. Has never committed a crime. Believes the ban violates a fundamental right. Refuses to comply.' },
    { actor: 'Law enforcement', action: 'Obtains a warrant. Arrives at your neighbor\'s home to execute a search and seizure.' },
    { actor: 'Your neighbor', action: 'Faces a choice: surrender property they\'ve owned legally for decades, or resist agents with guns who have come to take their guns.' },
    { actor: 'The situation', action: 'Armed agents enforcing a policy against an armed citizen who has harmed no one. The potential for violence is embedded in the design of the policy itself.' },
  ],
  'environmental': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises stricter environmental protections.' },
    { actor: 'A regulatory agency', action: 'Issues new rules classifying a portion of your neighbor\'s land as protected wetland. They cannot build, farm, or develop it.' },
    { actor: 'Your neighbor', action: 'A small farmer who bought this land with thirty years of savings. The protected portion is 60% of their property. They weren\'t consulted. They received no compensation.' },
    { actor: 'Your neighbor', action: 'Plants crops on the restricted portion because their family depends on the income. They are not polluting. They are farming land they own.' },
    { actor: 'The agency', action: 'Issues a cease-and-desist order and a fine of $75,000 per day of violation.' },
    { actor: 'Your neighbor', action: 'Cannot afford the fine. Cannot afford a lawyer to fight it. Cannot sell the now-worthless land.' },
    { actor: 'Federal agents', action: 'Arrive to enforce the order. Your neighbor\'s life savings, their land, and potentially their freedom are taken — for farming their own property.' },
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
.chain-step { display: flex; gap: 1rem; align-items: flex-start; padding: 0.75rem 0; opacity: 0; transform: translateY(8px); transition: opacity 0.4s ease, transform 0.4s ease; }
.chain-step.revealed { opacity: 1; transform: translateY(0); }
.chain-num { flex-shrink: 0; width: 24px; height: 24px; border-radius: 50%; background: var(--ochre-faint); color: var(--ochre); font-family: var(--serif); font-size: 0.75rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.chain-actor { font-family: var(--serif); font-size: 0.88rem; font-weight: 500; color: var(--ink); margin-bottom: 0.1rem; }
.chain-action { font-size: 0.82rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.reveal-btn { display: block; margin: 1.5rem auto; padding: 0.7rem 1.5rem; background: transparent; border: 1.5px solid var(--ochre); border-radius: 100px; font-family: var(--serif); font-size: 0.88rem; color: var(--ochre); cursor: pointer; transition: all 0.25s ease; -webkit-tap-highlight-color: transparent; }
.reveal-btn:hover { background: var(--ochre-faint); }
.reveal-btn .arrow { display: inline-block; transition: transform 0.2s ease; }
.reveal-btn:hover .arrow { transform: translateX(3px); }
.chain-complete { margin-top: 1.5rem; }
</style>
