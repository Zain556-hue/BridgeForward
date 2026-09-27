# ADR-004: Share-as-Document Default to WhatsApp

Date: 2026-09-27
Status: Accepted (Phase 0)

## Context
WhatsApp recompresses gallery images/videos. Product promise is "preserve as much original quality as possible" — cannot claim lossless.

## Decision
Default **Share to WhatsApp as Document/File** (FileProvider URI, `ACTION_SEND` + `setPackage("com.whatsapp")`, fallback chooser). Pre-resize to WhatsApp-friendly caps so second-pass compression is less destructive. Copy says "Prepared for WhatsApp", never "Lossless". Document HD/Status distinction in UI.

## Consequences
- Android: FileProvider + `receive_sharing_intent` for inbound shares.
- iOS: `UIActivityViewController`; Share Extension deferred to Phase 5+ if time.
- QA must compare Document vs Gallery paths on WhatsApp + Business (Phase 8 matrix).
