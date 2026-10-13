import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.bridgeforward.app',
  appName: 'BridgeForward',
  // The PWA lives in site/ at the repo root; `cap sync` copies it in.
  webDir: '../../site',
};

export default config;
