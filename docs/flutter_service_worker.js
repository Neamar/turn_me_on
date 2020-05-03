'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/_site/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/_site/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/_site/small.html": "56ea78eddb59699af46f87f7ca8c43f4",
"/_site/index.html": "c5d220e8b9398c14a28b4a52910b9b96",
"/_site/main.dart.js": "30727d5697d3df6d9b9274f7df6d1b1e",
"/_site/manifest.json": "9393a5d5fb21a7e5aed029d4dc88c278",
"/_site/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/_site/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/_site/assets/LICENSE": "964211db6a8b173b1744e68da77ce459",
"/_site/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/_site/assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/small.html": "56ea78eddb59699af46f87f7ca8c43f4",
"/index.html": "c5d220e8b9398c14a28b4a52910b9b96",
"/main.dart.js": "30727d5697d3df6d9b9274f7df6d1b1e",
"/manifest.json": "9393a5d5fb21a7e5aed029d4dc88c278",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/LICENSE": "964211db6a8b173b1744e68da77ce459",
"/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"/.jekyll-cache/Jekyll/Cache/Jekyll--Cache/b7/9606fb3afea5bd1609ed40b622142f1c98125abcfe89a76a661b0e8e343910": "d37c16d3e86a60ac9b6727ee2eee5ad2"
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
