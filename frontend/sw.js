// SolanoServices Service Worker – Push Notifications
self.addEventListener('push', event => {
  const data = event.data?.json() || { title: 'SolanoServices', body: 'Neue Nachricht' };
  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: '/Logo.png',
      badge: '/Logo.png',
      vibrate: [200, 100, 200],
    })
  );
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(clients.openWindow('/'));
});
