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
          <p>That is the full chain. It begins with a voter and ends with an armed agent at someone's door. Every link in the chain exists because the link before it authorized it. And the first link — the one that set the entire chain in motion — is the vote.</p>
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
  { id: 'licensing', label: 'Occupational licensing' },
  { id: 'property-tax', label: 'Property tax' },
]

const chains = {
  'income-tax': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who promises to fund programs through income taxation.' },
    { actor: 'The legislature', action: 'Passes a tax law requiring citizens to surrender a percentage of their earnings.' },
    { actor: 'The IRS', action: 'Sends a notice to your neighbor demanding payment.' },
    { actor: 'Your neighbor', action: 'Believes the amount is unjust and declines to pay.' },
    { actor: 'The IRS', action: 'Sends increasingly threatening letters. Imposes penalties. Garnishes wages. Places liens on property.' },
    { actor: 'Your neighbor', action: 'Still refuses. Has broken no law except declining to surrender their earnings.' },
    { actor: 'Federal agents', action: 'Arrive at your neighbor\'s home. Armed. They seize property, freeze bank accounts, or arrest your neighbor and transport them to a cage.' },
  ],
  'drug-prohibition': [
    { actor: 'You (the voter)', action: 'Vote for a candidate who supports criminalizing drug possession.' },
    { actor: 'The legislature', action: 'Passes a law making possession of certain substances a felony.' },
    { actor: 'Police', action: 'Identify your neighbor as a suspected user based on a tip, surveillance, or a traffic stop.' },
    { actor: 'A judge', action: 'Issues a warrant based on probable cause of possession.' },
    { actor: 'A SWAT team', action: 'Breaks down your neighbor\'s door, often before dawn. Weapons drawn. Flash grenades deployed.' },
    { actor: 'Your neighbor', action: 'Is handcuffed, processed, and transported to jail. Their only action was consuming a substance in their own home.' },
    { actor: 'The court system', action: 'Prosecutes your neighbor. If convicted, they spend years in a cell. Their career, family, and future are permanently damaged.' },
  ],
  'licensing': [
    { actor: 'You (the voter)', action: 'Support laws requiring government licenses to practice certain professions.' },
    { actor: 'The legislature', action: 'Passes a law requiring a license to braid hair, arrange flowers, or practice interior design.' },
    { actor: 'A licensing board', action: 'Requires hundreds of hours of training, thousands of dollars in fees, and passing an exam — often written by existing practitioners who benefit from limiting competition.' },
    { actor: 'Your neighbor', action: 'Starts a small business without the license because they can\'t afford the fees or the time away from earning income.' },
    { actor: 'An inspector', action: 'Discovers the unlicensed business. Issues a cease-and-desist order and a fine.' },
    { actor: 'Your neighbor', action: 'Continues working because this is how they feed their family.' },
    { actor: 'Law enforcement', action: 'Arrives to enforce the court order. Your neighbor is arrested for the crime of working without government permission.' },
  ],
  'property-tax': [
    { actor: 'You (the voter)', action: 'Vote for local officials who fund public services through property taxation.' },
    { actor: 'The county', action: 'Assesses your neighbor\'s home at a value and sends an annual tax bill.' },
    { actor: 'Your neighbor', action: 'An elderly person on a fixed income. They own their home outright — no mortgage. But they can\'t afford the tax bill.' },
    { actor: 'The county', action: 'Adds penalties and interest. Places a lien on the property.' },
    { actor: 'Your neighbor', action: 'Still cannot pay. They have lived in this home for 40 years.' },
    { actor: 'The county', action: 'Initiates a tax sale. The home your neighbor spent a lifetime paying for is auctioned to satisfy a debt to the government.' },
    { actor: 'Your neighbor', action: 'Is evicted from the home they built their life in. If they refuse to leave, armed deputies will remove them.' },
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
