# Architecture Blueprint (Phase 2)

Simple layers. UI never talks to the net directly.

```
UI (screens + Riverpod)
  → Use-cases (prepare media, share, create listing, express interest)
    → Repositories (interfaces in packages/domain)
      → Supabase (net) + Local cache (Drift, offline first)
```

## Data map

- profiles ← auth.users
- media_items (owner only)
- opportunities (public read, owner write)
- interests (actor inserts, owner + actor read)
- activities, notifications (owner read)

Rules live in `supabase/migrations/0002_rls.sql`.
Search speed in `0003_search.sql`.

## Media flow

```
pick → check type/size → plan (photo: max 2560/q92, video: 1080p/CRF22)
  → run in back task → preview (before → after)
  → share as file to WhatsApp / save / later → count event
```

## Share

- Android: file link + `com.whatsapp` direct, else open sheet.
- In: other apps can send files to us.
- iOS: system share sheet. Extra share tab later.
- Elsewhere: system sheet (no extra kits in MVP).
