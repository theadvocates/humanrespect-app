<template>
  <div>
    <RespectTest variant="map" base-path="/test-v2" />

    <TestExplain />
  </div>
</template>

<script setup>
import RespectTest from '@/components/test/RespectTest.vue'
import TestExplain from '@/components/test/TestExplain.vue'

import { RESULTS, parseShared } from '@/utils/respectTest'
import { SITE_URL } from '@/utils/seo'

/**
 * The same test with a different reveal: the two scores become the axes of a
 * map, and the gap is the drop below the diagonal. Statements, scoring and
 * results are shared with /test, so nothing here changes what a score means.
 *
 * A trial, alongside the original rather than in place of it. Kept out of
 * search so the two pages don't compete for the same query; the canonical
 * stays on this page so a shared map result unfurls as the map.
 */
definePageMeta({ name: 'test-v2' })

const shared = parseShared(useRoute().query)
usePageSeo('test', shared
  ? {
      title: `"${RESULTS[shared.key].name}": ${shared.directly} on my own, ${shared.others} through others`,
      description: 'Persuade or force? Ten statements, under a minute. See where you land, and whether your answer changes when someone else does the forcing.',
      image: `${SITE_URL}/og/test-${shared.key}.png`
    }
  : {})
useHead({ meta: [{ name: 'robots', content: 'noindex, follow' }] })
</script>
