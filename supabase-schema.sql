-- CAN Grade 12 / CAN Leadership Academy
-- Run this in Supabase Dashboard > SQL Editor.
-- Then create/invite user accounts in Supabase Authentication and assign their roles below.
-- Never use the service-role key in frontend code.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  role text not null check (role in ('student','teacher','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.timetable (
  id uuid primary key default gen_random_uuid(),
  day_of_week text not null,
  day_order integer not null default 1,
  start_time text not null,
  end_time text not null,
  subject text not null,
  room text,
  teacher_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.study_notes (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text not null,
  description text,
  resource_url text,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  is_published boolean not null default false,
  published_at timestamptz,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table if not exists public.exam_results (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  subject text not null,
  assessment text not null,
  score numeric not null check (score >= 0),
  max_score numeric not null check (max_score > 0 and score <= max_score),
  term text,
  school_year text not null default '2026–2027',
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table if not exists public.teacher_contacts (
  id uuid primary key default gen_random_uuid(),
  teacher_name text not null,
  subject text,
  official_email text,
  office_hours text,
  created_at timestamptz not null default now()
);

-- Security-definer helper avoids recursive RLS checks on profiles.
create or replace function public.current_can_role()
returns text language sql stable security definer set search_path = public
as $$
  select role from public.profiles where id = auth.uid()
$$;

grant execute on function public.current_can_role() to anon, authenticated;
grant usage on schema public to anon, authenticated;
grant select on public.announcements to anon, authenticated;
grant select, insert, update, delete on public.profiles, public.timetable, public.study_notes, public.announcements, public.exam_results, public.teacher_contacts to authenticated;

alter table public.profiles enable row level security;
alter table public.timetable enable row level security;
alter table public.study_notes enable row level security;
alter table public.announcements enable row level security;
alter table public.exam_results enable row level security;
alter table public.teacher_contacts enable row level security;

drop policy if exists "profile owner or staff reads profile" on public.profiles;
create policy "profile owner or staff reads profile" on public.profiles for select to authenticated
using (id = auth.uid() or public.current_can_role() in ('teacher','admin'));

drop policy if exists "staff manage profiles" on public.profiles;
create policy "staff manage profiles" on public.profiles for all to authenticated
using (public.current_can_role() = 'admin') with check (public.current_can_role() = 'admin');

drop policy if exists "authenticated users read timetable" on public.timetable;
create policy "authenticated users read timetable" on public.timetable for select to authenticated using (true);
drop policy if exists "staff manage timetable" on public.timetable;
create policy "staff manage timetable" on public.timetable for all to authenticated
using (public.current_can_role() in ('teacher','admin')) with check (public.current_can_role() in ('teacher','admin'));

drop policy if exists "authenticated users read study notes" on public.study_notes;
create policy "authenticated users read study notes" on public.study_notes for select to authenticated using (true);
drop policy if exists "staff manage study notes" on public.study_notes;
create policy "staff manage study notes" on public.study_notes for all to authenticated
using (public.current_can_role() in ('teacher','admin')) with check (public.current_can_role() in ('teacher','admin'));

drop policy if exists "public reads published announcements" on public.announcements;
create policy "public reads published announcements" on public.announcements for select to anon, authenticated
using (is_published = true);
drop policy if exists "staff manage announcements" on public.announcements;
create policy "staff manage announcements" on public.announcements for all to authenticated
using (public.current_can_role() in ('teacher','admin')) with check (public.current_can_role() in ('teacher','admin'));

drop policy if exists "student reads own results staff reads all" on public.exam_results;
create policy "student reads own results staff reads all" on public.exam_results for select to authenticated
using (student_id = auth.uid() or public.current_can_role() in ('teacher','admin'));
drop policy if exists "staff manage exam results" on public.exam_results;
create policy "staff manage exam results" on public.exam_results for all to authenticated
using (public.current_can_role() in ('teacher','admin')) with check (public.current_can_role() in ('teacher','admin'));

drop policy if exists "authenticated users read teacher contacts" on public.teacher_contacts;
create policy "authenticated users read teacher contacts" on public.teacher_contacts for select to authenticated using (true);
drop policy if exists "admin manages teacher contacts" on public.teacher_contacts;
create policy "admin manages teacher contacts" on public.teacher_contacts for all to authenticated
using (public.current_can_role() = 'admin') with check (public.current_can_role() = 'admin');

-- Optional: sample public announcement. Remove or edit before using.
insert into public.announcements (title, body, is_published, published_at)
select 'Welcome to the 2026–2027 school year', 'Welcome to CAN Grade 12. Please check with your teacher for the confirmed timetable and exam dates.', true, now()
where not exists (select 1 from public.announcements where title = 'Welcome to the 2026–2027 school year');

-- IMPORTANT USER SETUP:
-- 1. In Supabase > Authentication, create each student/teacher account (disable public signups).
-- 2. Copy the Auth user's UUID from the Users page.
-- 3. Add a profile in SQL Editor. Example (replace UUID/name):
-- insert into public.profiles (id, display_name, role)
-- values ('AUTH-USER-UUID-HERE', 'Student Example', 'student');
-- Teacher example role is 'teacher'; administrator role is 'admin'.
-- Only assign teacher/admin roles to authorized staff. Do not make students admins.
