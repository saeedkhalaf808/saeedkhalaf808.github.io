-- Paste this into the Supabase "SQL Editor" and press Run.
create table leaderboard (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) <= 12),
  score int not null check (score between 0 and 1000000),
  mode text not null check (mode in ('classic','timed','daily')),
  diff int not null check (diff between 0 and 2),
  day int not null,
  created_at timestamptz default now()
);
alter table leaderboard enable row level security;
create policy "anyone can read leaderboard" on leaderboard for select using (true);
create policy "anyone can add to leaderboard" on leaderboard for insert with check (true);
