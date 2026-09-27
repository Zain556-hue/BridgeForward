# BridgeForward — Detailed Implementation Plan

> Source of truth: `BRIGDE FORWARD PRD.docx` (30 sections) + `README.md`
> Core promise: **Select → Prepare → Share** to WhatsApp without quality loss anxiety, then grow into Investors / Collaborators / Buyers ecosystem.
> Current repo state: PRD + README only, no code. This plan starts from zero to MVP + post-MVP.

---

## 0. How This Plan Is Phased (Slide Map)

| Slide / Phase | Name | Goal |
|---|---|---|
| 0 | Foundation & Architectural Decisions | Lock scope, stack, repo structure, ADRs |
| 1 | Design System | Tokens, components, prototypes that enforce Simple/Smooth/Trustworthy |
| 2 | Architecture Blueprint | Client, backend, data, media pipeline, sharing contracts |
| 3 | App Shell, Onboarding, Account | Entry, auth, profile (PRD §9) |
| 4 | Media Core (MVP Heart) | Upload/select/share-in → Prepare → Share to WhatsApp / Save (PRD §6-7) |
| 5 | History + Personal Dashboard + Basic Activity | Reuse, tracking (PRD §8, §14-15) |
| 6 | Opportunity Platform V1 (Simplified) | Listings, Discovery, Connect (PRD §10-13) |
| 7 | Search, Notifications, Trust & Safety | (PRD §17, §16, §18) |
| 8 | Hardening, Analytics, Launch | Metrics (PRD §26), store release |
| 9 | Post-MVP / Future | Marketplaces, verification, premium, promo (PRD §19-20, §25) |

Rule: **Do not build Phase 6-9 before Phase 4 is validated** (per PRD §24 MVP).

---

## Overall Recommendation (TL;DR)

**Recommendation:** Build mobile-first MVP with **Flutter + Supabase + client-side media pipeline**, design-system-first, Share-as-Document default, and thin-slice Opportunities V1. Defer web app, chat, payments, and verification to post-MVP.

**Why:**
- PRD §6 needs OS-level pickers, share-intents, and WhatsApp handoff — web cannot do this well, so mobile-first avoids building the wrong app.
- Flutter gives iOS + Android in one codebase with mature ffmpeg/image handling; Supabase gives auth/storage/RLS/realtime without DevOps, so a small team ships MVP in weeks not months.
- Client-first media keeps costs near zero, works offline, and protects privacy; server transcode would add cost/latency with no MVP benefit.
- Share-as-Document is the only reliable way to reduce WhatsApp recompression today, so defaulting to it protects the core value prop.
- Thin Opportunities V1 prevents 3-marketplace scope creep from killing the media-core validation (PRD §24).

---

## Phase 0 — Foundation & Architectural Decisions

**Objective:** Avoid rework by locking platform, stack, and repo conventions.

### 0.1 Key Decisions (with recommendation)

1. **Platform: Mobile-first, not web-first.**
   - Why: PRD §6 requires device picker, share-intent (`Share to BridgeForward`), Save to device, direct WhatsApp handoff. All OS-level.
   - Recommendation: **Flutter 3.x (Dart) for iOS + Android from one codebase.**
   - Alternatives considered:
     - React Native + Expo: faster if team is JS-only, weaker for ffmpeg/background processing.
     - Native Swift + Kotlin: best quality, 2x cost — defer unless media pipeline proves impossible in Flutter.
   - Web: **Next.js landing + admin console only** in Phase 8, not MVP app.

2. **Backend: BaaS for MVP speed.**
   - Recommendation: **Supabase (Postgres + Auth + Storage + Realtime + Edge Functions).**
   - Why: Auth, profiles, listings, connections, activity feeds, storage for prepared media, RLS for trust/safety map 1:1 to PRD §§9-18. No DevOps in MVP.
   - Alternative: Firebase (easier push, weaker relational queries for discovery). Choose Supabase unless team already on Firebase.
   - Migration path: Keep domain logic in `domain/` + repository interfaces so you can swap to NestJS + Postgres later without UI rewrite. Record as ADR-003.

3. **Media processing: Client-first, server-fallback.**
   - Client does 90%: pick, transcode, resize, preview, save, share. Privacy + offline + zero server cost.
   - Server only for: thumbnail generation, duplicate detection, moderation queue (Phase 7+).
   - Libraries (Flutter): `image_picker`, `photo_manager`, `receive_sharing_intent`, `share_plus`, `image` / `flutter_image_compress`, `video_compress` / `ffmpeg_kit`, `path_provider`, `wakelock` for long encodes.

4. **WhatsApp quality strategy (be honest in UX):**
   - You cannot disable WhatsApp compression. You **minimize** it by:
     - a) Sharing as **Document / File** (`application/octet-stream` / image as file) where WhatsApp preserves original bytes vs. Gallery image path which recompresses.
     - b) Pre-resizing to WhatsApp-friendly caps (e.g. 2560px long edge photo, H.264 1080p ≤16Mbps video) so WhatsApp does less destructive second pass.
     - c) Offering **HD toggle guidance** + Status vs Chat distinction.
     - d) Never upscaling; preserve EXIF orientation, avoid double JPEG.
   - UX must say “Prepared for WhatsApp” not “Lossless” to stay trustworthy (PRD principle §27).

5. **Monorepo layout (proposed):**
```
bridgeforward/
  apps/
    mobile/ (flutter)
    web-landing/ (phase 8)
  packages/
    design_system/
    domain/
    media_pipeline/
  supabase/
    migrations/
    functions/
  docs/
    ADRs/
    UX/
  IMPLEMENTATION_PLAN.md
```

### 0.2 Deliverables
- [ ] ADR-001 Flutter vs RN, ADR-002 Supabase, ADR-003 Client-first media, ADR-004 Share-as-Document default
- [ ] Repo scaffolding + CI (format, analyze, test), `.env.example`, branch `master` → switch default to `main` on GitHub after Phase 0
- [ ] Definition of Done + success metrics dashboard skeleton (PRD §26)

**Recommendation (Phase 0):** Freeze Flutter + Supabase + monorepo above before any UI code.
**Why:** Every later phase assumes picker/share-intent libs, RLS tables, and repo paths. Changing stack after Phase 4 costs 3-5x more than deciding now.

**Exit criteria:** Team can run empty app + Supabase local + upload one file to Storage.

---

## Phase 1 — Design System (starts before any feature UI)

**Objective:** Make “simple, fast, effortless” systematic.

### 1.1 Tokens (V2 — bright / sharp / high-contrast, not neon)
- Color (all new):
  - `bridge.primary #2B4EFF` (bright cobalt, sharp on white ~7:1), dark `bridge.ink #162DA8`, tint `bridge.tint #E8EDFF`
  - `bridge.accent #00C896` (fresh mint for gradients/highlights only, never body text)
  - `ink #0A1628` (near-black), `muted #4B5B74`, `paper #FFFFFF`, `bg #F6F8FF`, `line #E2E8F5`
  - `wa #22C55E` (sharp WhatsApp green, dark text #053B1A on it) **only** on Share button, dark `wa.pressed #15803C`
  - `success #16A34A`, `warn #B45309` on `warn.bg #FFF4DE`, `danger #DC2626`
  - Badges: Investor `bg #E8EDFF / text #2B4EFF`, Collaborator `bg #D9F8EE / text #0A7A64`, Buyer `bg #FFE4EF / text #BE185D`, Creator `bg #E8EDFF / text #162DA8`
- Rule: bright = saturation up, lightness capped 45-62% (no neon lime/cyan/yellow); sharp = pure hues, 1px `line` borders + solid fills (no muddy gradients on text); contrast = body text ≥4.5:1, buttons ≥5:1, verified in Figma Stark.
- Type: 1 family (e.g. Inter / Plus Jakarta Sans), scale 12/14/16/20/28/34, weights 400/600/700.
- Spacing 4pt grid, radius 12/16/24, elevation 0/1/2, motion 150/250ms ease-out.
- Dark mode from day 1 (media preview needs it): `bg.dark #0A1628`, `card.dark #111F36`, primary stays `#7DA2FF` on dark for contrast.

**Recommendation (Phase 1):** Adopt V2 palette above, never use old `#0E7C66 / #25D366` except replaced by `#2B4EFF / #22C55E`.
**Why:** Old greens were dark/muddy on white and clashed with WhatsApp action. V2 cobalt is brighter and sharper, hits 7:1 on white, still distinct from WhatsApp green so primary vs Share action never confuse. Capped lightness avoids eye-strain neon while keeping buttons/cards punchy.

### 1.2 Components (MVP set only)
- Buttons: Primary (Share to WhatsApp), Secondary (Save), Tertiary (Later), Destructive.
- MediaCard (thumb, duration, “Today/Yesterday” label per PRD §8), EmptyState, ShareSheet, Progress (prepare % + cancel), HistoryRow, Avatar, Badge (Investor/Collaborator/Buyer), TextField, SearchBar, Toast/Snackbar, BottomNav (Home/History/Discover/Profile).
- Preview screen template: Before/After size + “Prepared ✓” + 3 CTAs.

### 1.3 Prototypes (Figma, clickable, no code)
- P1: Onboard → Pick → Prepare → Share
- P2: History → Re-share
- P3 (low-fi only): Create listing → Discover → Connect
- A11y: 44pt targets, contrast AA, screen-reader labels for Share actions.

**Recommendation (Phase 1):** Tokens + 12 MVP components in Figma Variables + Flutter Theme in parallel, test P1 with 5 users before coding Phase 4.
**Why:** PRD principle is Simple/Smooth/Trustworthy (§27). Without a locked Share-button pattern, preview template, and progress pattern, every screen will diverge and rework Phase 4-5. Testing “time to Share <30s” early de-risks the core journey cheapest.

**Exit criteria:** Figma library + 3 prototypes tested with 5 users; “time to Share” <30s in test.

---

## Phase 2 — Architecture Blueprint

### 2.1 Client architecture (Flutter)
- Layers: `presentation (riverpod/bloc) → domain (entities/use-cases) → data (repositories: supabase, local_cache, media_engine)`.
- State: Riverpod + `AsyncValue` for prepare jobs. Background isolate for encode.
- Local DB: Drift/Hive for History cache + pending jobs (offline-first).

### 2.2 Data model V1 (Supabase Postgres)
- `profiles(id, name, avatar_url, role, bio, verified, created_at)`
- `media_items(id, owner_id, original_path, prepared_path, kind(photo/video), width, height, duration_s, bytes_before, bytes_after, status, created_at)`
- `opportunities(id, owner_id, title, description, problem, target_users, stage, needs[], types[investor|collaborator|buyer|partner], contact_mode, created_at)`
- `interests(id, opportunity_id, actor_id, kind[interested|connect|collab_request|info_request], message, status, created_at)`
- `activities(id, owner_id, kind[view|interest|connect|message], ref_id, created_at)` (aggregated for dashboards)
- `notifications(id, user_id, title, body, ref, read, created_at)`
- Storage buckets: `originals` (private), `prepared` (private, signed URLs), `avatars` (public), `thumbs` (public).
- RLS: owner-read/write for media; public-read for opportunities; insert-only for interests; owner-read for activities/notifications.

### 2.3 Media pipeline contract
```
pick() → validate(codec/size) → analyze → plan(keep/transcode/resize) → execute(ffmpeg) → preview(thumb+stats) → save/share → log_activity
```
- Photo: keep JPEG/PNG/HEIC→JPEG if needed, max 2560 long edge, q92, preserve orientation, strip GPS optionally.
- Video: H.264 + AAC, 1080p max, CRF 20-23, faststart, keep <64MB for Status warning, generate thumb.
- Job object must be cancellable, resumable, report bytes_before/after for metrics.

### 2.4 Sharing contracts
- Android: `ACTION_SEND` with `EXTRA_STREAM` FileProvider URI, `setPackage("com.whatsapp")` for direct, fallback chooser via `share_plus`. Register `RECEIVE_SHARING_INTENT` for “Share to BridgeForward”.
- iOS: `UIActivityViewController`, Share Extension (Phase 5+ if time), Save to Photos via `photo_manager`.
- “Share elsewhere” = system chooser (no custom SDKs in MVP).

**Recommendation (Phase 2):** Approve Riverpod + Drift-local-cache + Supabase RLS ERD above, with media pipeline as cancellable background isolate job.
**Why:** Media jobs are long and killable by OS; without isolate + local queue + signed-URL storage, Phase 4 will have ANRs, lost history, and insecure buckets. Locking ERD now prevents breaking migrations in Phase 6-7 when interests/notifications depend on it.

**Exit criteria:** Sequence diagrams + ERD reviewed; storage + RLS migrations run locally.

---

## Phase 3 — App Shell, Onboarding, Account (PRD §9, §24)

- Onboarding 3 screens: Value (“Keep quality on WhatsApp”) → Permission (photos) → CTA (Select media). Skip-login to try; login only to sync/history.
- Auth: Supabase email OTP + Google + Apple. Anonymous → link on save.
- Profile: name, photo, account info, tabs: Media activity / Saved / Connections / Opportunities / Notifications (placeholders wire to later phases).
- Settings: language, clear cache, permissions, logout, delete account (store requirement).

**Recommendation (Phase 3):** Allow try-without-login, require login only for sync/history; use OTP + Google + Apple.
**Why:** PRD target includes everyday users who fear friction (§4). Forcing signup before first Share kills activation. Anonymous→link preserves conversion while still enabling Phase 5 history sync and Phase 6 identity for trust.

Acceptance: Cold start <2s, auth <60s, profile edit persists offline→sync.

---

## Phase 4 — Media Core — MVP Heart (PRD §6-7)

**Must-have user stories:**
- As user I can Upload / Select from device / Share-to-BridgeForward from gallery.
- As user I see Prepare progress and then Preview with size/time saved.
- As user I tap **Share to WhatsApp** (primary, WhatsApp-green) and land in WhatsApp with file attached.
- As user I can Save to device / Share elsewhere / Do it later.
- Failure states: unsupported codec, too large, permission denied, WhatsApp not installed.

**Tasks:**
- Picker + permissions + share-intent listener
- Media engine (photo + video presets) + job queue + cancel
- Preview UI + stats + “Prepared for WhatsApp” copy
- Share integrations + FileProvider + save-to-gallery
- Instrument: `media_prepared`, `media_shared_whatsapp`, `media_saved`

**Recommendation (Phase 4):** Ship photo-first, then video; default Share-as-Document to WhatsApp with fallback chooser; copy says “Prepared for WhatsApp” never “Lossless”.
**Why:** Photo pipeline validates 80% of UX/risk in 30% of time; video encode is where ANRs/OOM hide. Document-share preserves bytes where gallery-share recompresses, directly protecting the value prop. Honest copy avoids trust collapse when WhatsApp still touches Status uploads.

Acceptance: 10 photos + 5 videos (720p-4K) prepare+share on mid-range Android + iPhone; no crash; avg prepare <15s for 30s 1080p video.

---

## Phase 5 — History + Personal Dashboard + Basic Activity (PRD §8, §14-15)

- Recent Media list grouped Today/Yesterday/3-days-ago, search by date/kind, tap to re-share without re-prepare, swipe to delete.
- Dashboard:
  - Regular: Recent, Saved, Sharing activity count, Saved opportunities, Connections count.
  - Owner: Views, Investor/Buyer interest, Collaboration requests, Connections (counts only in V1, charts in Phase 9).
- Activity log: local first (share/save events), server aggregation for owner views later.

**Recommendation (Phase 5):** Local-first history with Drift cache + lazy Supabase sync, grouped Today/Yesterday/Older.
**Why:** Users re-share often (PRD §8) and are frequently offline/low-storage. Server-only history would feel slow and lose jobs. Local-first gives 2-tap re-share and still feeds dashboard counts for retention metrics.

Acceptance: History survives restart; re-share in 2 taps.

---

## Phase 6 — Opportunity Platform V1 Simplified (PRD §10-13)

**Deliberately thin:** prove connection value without building 3 marketplaces.

- Create listing: title, description, problem, target users, stage (idea/MVP/growth), needs, types[] (investor/collaborator/buyer/partner), contact-mode (in-app only, no phone/email leak).
- Discover: single Explore feed + filter chips (Investors/Collaborators/Buyers/Projects), cards with avatar/title/needs.
- Detail + Connect: Interested / Connect / Request collaboration / Request info → creates `interests` row, notifies owner, no personal data exposed.
- My listings: edit/pause/delete.

Out of V1: payments, promotion, verification badge logic, messaging (use “Request info” + notification; add chat in Phase 9 only if retention warrants).

**Recommendation (Phase 6):** Single Explore feed + chips + in-app interest rows, no chat, no payments, no public contact details.
**Why:** PRD §§10-13 describes 3 marketplaces, but building all three now triples moderation, search, and trust work and delays media validation. A thin slice proves “will strangers connect?” with minimal abuse surface; chat/payments can be added only if interests/week justifies it.

Acceptance: Create→Discover→Express interest e2e with 2 test accounts; owner sees counts.

---

## Phase 7 — Search, Notifications, Trust & Safety (PRD §16-18)

- Search: opportunities/businesses/projects/people/products/services via Postgres FTS (`pg_trgm` + `tsvector`), recent searches, debounce.
- Notifications: interest, collab request, buyer request, investor interest, connection reply. Prefs per kind. Supabase Realtime + FCM. No spam: batch + quiet hours.
- Trust: profiles, report/block, clear listing info, activity records, community guidelines screen, “never share sensitive info” nudges, admin hide/takedown function.

**Recommendation (Phase 7):** Postgres FTS (`tsvector` + `pg_trgm`) for search, FCM + Realtime with per-kind prefs + quiet hours, manual report→hide queue (no AI moderation yet).
**Why:** FTS avoids Algolia/Meili cost/complexity for V1 scale and covers businesses/projects/people in one index. Granular notifs prevent churn from spam (PRD §16 warns against overwhelm). Manual moderation is sufficient for <1k listings and builds the labeled dataset needed before automating.

Acceptance: Report→hide in <24h SLA mock; block prevents further interests; notification opt-out works.

---

## Phase 8 — Hardening, Analytics, Launch (PRD §26)

- Metrics: media_prepared, active users, returning users, shared_to_whatsapp, feedback, success rate, projects listed, investor/collab/buyer connections, meaningful interactions. PostHog/Mixpanel + Supabase views.
- Perf: cold start, encode time, storage quota, crash-free >99.5% (Sentry/Crashlytics).
- QA matrix: Android 10-15 + iOS 16-18, WhatsApp + Business, low-storage, offline, Arabic/English? (owner name suggests consider RTL later).
- Store: privacy policy, data safety form, screenshots showing Share to WhatsApp, internal → closed → production track.
- Business stub: Free plan flag + `is_premium` column (no paywall yet).

**Recommendation (Phase 8):** Gate launch on PostHog + Sentry + closed-track beta (50 users, ≥60% share success, ≥30% D7 return, zero P0); add paywall stub only.
**Why:** PRD §26 cares about useful activity not downloads. Instrumented beta proves media-prepared→shared→return loop before spending on promotion/premium. Paywall now would throttle the learning sample with no willingness-to-pay data (PRD §19 says validate pricing later).

Launch gate: 50 beta users, ≥60% share success, ≥30% return in 7 days, zero P0.

---

## Phase 9 — Post-MVP / Future (PRD §19-21, §25)

- Investor marketplace (thesis filters, deal-room-lite), Collaborator profiles (skills/interests), Buyer flow (catalog + inquiry tracking).
- Verified opportunities, advanced analytics, opportunity recommendations, premium/business accounts + promotion (Stripe/Paystack/Flutterwave TBD), partnerships, creator tools, marketing kit.
- Monetization experiments only after retention validated.

**Recommendation (Phase 9):** Sequence as Verified listings → Recommendations → Premium/Business + Promotion; pick payment provider by region after beta geography is known.
**Why:** Trust (verification) must precede money (promotion/premium), otherwise paid spam destroys discovery. Recommendations need Phase 5-7 interaction data to be relevant. Deferring provider choice avoids integrating Stripe where Flutterwave/Paystack is required.

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| WhatsApp still compresses gallery shares | Core value doubt | Default Share-as-Document + educate + measure perceived quality |
| OS kills long encodes | Failed prepares | Foreground service + chunk + resume + “Do it later” queue |
| Store rejection (WhatsApp trademark) | Launch delay | Say “Share to WhatsApp” as descriptive use, no logo misuse, fallback chooser |
| Spam/fake listings | Trust loss | Report/block V1, rate-limit creates, manual review queue |
| Scope creep to 3 marketplaces | MVP slip | Freeze Phase 6 to thin slice; gate Phase 9 on metrics |

---

## Immediate Next Build Order (if you say “start coding”)

1. `flutter create apps/mobile` + Supabase project + migrations for `profiles`, `media_items`
2. Design tokens in code (`packages/design_system`)
3. Onboarding + Auth + Profile shell
4. Picker → Prepare (photo only) → Preview → Share to WhatsApp → Save
5. Add video → History → Dashboard counts
6. Then Opportunities V1

---

## Open Questions for Owner

- iOS + Android both for MVP or Android-first?
- Brand color + app icon direction?
- Language(s) for MVP? English only?
- Anonymous-use allowed or login-required?
- Max video length to support in MVP (e.g. 60s Status vs any)?

*End of plan — implement Phase 0 → 1 → 2 before writing feature code.*
