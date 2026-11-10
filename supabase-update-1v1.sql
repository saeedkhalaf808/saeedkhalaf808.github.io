-- Run this ONCE in the Supabase SQL Editor to switch on 1v1 matches.

-- 1) Let the leaderboard accept the new 1v1 mode.
alter table leaderboard drop constraint if exists scores_mode_check;
alter table leaderboard drop constraint if exists leaderboard_mode_check;
alter table leaderboard add constraint leaderboard_mode_check
  check (mode in ('classic','timed','versus','daily'));

-- 2) A table that holds each player's result in a 1v1 match.
create table if not exists matches (
  id bigint generated always as identity primary key,
  code text not null check (char_length(code) = 5),
  name text not null check (char_length(name) <= 12),
  score int not null check (score between 0 and 1000000),
  created_at timestamptz default now()
);
alter table matches enable row level security;
create policy "anyone can read matches" on matches for select using (true);
create policy "anyone can add matches" on matches for insert with check (true);

-- 3) OPTIONAL: the scoring changed, so old scores are not comparable. Run this to wipe the old leaderboard.
-- delete from leaderboard;
