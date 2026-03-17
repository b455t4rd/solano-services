// SolanoServices Service Worker – Push Notifications – v20260316
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
