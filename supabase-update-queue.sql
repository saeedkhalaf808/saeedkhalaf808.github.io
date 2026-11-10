-- Run this ONCE in the Supabase SQL Editor to switch on "Find an opponent" (open queue).
create table if not exists queue (
  id bigint generated always as identity primary key,
  code text not null check (char_length(code) = 5),
  name text not null check (char_length(name) <= 12),
  created_at timestamptz default now()
);
alter table queue enable row level security;
create policy "anyone can read queue" on queue for select using (true);
create policy "anyone can join queue" on queue for insert with check (true);
create policy "anyone can leave queue" on queue for delete using (true);
