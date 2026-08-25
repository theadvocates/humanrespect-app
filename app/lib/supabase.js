import { createClient } from '@supabase/supabase-js'

let client = null

/**
 * Lazily creates the Supabase browser client from runtime config.
 * Returns null when Supabase isn't configured, so callers can no-op
 * cleanly instead of firing requests at a placeholder host.
 */
export function getSupabase() {
  if (client !== null) return client

  const { supabaseUrl, supabaseAnonKey } = useRuntimeConfig().public
  if (!supabaseUrl || !supabaseAnonKey) {
    client = false
    return null
  }

  client = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: true, autoRefreshToken: true }
  })
  return client
}

export function isSupabaseConfigured() {
  return getSupabase() !== null
}
