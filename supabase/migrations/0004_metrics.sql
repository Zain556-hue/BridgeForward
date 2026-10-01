-- Phase 8: count views for launch gates (PRD §26).
-- Useful activity, not just downloads.

create or replace view v_media_per_day as
  select date_trunc('day', created_at)::date as day, count(*) as prepared
  from media_items group by 1 order by 1;

create or replace view v_interests_per_listing as
  select opportunity_id, count(*) as interests
  from interests group by 1;

create or replace view v_owner_activity as
  select owner_id, kind, count(*) as n
  from activities group by 1, 2;
