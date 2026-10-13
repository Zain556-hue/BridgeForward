# BridgeForward Android wrapper (PWA → APK)

Packages the PWA in `site/` as an installable Android app via
[Capacitor](https://capacitorjs.com/). The APK is built in the cloud by the
`android-apk` GitHub Actions workflow — no local Android SDK needed.

## Rebuild the APK

- Push to the `apk-capacitor` branch (changes under `site/`, `apps/pwa/`
  rebuild automatically), or
- Trigger manually: repo → Actions → `android-apk` → Run workflow.

Download the finished `BridgeForward-apk` artifact from the workflow run.
It contains `app-debug.apk` (debug-signed, fine for sideload testing).

## Install on a phone

1. Copy the APK to the phone (USB, Drive, WhatsApp, …).
2. Open it and allow **Install unknown apps** when asked.
3. Open **BridgeForward** from the app drawer — it works like the
   installed PWA (offline shell + online backend when configured).

Note: debug-signed builds each carry a fresh signature, so uninstall the
old build before installing a newer one. For Play Store distribution a
release keystore + `assembleRelease` is needed instead.

## Assets

- `assets/icon.png` (1024) and `assets/splash.png` are generated from the
  brand gradient by `gen_icons.py`; `capacitor-assets` turns them into
  Android launcher icons + splash screen during the build.
- `android/` (generated native project) and `node_modules/` are gitignored
  and recreated by the workflow on every run.
