import { getSupabase } from '@/lib/supabase'
import { useJourneyStore } from '@/stores/journey'

/**
 * Authentication built around a deliberate constraint: signing in must never
 * cost someone their progress. Anonymous work is claimed and merged on the way
 * in, so the prompt to create an account can come after the value has landed.
 */
export function useAuth() {
  const user = useState('auth-user', () => null)
  const loading = useState('auth-loading', () => false)

  const isSignedIn = computed(() => !!user.value)
  const displayName = computed(() => {
    const u = user.value
    if (!u) return null
    return (
      u.user_metadata?.full_name ||
      u.user_metadata?.name ||
      u.email?.split('@')[0] ||
      null
    )
  })

  function redirectTo() {
    const { siteUrl } = useRuntimeConfig().public
    const base = import.meta.client ? window.location.origin : siteUrl
    return `${base}/account/callback`
  }

  async function sendMagicLink(email) {
    const supabase = await getSupabase()
    if (!supabase) throw new Error('Sign-in is not configured yet.')

    loading.value = true
    try {
      const { error } = await supabase.auth.signInWithOtp({
        email: email.toLowerCase().trim(),
        options: { emailRedirectTo: redirectTo() }
      })
      if (error) throw error
    } finally {
      loading.value = false
    }
  }

  async function signInWithGoogle() {
    const supabase = await getSupabase()
    if (!supabase) throw new Error('Sign-in is not configured yet.')

    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: redirectTo() }
    })
    if (error) throw error
  }

  async function signOut() {
    const supabase = await getSupabase()
    if (!supabase) return
    await supabase.auth.signOut()
    user.value = null
  }

  /**
   * Attaches this browser's anonymous journey to the signed-in account,
   * merging server-side if the account already has progress from elsewhere.
   */
  async function claimJourney() {
    const supabase = await getSupabase()
    const journey = useJourneyStore()
    if (!supabase || !user.value || !journey.visitorId) return

    const { data, error } = await supabase.rpc('claim_journey', {
      p_visitor_id: journey.visitorId
    })
    if (error) {
      console.warn('Journey claim failed:', error.message)
      return
    }
    if (data) journey.applyRemote(data)
  }

  return {
    user,
    loading,
    isSignedIn,
    displayName,
    sendMagicLink,
    signInWithGoogle,
    signOut,
    claimJourney
  }
}
