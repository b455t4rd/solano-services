// SolanoServices Service Worker – Push + Offline – v20260320
const CACHE = 'solano-v9';
const STATIC = ['/Logo.png'];

// Install: nur statische Assets cachen (NICHT index.html)
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(STATIC).catch(() => {})));
  self.skipWaiting();
});

// Activate: Alten Cache löschen
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  if (url.origin !== self.location.origin) return;

  // API GET: Netzwerk zuerst, Cache als Fallback (offline = alte Daten zeigen)
  if (url.pathname.startsWith('/api/') && e.request.method === 'GET') {
    e.respondWith(
      fetch(e.request.clone()).then(res => {
        if (res.ok) {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() =>
        caches.match(e.request).then(cached =>
          cached || new Response(JSON.stringify({ error: 'offline' }), {
            status: 503, headers: { 'Content-Type': 'application/json' }
          })
        )
      )
    );
    return;
  }

  // API Mutations (POST/PUT/DELETE): nur Netzwerk, kein Caching
  if (url.pathname.startsWith('/api/')) return;

  // index.html: IMMER Netzwerk zuerst – Cache nur als Offline-Fallback
  if (url.pathname === '/' || url.pathname === '/index.html' || url.pathname.endsWith('.html')) {
    e.respondWith(
      fetch(e.request).then(res => {
        if (res && res.ok) {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() => caches.match('/index.html'))
    );
    return;
  }

  // Sonstige Assets (Logo etc.): Cache zuerst, dann Netzwerk
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (cached) return cached;
      return fetch(e.request).then(res => {
        if (res && res.ok) {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() => caches.match('/index.html'));
    })
  );
});

self.addEventListener('push', event => {
  const data = event.data?.json() || { title: 'SolanoServices', body: 'Neue Nachricht' };
  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: '/Logo.png',
      badge: '/Logo.png',
      vibrate: data.data?.alarm ? [500,100,500,100,500,100,500] : [200, 100, 200],
      requireInteraction: data.data?.alarm || false,
      data: data.data || {}
    })
  );
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  const url = event.notification.data?.url || '/';
  event.waitUntil(
    clients.matchAll({type:'window',includeUncontrolled:true}).then(list=>{
      for(const c of list){
        if(c.url.startsWith(self.location.origin)&&'focus' in c){
          c.navigate(url);return c.focus();
        }
      }
      return clients.openWindow(url);
    })
  );
});
