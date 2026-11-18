-- Jalankan di Supabase > SQL Editor
create table if not exists public.site_config (id text primary key, data jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now());
create table if not exists public.site_admins (email text primary key);
alter table public.site_config enable row level security;
alter table public.site_admins enable row level security;
create policy "config dibaca publik" on public.site_config for select to anon, authenticated using (true);
create policy "config ditulis admin" on public.site_config for all to authenticated
 using (exists (select 1 from public.site_admins a where lower(a.email)=lower((select auth.jwt()->>'email'))))
 with check (exists (select 1 from public.site_admins a where lower(a.email)=lower((select auth.jwt()->>'email'))));
create policy "admin baca diri sendiri" on public.site_admins for select to authenticated using (lower(email)=lower((select auth.jwt()->>'email')));
insert into public.site_config(id,data) values ('main','{}'::jsonb) on conflict do nothing;
-- GANTI email lalu jalankan; buat user admin di Authentication > Users dan MATIKAN sign-up publik.
insert into public.site_admins(email) values ('EMAIL-ADMIN@contoh.com') on conflict do nothing;
