var cacheName = "lcann-js13k-2018-offline-::date::"
var filesToCache = ["index.html", "manifest.webmanifest", "icon.svg", "icon-192.png"];

self.addEventListener('install', function(e) {
	e.waitUntil(
		caches.open(cacheName).then(function(cache) {
			return cache.addAll(filesToCache);
		})
	);
});

self.addEventListener('fetch', function(event) {
	event.respondWith(caches.match(event.request).then(function(response) {
		if (response) {
			return response;
		}
		return fetch(event.request);
	}));
});

self.addEventListener('activate', function(event) {
	event.waitUntil(caches.keys().then(function(cacheNames) {
		return Promise.all(cacheNames.map(function(name) {
			if(name != cacheName) {
				return caches.delete(name);
			}
		}));
	}));
});