-- Paste this into the Supabase "SQL Editor" and press Run.
create table scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) <= 12),
  score int not null check (score between 0 and 1000000),
  mode text not null check (mode in ('classic','timed','daily')),
  diff int not null check (diff between 0 and 2),
  day int not null,
  created_at timestamptz default now()
);
alter table scores enable row level security;
create policy "anyone can read scores" on scores for select using (true);
create policy "anyone can add scores" on scores for insert with check (true);
