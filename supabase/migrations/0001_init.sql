-- Phase 0 baseline schema (Supabase / Postgres)
-- Run with: supabase db push (after `supabase init` + project link)

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  avatar_url text,
  role text default 'user',
  bio text,
  verified boolean default false,
  created_at timestamptz default now()
);

create table if not exists media_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles(id) on delete cascade,
  kind text not null check (kind in ('photo','video')),
  original_path text not null,
  prepared_path text,
  width int, height int, duration_s int,
  bytes_before bigint default 0,
  bytes_after bigint default 0,
  status text default 'picked',
  created_at timestamptz default now()
);

create table if not exists opportunities (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  description text not null,
  problem text,
  target_users text,
  stage text,
  needs text[] default '{}',
  types text[] default '{collaborator}',
  contact_mode text default 'in_app',
  paused boolean default false,
  created_at timestamptz default now()
);

create table if not exists interests (
  id uuid primary key default gen_random_uuid(),
  opportunity_id uuid not null references opportunities(id) on delete cascade,
  actor_id uuid not null references profiles(id) on delete cascade,
  kind text not null check (kind in ('interested','connect','collab_request','info_request')),
  message text,
  status text default 'open',
  created_at timestamptz default now(),
  unique(opportunity_id, actor_id, kind)
);

create table if not exists activities (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles(id) on delete cascade,
  kind text not null,
  ref_id uuid,
  created_at timestamptz default now()
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  body text,
  ref jsonb,
  read boolean default false,
  created_at timestamptz default now()
);

alter table profiles enable row level security;
alter table media_items enable row level security;
alter table opportunities enable row level security;
alter table interests enable row level security;
alter table activities enable row level security;
alter table notifications enable row level security;

-- Policies (mirrors IMPLEMENTATION_PLAN Phase 2.2):
-- media: owner read/write; opportunities: public read, owner write;
-- interests: anyone inserts, owner + actor read; activities/notifications: owner read.
-- NOTE: create storage buckets originals (private), prepared (private), avatars (public), thumbs (public) via dashboard or storage API.
