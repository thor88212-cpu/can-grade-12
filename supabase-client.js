// Paste your project's public URL and anon/publishable key from Supabase here.
// These are public client settings, not a service-role key. Never put a service-role key in browser code.
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY';
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
