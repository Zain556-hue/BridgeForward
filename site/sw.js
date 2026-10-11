// BridgeForward Service Worker
// Caches app shell for offline installability

const CACHE_NAME = 'bridgeforward-v2';
const APP_SHELL = [
  '/',
  '/index.html',
  '/editor.html',
  '/app.js',
  '/manifest.json',
  '/icons/icon-192.png',
  '/icons/icon-512.png'
];

// Install - cache app shell
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

// Activate - clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

// Fetch - network first for API, cache first for app shell
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // Skip non-GET
  if (event.request.method !== 'GET') return;
  
  // Skip cross-origin
  if (url.origin !== location.origin) return;
  
  // API calls - network only (don't cache)
  if (url.pathname.startsWith('/api/') || url.hostname.includes('supabase') || url.hostname.includes('cloudinary')) {
    event.respondWith(fetch(event.request));
    return;
  }
  
  // App shell - cache first
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        if (response.ok && APP_SHELL.includes(url.pathname)) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone));
        }
        return response;
      });
    })
  );
});