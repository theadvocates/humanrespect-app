import { getSupabase } from '@/lib/supabase'

/**
 * Restores the session on load and keeps `user` in sync with Supabase.
 * Claims the anonymous journey whenever a sign-in completes.
 */
export default defineNuxtPlugin(async () => {
  const supabase = await getSupabase()
  if (!supabase) return

  const { user, claimJourney } = useAuth()

  const { data } = await supabase.auth.getSession()
  user.value = data.session?.user ?? null
  if (user.value) await claimJourney()

  supabase.auth.onAuthStateChange((event, session) => {
    user.value = session?.user ?? null
    if (event === 'SIGNED_IN') claimJourney()
  })
})
