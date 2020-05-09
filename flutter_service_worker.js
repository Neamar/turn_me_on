'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "fb922fb9c50c22b50b3f03990840c8d4",
"assets/fonts/RobotoMono-Regular.ttf": "b4618f1f7f4cee0ac09873fcc5a966f9",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "10c1b9abad060266b6a1338d841b3933",
"assets/LICENSE": "a1fc4fb36fc110f1d9c112e5b60aacae",
"assets/AssetManifest.json": "207f69b203b038a2d18179cd3927d463",
"manifest.json": "9393a5d5fb21a7e5aed029d4dc88c278",
"small.html": "56ea78eddb59699af46f87f7ca8c43f4",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"index.html": "c5d220e8b9398c14a28b4a52910b9b96",
"/": "c5d220e8b9398c14a28b4a52910b9b96"
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
