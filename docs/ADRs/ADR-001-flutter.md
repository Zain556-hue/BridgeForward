# ADR-001: Flutter for iOS + Android (one codebase)

Date: 2026-09-27
Status: Accepted (Phase 0)

## Context
PRD §6 needs device picker, share-intent (Share to BridgeForward), Save to device, direct WhatsApp handoff. Must ship iOS + Android with small team.

## Decision
**Flutter 3.x (Dart)** for `apps/mobile`. Web limited to landing/admin (Next.js, Phase 8).

## Alternatives
- React Native + Expo: faster if JS-only team, weaker ffmpeg/background isolates.
- Native Swift + Kotlin: best media fidelity, 2x cost. Revisit only if Flutter media pipeline fails acceptance (Phase 4).

## Consequences
- Single UI + design-system package, Riverpod state, background isolate encodes.
- Requires Flutter SDK 3.22+ on dev machines + CI. No Flutter binary on this machine yet — manual scaffold used; run `flutter create`/`flutter pub get` after SDK install.
