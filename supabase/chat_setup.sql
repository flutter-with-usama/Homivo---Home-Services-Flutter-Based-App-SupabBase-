create table if not exists public.chat_conversations (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references auth.users(id) on delete cascade,
  provider_id uuid not null references auth.users(id) on delete cascade,
  client_name text not null default '',
  provider_name text not null default '',
  last_message text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (client_id, provider_id)
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.chat_conversations(id)
    on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (length(trim(body)) > 0),
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists chat_conversations_client_id_idx
  on public.chat_conversations(client_id);
create index if not exists chat_conversations_provider_id_idx
  on public.chat_conversations(provider_id);
create index if not exists chat_messages_conversation_id_created_at_idx
  on public.chat_messages(conversation_id, created_at);

alter table public.chat_conversations enable row level security;
alter table public.chat_messages enable row level security;

drop policy if exists "Participants can read conversations"
  on public.chat_conversations;
create policy "Participants can read conversations"
  on public.chat_conversations for select
  using (auth.uid() = client_id or auth.uid() = provider_id);

drop policy if exists "Participants can read messages" on public.chat_messages;
create policy "Participants can read messages"
  on public.chat_messages for select
  using (
    exists (
      select 1
      from public.chat_conversations
      where id = conversation_id
        and (client_id = auth.uid() or provider_id = auth.uid())
    )
  );

drop policy if exists "Participants can send messages" on public.chat_messages;
create policy "Participants can send messages"
  on public.chat_messages for insert
  with check (
    sender_id = auth.uid()
    and exists (
      select 1
      from public.chat_conversations
      where id = conversation_id
        and (client_id = auth.uid() or provider_id = auth.uid())
    )
  );

create or replace function public.open_provider_chat(target_provider_id uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  client_profile public.profiles%rowtype;
  provider_profile public.profiles%rowtype;
  conversation_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Please log in before starting a chat.';
  end if;

  select *
  into client_profile
  from public.profiles
  where id = auth.uid()
    and role = 'client';

  if not found then
    raise exception 'Only clients can start provider chats.';
  end if;

  select *
  into provider_profile
  from public.profiles
  where id = target_provider_id
    and role = 'provider';

  if not found then
    raise exception 'Provider not found.';
  end if;

  insert into public.chat_conversations (
    client_id,
    provider_id,
    client_name,
    provider_name
  )
  values (
    auth.uid(),
    target_provider_id,
    client_profile.full_name,
    provider_profile.full_name
  )
  on conflict (client_id, provider_id) do update set
    client_name = excluded.client_name,
    provider_name = excluded.provider_name
  returning id into conversation_id;

  return conversation_id;
end;
$$;

revoke all on function public.open_provider_chat(uuid) from public;
grant execute on function public.open_provider_chat(uuid) to authenticated;

-- Allows a provider to open (or retrieve) a conversation with a specific client.
create or replace function public.open_client_chat(target_client_id uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  provider_profile public.profiles%rowtype;
  client_profile   public.profiles%rowtype;
  conversation_id  uuid;
begin
  if auth.uid() is null then
    raise exception 'Please log in before starting a chat.';
  end if;

  select *
  into provider_profile
  from public.profiles
  where id = auth.uid()
    and role = 'provider';

  if not found then
    raise exception 'Only providers can use this function.';
  end if;

  select *
  into client_profile
  from public.profiles
  where id = target_client_id
    and role = 'client';

  if not found then
    raise exception 'Client not found.';
  end if;

  insert into public.chat_conversations (
    client_id,
    provider_id,
    client_name,
    provider_name
  )
  values (
    target_client_id,
    auth.uid(),
    client_profile.full_name,
    provider_profile.full_name
  )
  on conflict (client_id, provider_id) do update set
    client_name  = excluded.client_name,
    provider_name = excluded.provider_name
  returning id into conversation_id;

  return conversation_id;
end;
$$;

revoke all on function public.open_client_chat(uuid) from public;
grant execute on function public.open_client_chat(uuid) to authenticated;

create or replace function public.sync_chat_conversation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.chat_conversations
  set
    last_message = new.body,
    updated_at = new.created_at
  where id = new.conversation_id;

  return new;
end;
$$;

drop trigger if exists sync_chat_conversation on public.chat_messages;
create trigger sync_chat_conversation
  after insert on public.chat_messages
  for each row execute procedure public.sync_chat_conversation();

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'chat_conversations'
  ) then
    alter publication supabase_realtime add table public.chat_conversations;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'chat_messages'
  ) then
    alter publication supabase_realtime add table public.chat_messages;
  end if;
end;
$$;
