# ADR-002: Supabase as MVP Backend

Date: 2026-09-27
Status: Accepted (Phase 0)

## Context
PRD §§9-18 need auth, profiles, listings, connections, activity, notifications, file storage with row-level privacy. Zero DevOps in MVP.

## Decision
**Supabase**: Postgres + Auth (OTP/Google/Apple) + Storage + Realtime + Edge Functions.

## Alternatives
- Firebase: easier FCM, weaker relational discovery queries (Explore filters across types).
- Custom NestJS + Postgres: more control, weeks of DevOps. Deferred until scale demands it.

## Consequences
- Schema in `supabase/migrations/`, RLS enforced (owner media private, opportunities public-read).
- Domain uses repository interfaces so backend can be swapped without UI rewrite.
- Needs Supabase CLI + project ref in `.env` (see `.env.example`).
