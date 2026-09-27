-- Phase 2: full-text search helpers for Explore (Phase 7 uses this).
-- Trigram for typo-tolerant name search + tsvector for listing search.

create extension if not exists pg_trgm;

alter table opportunities add column if not exists search_tsv tsvector
  generated always as (
    to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,'') || ' ' || coalesce(problem,''))
  ) stored;

create index if not exists opportunities_search_idx on opportunities using gin (search_tsv);
create index if not exists profiles_name_trgm_idx on profiles using gin (name gin_trgm_ops);
create index if not exists media_owner_created_idx on media_items (owner_id, created_at desc);
create index if not exists interests_opp_idx on interests (opportunity_id, created_at desc);
