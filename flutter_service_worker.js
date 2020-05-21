'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "small.html": "56ea78eddb59699af46f87f7ca8c43f4",
"manifest.json": "9393a5d5fb21a7e5aed029d4dc88c278",
"assets/LICENSE": "beae58eae3448f273e47783d4be4a7b7",
"assets/AssetManifest.json": "4bc20d89265a622f8c08919d5eb0ee45",
"assets/FontManifest.json": "11937e8054294362fe0a124c09e45952",
"assets/fonts/NotoSansTC-Regular-stripped.ttf": "2ec5a3c060c6c3a720ea75668503a0ac",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"index.html": "c5d220e8b9398c14a28b4a52910b9b96",
"/": "c5d220e8b9398c14a28b4a52910b9b96",
"main.dart.js": "4a5f2bb348b04ddd212af3926801093a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
