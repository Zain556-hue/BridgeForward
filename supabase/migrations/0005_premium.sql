-- Phase 8: pay stub only. No pay wall yet (plan rule).
alter table profiles add column if not exists is_premium boolean default false;
alter table profiles add column if not exists plan text default 'free';
