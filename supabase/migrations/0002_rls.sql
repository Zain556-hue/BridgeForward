-- Phase 2: Row Level Security (RLS) policies for 0001_init.sql tables.
-- Public read for opportunities; owner-only for media/activities/notifications;
-- interests insertable by any signed-in user, readable by owner + actor.

-- Helper: is the row mine?
create or replace function public.is_owner(owner_id uuid)
returns boolean language sql stable as $$ select auth.uid() = owner_id $$;

-- profiles: anyone reads basic card, only owner edits
drop policy if exists "profiles read" on profiles;
create policy "profiles read" on profiles for select using (true);
drop policy if exists "profiles self-write" on profiles;
create policy "profiles self-write" on profiles for all using (public.is_owner(id)) with check (public.is_owner(id));

-- media_items: owner only
drop policy if exists "media owner all" on media_items;
create policy "media owner all" on media_items for all
  using (public.is_owner(owner_id)) with check (public.is_owner(owner_id));

-- opportunities: public read (not paused), owner writes
drop policy if exists "opps public read" on opportunities;
create policy "opps public read" on opportunities for select using (paused = false or public.is_owner(owner_id));
drop policy if exists "opps owner write" on opportunities;
create policy "opps owner write" on opportunities for all
  using (public.is_owner(owner_id)) with check (public.is_owner(owner_id));

-- interests: signed-in user can express interest; owner of opp + actor can read
drop policy if exists "interests insert" on interests;
create policy "interests insert" on interests for insert
  with check (auth.uid() = actor_id);
drop policy if exists "interests read" on interests;
create policy "interests read" on interests for select using (
  auth.uid() = actor_id
  or exists (select 1 from opportunities o where o.id = opportunity_id and o.owner_id = auth.uid())
);
drop policy if exists "interests actor update" on interests;
create policy "interests actor update" on interests for update using (auth.uid() = actor_id);

-- activities + notifications: owner read only (written by edge functions / triggers)
drop policy if exists "activities owner read" on activities;
create policy "activities owner read" on activities for select using (public.is_owner(owner_id));
drop policy if exists "notifications owner read" on notifications;
create policy "notifications owner read" on notifications for select using (public.is_owner(user_id));
drop policy if exists "notifications owner update" on notifications;
create policy "notifications owner update" on notifications for update using (public.is_owner(user_id));
