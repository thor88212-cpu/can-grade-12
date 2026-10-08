# CAN Grade 12 — CAN Leadership Academy (2026–2027)

Responsive public class website plus secure student/teacher portal.

## Included
- `index.html`: public landing page and public published announcements
- `login.html`: Supabase email/password login
- `portal.html`: authenticated timetable, study notes, announcements, exam results, teacher contacts
- `supabase-client.js`: public Supabase project settings placeholder
- `supabase-schema.sql`: database tables and row-level security policies

## Important security facts
- Exam results are only readable by the matching student or authorized teacher/admin through row-level security.
- Student accounts should be created by a trusted school administrator; do not enable public signup.
- Teacher/admin roles are assigned in the database by an authorized administrator.
- Never place a Supabase service-role key in this website.
- The front-end portal is not a teacher-management interface yet; staff can manage records in Supabase's dashboard or a separately secured admin app.
- Have the school approve the data collected and who is allowed to see it before adding real student information.

## Deploy from Android
1. Download and extract the ZIP using Files by Google or your phone's Files app.
2. Create a GitHub repository at https://github.com/ and upload all files in this folder to the repository root.
3. Create a Supabase project at https://supabase.com/ (free plan available, subject to plan limits).
4. In Supabase, open SQL Editor, paste `supabase-schema.sql`, and run it.
5. In Supabase Project Settings / API, copy the Project URL and public anon/publishable key. Edit `supabase-client.js` on GitHub and replace:
   - `https://YOUR_PROJECT_ID.supabase.co`
   - `YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY`
   Do not use a service-role key.
6. In Supabase Authentication settings, disable public signups. Create student and teacher accounts yourself as an authorized school administrator.
7. For each Auth user, copy their UUID and insert a matching row into `public.profiles` using SQL Editor. Assign only `student`, `teacher`, or `admin` as appropriate.
8. In Netlify at https://app.netlify.com/, import the GitHub repository and deploy. This is a plain static site; no build command is needed. If asked, set publish directory to `.`.
9. Test public announcements and test login using a dedicated test account. Verify one student cannot view another student's exam results. Do not test using real grades until permissions have been verified.
10. In Netlify Domain management, add your custom domain. Follow its DNS instructions. Domain registration usually costs money; you can start with the free `*.netlify.app` address.

## How to add timetable/notes/results
For the starter version, an authorized teacher/admin can add rows from Supabase Table Editor. For exam results, set `student_id` to that student's Auth UUID and verify scores and maximum scores. Keep student data confidential.
