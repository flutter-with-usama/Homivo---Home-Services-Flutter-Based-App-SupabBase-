create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  email text not null default '',
  phone text not null default '',
  address text not null default '',
  role text not null default 'client'
    check (role in ('client', 'provider', 'admin')),
  specialty text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);
   
alter table public.profiles enable row level security;

alter table public.profiles
  drop constraint if exists profiles_role_check;

alter table public.profiles
  add constraint profiles_role_check
  check (role in ('client', 'provider', 'admin'));

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  if old.role is distinct from new.role
      and auth.uid() is not null
      and not public.is_admin() then
    raise exception 'Only admins can change account roles.';
  end if;
  return new;
end;
$$;

drop trigger if exists protect_profile_role on public.profiles;
create trigger protect_profile_role
  before update of role on public.profiles
  for each row execute procedure public.protect_profile_role();

drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile"
  on public.profiles for select
  using (auth.uid() = id);

drop policy if exists "Anyone can read provider profiles" on public.profiles;
create policy "Anyone can read provider profiles"
  on public.profiles for select
  using (role = 'provider');

drop policy if exists "Admins can read all profiles" on public.profiles;
create policy "Admins can read all profiles"
  on public.profiles for select
  using (public.is_admin());

drop policy if exists "Users can create their own profile" on public.profiles;
create policy "Users can create their own profile"
  on public.profiles for insert
  with check (
    auth.uid() = id
    and (role != 'admin' or public.is_admin())
  );

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (
    id,
    full_name,
    email,
    phone,
    address,
    role,
    specialty
  )
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'phone', ''),
    coalesce(new.raw_user_meta_data ->> 'address', ''),
    case when new.raw_user_meta_data ->> 'role' = 'provider'
      then 'provider'
      else 'client'
    end,
    coalesce(new.raw_user_meta_data ->> 'specialty', '')
  )
  on conflict (id) do update set
    full_name = excluded.full_name,
    email = excluded.email,
    phone = excluded.phone,
    address = excluded.address,
    role = public.profiles.role,
    specialty = excluded.specialty,
    updated_at = timezone('utc', now());

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert or update of raw_user_meta_data on auth.users
  for each row execute procedure public.handle_new_user();

insert into public.profiles (
  id,
  full_name,
  email,
  phone,
  address,
  role,
  specialty
)
select
  id,
  coalesce(raw_user_meta_data ->> 'full_name', ''),
  coalesce(email, ''),
  coalesce(raw_user_meta_data ->> 'phone', ''),
  coalesce(raw_user_meta_data ->> 'address', ''),
  case
    when raw_user_meta_data ->> 'role' = 'provider' then 'provider'
    else 'client'
  end,
  coalesce(raw_user_meta_data ->> 'specialty', '')
from auth.users
on conflict (id) do nothing;

create or replace function public.delete_provider_account(provider_id uuid)
returns void
language plpgsql
security definer set search_path = ''
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin access required.';
  end if;

  if not exists (
    select 1
    from public.profiles
    where id = provider_id
      and role = 'provider'
  ) then
    raise exception 'Provider account not found.';
  end if;

  delete from auth.users where id = provider_id;
end;
$$;

revoke all on function public.delete_provider_account(uuid) from public;
grant execute on function public.delete_provider_account(uuid) to authenticated;
