# ADR-003: Client-First Media Pipeline

Date: 2026-09-27
Status: Accepted (Phase 0)

## Context
Core loop Select → Prepare → Share must be fast, offline-capable, private, near-zero server cost.

## Decision
Process 90% on-device (pick → validate → plan → ffmpeg → preview → save/share). Server only for thumbs/moderation queue (Phase 7+).

## Pipeline Contract
`pick() → validate() → analyze() → plan() → execute() → preview() → save/share() → log_activity()`

- Photo: max 2560 long edge, q92, keep orientation, HEIC→JPEG if needed, optional GPS strip.
- Video: H.264 + AAC, 1080p max, CRF 20-23, faststart, warn >64MB (Status limit).
- Job: cancellable, reports bytes_before/after.

## Consequences
- Packages: `image_picker`, `photo_manager`, `receive_sharing_intent`, `share_plus`, `flutter_image_compress`/`image`, `video_compress`/`ffmpeg_kit`, `path_provider`.
- Long encodes run in background isolate + foreground service (Android).
