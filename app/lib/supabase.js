/**
 * Supabase client, loaded on demand.
 *
 * @supabase/supabase-js is ~209 KB (GoTrue, PostgREST, and realtime, the last
 * of which this app doesn't use). Statically importing it put all of that in
 * the initial bundle, where it delayed the first paint of a page that needs
 * none of it — nobody has signed in or synced anything yet at that point.
 *
 * The dynamic import moves it to its own chunk, fetched the first time
 * something actually talks to the database. Every caller was already inside an
 * async function, so awaiting costs nothing.
 *
 * Returns null when Supabase isn't configured, so callers no-op cleanly.
 */

let client = null
let loading = null

export async function getSupabase() {
  if (client !== null) return client || null

  const { supabaseUrl, supabaseAnonKey } = useRuntimeConfig().public
  if (!supabaseUrl || !supabaseAnonKey) {
    client = false
    return null
  }

  // Concurrent callers during the first load share one import.
  if (!loading) {
    loading = import('@supabase/supabase-js').then(({ createClient }) => {
      client = createClient(supabaseUrl, supabaseAnonKey, {
        auth: { persistSession: true, autoRefreshToken: true }
      })
      return client
    })
  }
  return loading
}

export async function isSupabaseConfigured() {
  return (await getSupabase()) !== null
}
