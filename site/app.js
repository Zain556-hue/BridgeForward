/* BridgeForward PWA shared logic: service worker, install prompt,
   Supabase backend calls (Edge Function + waitlist table).
   No secrets are stored here: the Supabase URL + anon key are entered
   once by the owner/visitor and kept in this device's localStorage. */
(function () {
  'use strict';

  var LS_URL = 'bf_supabase_url';
  var LS_ANON = 'bf_supabase_anon';

  function $(id) { return document.getElementById(id); }

  function getConfig() {
    var url = '', anon = '';
    try {
      url = (localStorage.getItem(LS_URL) || '').trim().replace(/\/+$/, '');
      anon = (localStorage.getItem(LS_ANON) || '').trim();
    } catch (e) { /* storage unavailable */ }
    return { url: url, anon: anon, ready: Boolean(url && anon) };
  }

  function saveConfig(url, anon) {
    url = (url || '').trim().replace(/\/+$/, '');
    anon = (anon || '').trim();
    try {
      localStorage.setItem(LS_URL, url);
      localStorage.setItem(LS_ANON, anon);
    } catch (e) { /* ignore */ }
    return { url: url, anon: anon, ready: Boolean(url && anon) };
  }

  function clearConfig() {
    try {
      localStorage.removeItem(LS_URL);
      localStorage.removeItem(LS_ANON);
    } catch (e) { /* ignore */ }
  }

  function registerSW() {
    if (!('serviceWorker' in navigator)) return;
    window.addEventListener('load', function () {
      navigator.serviceWorker.register('/sw.js').catch(function () {
        /* offline cache is best-effort */
      });
    });
  }

  function isStandalone() {
    return window.matchMedia('(display-mode: standalone)').matches ||
      window.navigator.standalone === true;
  }

  function isIOS() {
    return /iphone|ipad|ipod/i.test(navigator.userAgent) ||
      (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  }

  /* Wires an install banner + buttons. Elements are optional; missing ones are skipped.
     opts: { bannerId, installBtnId, dismissId, iosId } */
  function initInstall(opts) {
    opts = opts || {};
    var banner = opts.bannerId ? $(opts.bannerId) : null;
    var btn = opts.installBtnId ? $(opts.installBtnId) : null;
    var dismiss = opts.dismissId ? $(opts.dismissId) : null;
    var ios = opts.iosId ? $(opts.iosId) : null;
    var deferred = null;

    function show(el) { if (el) el.style.display = ''; }
    function hide(el) { if (el) el.style.display = 'none'; }

    if (isStandalone()) return; // already installed

    if (isIOS()) {
      // iOS has no beforeinstallprompt: show Share-menu instructions.
      show(banner);
      show(ios);
      return;
    }

    window.addEventListener('beforeinstallprompt', function (e) {
      e.preventDefault();
      deferred = e;
      show(banner);
      if (btn) btn.disabled = false;
    });

    window.addEventListener('appinstalled', function () {
      deferred = null;
      hide(banner);
    });

    if (btn) {
      btn.disabled = true;
      btn.addEventListener('click', function () {
        if (!deferred) {
          // Prompt not available yet: show manual instructions.
          show(ios);
          return;
        }
        deferred.prompt();
        deferred.userChoice.then(function () { deferred = null; });
      });
    }

    if (dismiss && banner) {
      dismiss.addEventListener('click', function () { hide(banner); });
    }
  }

  function apiError(res, fallback) {
    if (res.status === 409) return 'This email is already on the waitlist.';
    if (res.status === 401 || res.status === 403) {
      return 'Backend rejected the request (check the connection settings).';
    }
    return fallback || ('Request failed (HTTP ' + res.status + ').');
  }

  /* Calls the deployed Supabase Edge Function "cloudinary".
     action: get_upload_params | upload_and_transform | apply_transform |
             generate_delivery_url | delete */
  function callFunction(action, params, timeoutMs) {
    var cfg = getConfig();
    if (!cfg.ready) return Promise.reject(new Error('not-configured'));
    var ctrl = new AbortController();
    var timer = setTimeout(function () { ctrl.abort(); }, timeoutMs || 90000);
    return fetch(cfg.url + '/functions/v1/cloudinary', {
      method: 'POST',
      signal: ctrl.signal,
      headers: {
        'Content-Type': 'application/json',
        'apikey': cfg.anon,
        'Authorization': 'Bearer ' + cfg.anon
      },
      body: JSON.stringify(Object.assign({ action: action }, params || {}))
    }).then(function (res) {
      clearTimeout(timer);
      if (!res.ok) throw new Error(apiError(res, 'Cloudinary function failed.'));
      return res.json();
    }).then(function (data) {
      if (data && data.error) throw new Error(String(data.error));
      return data;
    }).catch(function (err) {
      clearTimeout(timer);
      if (err && err.name === 'AbortError') throw new Error('Request timed out. Try again.');
      throw err;
    });
  }

  /* Inserts an email into the Supabase "waitlist" table. */
  function joinWaitlist(email) {
    var cfg = getConfig();
    if (!cfg.ready) return Promise.reject(new Error('not-configured'));
    email = (email || '').trim().toLowerCase();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      return Promise.reject(new Error('Enter a valid email address.'));
    }
    return fetch(cfg.url + '/rest/v1/waitlist', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': cfg.anon,
        'Authorization': 'Bearer ' + cfg.anon,
        'Prefer': 'return=minimal'
      },
      body: JSON.stringify({ email: email, source: 'web' })
    }).then(function (res) {
      if (res.status === 201 || res.status === 200 || res.status === 204) return { ok: true };
      throw new Error(apiError(res, 'Could not join the waitlist.'));
    });
  }

  window.BF = {
    getConfig: getConfig,
    saveConfig: saveConfig,
    clearConfig: clearConfig,
    registerSW: registerSW,
    initInstall: initInstall,
    isStandalone: isStandalone,
    isIOS: isIOS,
    callFunction: callFunction,
    joinWaitlist: joinWaitlist
  };
})();
