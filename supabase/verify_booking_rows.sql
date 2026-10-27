select
  id,
  client_name,
  provider_name,
  service_name,
  booking_date,
  booking_time,
  amount,
  status,
  created_at
from public.bookings
order by created_at desc
limit 20;
