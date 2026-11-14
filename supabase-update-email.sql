-- Run this ONCE in the Supabase SQL Editor to switch on email sign-in for accounts.
create table if not exists profiles (
  uid uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null check (octet_length(data::text) < 4000),
  updated_at timestamptz default now()
);
alter table profiles enable row level security;
drop policy if exists "read own profile" on profiles;
drop policy if exists "insert own profile" on profiles;
drop policy if exists "update own profile" on profiles;
create policy "read own profile" on profiles for select using (auth.uid() = uid);
create policy "insert own profile" on profiles for insert with check (auth.uid() = uid);
create policy "update own profile" on profiles for update using (auth.uid() = uid) with check (auth.uid() = uid);
notify pgrst, 'reload schema';
