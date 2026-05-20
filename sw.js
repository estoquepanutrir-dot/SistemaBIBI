// Incrementar CACHE_VERSION a cada deploy para forçar atualização em todos os clientes
const CACHE_VERSION = '2026-05-19-v4';
const CACHE_NAME = `bibi-pdv-${CACHE_VERSION}`;

const ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './logo.png',
  './icon-192.png',
  './icon-512.png',
];

// INSTALL: abre o novo cache e pré-carrega os assets
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS))
  );
  // Ativa imediatamente sem esperar o tab fechar
  self.skipWaiting();
});

// ACTIVATE: apaga todos os caches antigos
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => {
        console.log('[SW] Deletando cache antigo:', k);
        return caches.delete(k);
      }))
    ).then(() => self.clients.claim())
  );
});

// FETCH: network-first para HTML (garante sempre a versão mais recente),
//        cache-first para assets estáticos (logo, ícones)
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  const isHTML = event.request.destination === 'document' || url.pathname.endsWith('.html') || url.pathname === '/';

  if (isHTML) {
    // Network-first: tenta buscar do servidor; se falhar, usa cache
    event.respondWith(
      fetch(event.request)
        .then(response => {
          // Atualiza o cache com a resposta mais recente
          const clone = response.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
          return response;
        })
        .catch(() => caches.match(event.request))
    );
  } else {
    // Cache-first para assets estáticos
    event.respondWith(
      caches.match(event.request).then(cached => cached || fetch(event.request))
    );
  }
});

// Notifica todos os tabs abertos quando há nova versão disponível
self.addEventListener('message', event => {
  if (event.data === 'SKIP_WAITING') self.skipWaiting();
});
