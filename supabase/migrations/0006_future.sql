-- Phase 9: future only. Trust before money (plan rule).
alter table opportunities add column if not exists verified boolean default false;
alter table profiles add column if not exists skills text[] default '{}';

-- Paid boost stub (no charge yet). Pick provider by region after beta map.
create table if not exists promotions (
  id uuid primary key default gen_random_uuid(),
  opportunity_id uuid not null references opportunities(id) on delete cascade,
  owner_id uuid not null references profiles(id) on delete cascade,
  status text default 'draft',
  created_at timestamptz default now()
);
alter table promotions enable row level security;
drop policy if exists "promo owner all" on promotions;
create policy "promo owner all" on promotions for all
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
