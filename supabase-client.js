// Paste your project's public URL and anon/publishable key from Supabase here.
// These are public client settings, not a service-role key. Never put a service-role key in browser code.
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
const SUPABASE_URL = 'https://nnrfrptvvtvuytujgryn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ucmZycHR2dnR2dXl0dWpncnluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE1NzE5MTAsImV4cCI6MjEwNzE0NzkxMH0.ZIA0UKdfGrvrO1Lui9WgU5JX_p6oaG6ZwAl0lcTUhMw';
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
