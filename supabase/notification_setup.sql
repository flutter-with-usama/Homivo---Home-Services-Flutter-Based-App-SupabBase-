create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references auth.users(id) on delete cascade,
  provider_id uuid not null references auth.users(id) on delete cascade,
  client_name text not null default '',
  client_address text not null default '',
  provider_name text not null default '',
  service_name text not null default '',
  booking_date text not null default '',
  booking_time text not null default '',
  notes text not null default '',
  amount numeric(12, 2) not null default 0 check (amount >= 0),
  status text not null default 'pending'
    check (status in ('pending', 'accepted', 'rejected', 'completed')),
  accepted_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.bookings
  add column if not exists amount numeric(12, 2) not null default 0
    check (amount >= 0),
  add column if not exists accepted_at timestamptz,
  add column if not exists completed_at timestamptz;

alter table public.bookings enable row level security;

drop policy if exists "Users can read their own bookings" on public.bookings;
create policy "Users can read their own bookings"
  on public.bookings for select
  using (auth.uid() = client_id or auth.uid() = provider_id);

drop policy if exists "Providers can update assigned bookings"
  on public.bookings;

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references auth.users(id) on delete cascade,
  sender_id uuid references auth.users(id) on delete set null,
  type text not null default 'system_alert',
  title text not null default '',
  body text not null default '',
  is_read boolean not null default false,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.notifications enable row level security;

drop policy if exists "Users can read their own notifications"
  on public.notifications;
create policy "Users can read their own notifications"
  on public.notifications for select
  using (auth.uid() = recipient_id);

drop policy if exists "Users can update their own notifications"
  on public.notifications;
create policy "Users can update their own notifications"
  on public.notifications for update
  using (auth.uid() = recipient_id)
  with check (auth.uid() = recipient_id);

drop policy if exists "Users can delete their own notifications"
  on public.notifications;
create policy "Users can delete their own notifications"
  on public.notifications for delete
  using (auth.uid() = recipient_id);

create or replace function public.update_provider_booking(
  booking_id uuid,
  new_status text,
  quoted_amount numeric default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  booking public.bookings%rowtype;
begin
  if auth.uid() is null then
    raise exception 'Please log in again.';
  end if;

  select *
  into booking
  from public.bookings
  where id = booking_id
    and provider_id = auth.uid()
  for update;

  if not found then
    raise exception 'Booking not found.';
  end if;

  if new_status = 'accepted' then
    if booking.status != 'pending' then
      raise exception 'Only pending bookings can be accepted.';
    end if;

    if quoted_amount is null or quoted_amount <= 0 then
      raise exception 'Enter a valid quote before accepting the booking.';
    end if;

    update public.bookings
    set status = 'accepted',
        amount = quoted_amount,
        accepted_at = timezone('utc', now()),
        updated_at = timezone('utc', now())
    where id = booking_id;
  elsif new_status = 'rejected' then
    if booking.status != 'pending' then
      raise exception 'Only pending bookings can be rejected.';
    end if;

    update public.bookings
    set status = 'rejected',
        updated_at = timezone('utc', now())
    where id = booking_id;
  elsif new_status = 'completed' then
    if booking.status != 'accepted' then
      raise exception 'Only accepted bookings can be completed.';
    end if;

    update public.bookings
    set status = 'completed',
        completed_at = timezone('utc', now()),
        updated_at = timezone('utc', now())
    where id = booking_id;
  else
    raise exception 'Unsupported booking status.';
  end if;
end;
$$;

revoke all on function public.update_provider_booking(uuid, text, numeric)
  from public;
grant execute on function public.update_provider_booking(uuid, text, numeric)
  to authenticated;

create or replace function public.notify_client_of_booking_status()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  notification_title text;
  notification_body text;
begin
  if new.status = old.status then
    return new;
  end if;

  if new.status = 'accepted' then
    notification_title := 'Booking Accepted';
    notification_body :=
      new.provider_name || ' accepted your ' || new.service_name ||
      ' request. Quote: $' || trim(to_char(new.amount, 'FM999999990.00'));
  elsif new.status = 'rejected' then
    notification_title := 'Booking Declined';
    notification_body :=
      new.provider_name || ' could not accept your ' || new.service_name ||
      ' request.';
  elsif new.status = 'completed' then
    notification_title := 'Job Completed';
    notification_body :=
      'Your ' || new.service_name || ' job with ' || new.provider_name ||
      ' was marked as completed.';
  else
    return new;
  end if;

  insert into public.notifications (
    recipient_id,
    sender_id,
    type,
    title,
    body
  )
  values (
    new.client_id,
    new.provider_id,
    'booking_' || new.status,
    notification_title,
    notification_body
  );

  return new;
end;
$$;

drop trigger if exists notify_client_of_booking_status
  on public.bookings;
create trigger notify_client_of_booking_status
  after update of status on public.bookings
  for each row
  execute function public.notify_client_of_booking_status();

drop function if exists public.notify_provider_of_booking(
  uuid,
  text,
  text,
  text
);
drop function if exists public.notify_provider_of_booking(
  uuid,
  text,
  text,
  text,
  text
);

create function public.notify_provider_of_booking(
  provider_id uuid,
  service_name text,
  booking_date text,
  booking_time text,
  booking_notes text default '',
  client_budget numeric default 0
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  client_profile public.profiles%rowtype;
  provider_profile public.profiles%rowtype;
  notification_body text;
begin
  if auth.uid() is null then
    raise exception 'Please log in before booking.';
  end if;

  select *
  into client_profile
  from public.profiles
  where id = auth.uid();

  if not found then
    raise exception 'Client profile not found.';
  end if;

  if client_profile.role != 'client' then
    raise exception 'Only clients can create booking requests.';
  end if;

  select *
  into provider_profile
  from public.profiles
  where id = provider_id
    and role = 'provider';

  if not found then
    raise exception 'Provider not found.';
  end if;

  notification_body :=
    client_profile.full_name || ' requested ' || service_name ||
    ' service at ' || client_profile.address ||
    ' for ' || booking_date || ' at ' || booking_time || '.';

  if coalesce(client_budget, 0) > 0 then
    notification_body := notification_body ||
      ' Client budget: $' || trim(to_char(client_budget, 'FM999999990.00')) || '.';
  end if;

  if nullif(trim(booking_notes), '') is not null then
    notification_body := notification_body || ' Notes: ' || trim(booking_notes);
  end if;

  insert into public.bookings (
    client_id,
    provider_id,
    client_name,
    client_address,
    provider_name,
    service_name,
    booking_date,
    booking_time,
    notes,
    amount
  )
  values (
    auth.uid(),
    provider_id,
    client_profile.full_name,
    client_profile.address,
    provider_profile.full_name,
    service_name,
    booking_date,
    booking_time,
    coalesce(booking_notes, ''),
    coalesce(client_budget, 0)
  );

  insert into public.notifications (
    recipient_id,
    sender_id,
    type,
    title,
    body
  )
  values (
    provider_id,
    auth.uid(),
    'new_job_request',
    'New Job Request!',
    notification_body
  );
end;
$$;

notify pgrst, 'reload schema';

revoke all on function public.notify_provider_of_booking(
  uuid,
  text,
  text,
  text,
  text,
  numeric
) from public;
grant execute on function public.notify_provider_of_booking(
  uuid,
  text,
  text,
  text,
  text,
  numeric
) to authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'notifications'
  ) then
    alter publication supabase_realtime add table public.notifications;
  end if;

  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'bookings'
  ) then
    alter publication supabase_realtime add table public.bookings;
  end if;
end;
$$;

notify pgrst, 'reload schema';
