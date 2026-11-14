-- Run this ONCE in the Supabase SQL Editor so that no two players can have the same name.
-- Names are claimed first come first served. The table can not be read or changed directly, only through the two functions below.
create table if not exists names (
  lname text primary key,
  name text not null,
  oid text not null unique,
  updated_at timestamptz default now()
);
alter table names enable row level security;   -- no policies on purpose

create or replace function claim_name(p_name text, p_oid text) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  n text := btrim(p_name);
  l text := regexp_replace(lower(btrim(p_name)), '[ _-]', '', 'g');
begin
  if char_length(n) < 2 or char_length(n) > 12 or char_length(l) < 2
     or char_length(p_oid) < 16 or char_length(p_oid) > 40 then
    return false;
  end if;
  if exists (select 1 from names where lname = l and oid <> p_oid) then
    return false;
  end if;
  delete from names where oid = p_oid and lname <> l;   -- changing name frees the old one
  insert into names(lname, name, oid) values (l, n, p_oid)
  on conflict (lname) do update set name = excluded.name, updated_at = now() where names.oid = p_oid;
  return true;
end $$;

create or replace function release_name(p_oid text) returns void
language sql security definer set search_path = public as $$
  delete from names where oid = p_oid;
$$;

revoke all on function claim_name(text, text) from public;
revoke all on function release_name(text) from public;
grant execute on function claim_name(text, text) to anon, authenticated;
grant execute on function release_name(text) to anon, authenticated;
notify pgrst, 'reload schema';
