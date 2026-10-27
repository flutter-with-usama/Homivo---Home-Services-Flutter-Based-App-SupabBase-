-- Run this after profile_setup.sql.
-- Replace the email below with the account that should open the admin panel.
-- Create that account first through the app as a client or in Authentication > Users.

do $$
declare
  admin_email text := 'YOUR_ADMIN_EMAIL';
begin
  update public.profiles
  set
    role = 'admin',
    updated_at = timezone('utc', now())
  where email = admin_email;

  if not found then
    raise exception 'No profile found for %. Create the account first.', admin_email;
  end if;

  update auth.users
  set raw_user_meta_data =
    coalesce(raw_user_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
  where email = admin_email;

  if not found then
    raise exception 'No Auth user found for %.', admin_email;
  end if;
end;
$$;
