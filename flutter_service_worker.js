'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "c5d220e8b9398c14a28b4a52910b9b96",
"/": "c5d220e8b9398c14a28b4a52910b9b96",
"small.html": "56ea78eddb59699af46f87f7ca8c43f4",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"assets/FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/LICENSE": "a1fc4fb36fc110f1d9c112e5b60aacae",
"main.dart.js": "0b6016b942b266eaf32fc58f9bdf1fd6",
"manifest.json": "9393a5d5fb21a7e5aed029d4dc88c278"
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
