const CACHE_NAME = 'linkvault-v2';
const STATIC_CACHE = 'linkvault-static-v2';
const DYNAMIC_CACHE = 'linkvault-dynamic-v2';

// Static assets to cache
const staticAssets = [
  '/',
  '/dashboard',
  '/links',
  '/links/new',
  '/manifest.webmanifest',
  '/favicon-192x192.png',
  '/favicon-512x512.png',
  '/apple-touch-icon.png',
  '/favicon.ico'
];

// Install service worker and cache static resources
self.addEventListener('install', event => {
  console.log('Service Worker installing...');
  event.waitUntil(
    caches.open(STATIC_CACHE)
      .then(cache => {
        console.log('Caching static assets');
        return cache.addAll(staticAssets);
      })
      .then(() => {
        console.log('Static assets cached successfully');
        return self.skipWaiting(); // Activate immediately
      })
      .catch(error => {
        console.error('Error caching static assets:', error);
      })
  );
});

// Activate service worker and clean up old caches
self.addEventListener('activate', event => {
  console.log('Service Worker activating...');
  event.waitUntil(
    caches.keys()
      .then(cacheNames => {
        return Promise.all(
          cacheNames.map(cache => {
            if (cache !== STATIC_CACHE && cache !== DYNAMIC_CACHE) {
              console.log('Deleting old cache:', cache);
              return caches.delete(cache);
            }
          })
        );
      })
      .then(() => {
        console.log('Old caches cleaned up');
        return self.clients.claim(); // Take control of all pages
      })
  );
});

// Network-first strategy for dynamic content, cache-first for static assets
self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);

  // Skip non-GET requests and external requests
  if (request.method !== 'GET' || !url.origin.includes(self.location.origin)) {
    return;
  }

  // Handle navigation requests (HTML pages)
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then(response => {
          // Cache successful navigation responses
          if (response.status === 200) {
            const responseClone = response.clone();
            caches.open(DYNAMIC_CACHE)
              .then(cache => cache.put(request, responseClone));
          }
          return response;
        })
        .catch(() => {
          // Return cached page or offline fallback
          return caches.match(request)
            .then(cachedResponse => {
              return cachedResponse || caches.match('/');
            });
        })
    );
    return;
  }

  // Cache-first strategy for static assets
  if (staticAssets.includes(url.pathname) || 
      url.pathname.includes('/assets/') ||
      url.pathname.includes('/favicon') ||
      url.pathname.includes('.png') ||
      url.pathname.includes('.ico') ||
      url.pathname.includes('.webmanifest')) {
    
    event.respondWith(
      caches.match(request)
        .then(cachedResponse => {
          if (cachedResponse) {
            return cachedResponse;
          }
          return fetch(request)
            .then(response => {
              if (response.status === 200) {
                const responseClone = response.clone();
                caches.open(STATIC_CACHE)
                  .then(cache => cache.put(request, responseClone));
              }
              return response;
            });
        })
    );
    return;
  }

  // Network-first strategy for API calls and dynamic content
  event.respondWith(
    fetch(request)
      .then(response => {
        // Cache successful responses
        if (response.status === 200 && request.method === 'GET') {
          const responseClone = response.clone();
          caches.open(DYNAMIC_CACHE)
            .then(cache => {
              cache.put(request, responseClone);
              // Limit cache size
              limitCacheSize(DYNAMIC_CACHE, 50);
            });
        }
        return response;
      })
      .catch(() => {
        // Return cached response if available
        return caches.match(request);
      })
  );
});

// Utility function to limit cache size
function limitCacheSize(cacheName, maxItems) {
  caches.open(cacheName)
    .then(cache => {
      cache.keys()
        .then(keys => {
          if (keys.length > maxItems) {
            cache.delete(keys[0])
              .then(() => limitCacheSize(cacheName, maxItems));
          }
        });
    });
}

// Handle background sync for offline actions (future enhancement)
self.addEventListener('sync', event => {
  console.log('Background sync triggered:', event.tag);
  if (event.tag === 'background-sync') {
    event.waitUntil(
      // Handle offline actions when connection is restored
      console.log('Performing background sync operations')
    );
  }
});

// Handle push notifications (future enhancement)
self.addEventListener('push', event => {
  console.log('Push notification received:', event);
  // Handle push notifications here
});

// Send periodic updates to client about cache status
self.addEventListener('message', event => {
  if (event.data && event.data.type === 'CACHE_STATUS') {
    caches.keys().then(cacheNames => {
      event.ports[0].postMessage({
        type: 'CACHE_STATUS_RESPONSE',
        caches: cacheNames,
        version: CACHE_NAME
      });
    });
  }
});