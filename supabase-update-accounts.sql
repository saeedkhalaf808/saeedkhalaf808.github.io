-- Run this ONCE in the Supabase SQL Editor to switch on account transfer between devices.
-- The accounts table can NOT be read directly. The game can only read or save an account if it knows the secret link code.
create table if not exists accounts (
  key text primary key check (char_length(key) between 16 and 40),
  data jsonb not null,
  updated_at timestamptz default now()
);
alter table accounts enable row level security;   -- no policies on purpose: blocks direct access

create or replace function get_account(p_key text) returns jsonb
language sql security definer set search_path = public as $$
  select data from accounts where key = p_key;
$$;

create or replace function save_account(p_key text, p_data jsonb) returns void
language plpgsql security definer set search_path = public as $$
begin
  if char_length(p_key) < 16 or char_length(p_key) > 40 then raise exception 'bad key'; end if;
  if octet_length(p_data::text) > 4000 then raise exception 'too big'; end if;
  insert into accounts(key, data, updated_at) values (p_key, p_data, now())
  on conflict (key) do update set data = excluded.data, updated_at = now();
end $$;

revoke all on function get_account(text) from public;
revoke all on function save_account(text, jsonb) from public;
grant execute on function get_account(text) to anon, authenticated;
grant execute on function save_account(text, jsonb) to anon, authenticated;

notify pgrst, 'reload schema';
