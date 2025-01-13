'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "9d310ba827f510f0b3b25f02470284d3",
"assets/AssetManifest.bin.json": "33aeedcee4f976aea15aed2d2cf9c008",
"assets/AssetManifest.json": "53628b76e18480c169931d5ddf0e7eb9",
"assets/assets/avspecification/10.png": "84374d10b6cac564107272de508f6a88",
"assets/assets/avspecification/11.png": "3d01848df346f32de55371bf1e0dcbee",
"assets/assets/avspecification/12.png": "5fac6242d33b6bb096c15bf7c22f47f1",
"assets/assets/avspecification/6.png": "50143deb3cac4af804f9ceed3822b561",
"assets/assets/avspecification/7.png": "d6f757bad8b65bf79189a1612143be50",
"assets/assets/avspecification/8.png": "edef2cd4c39e1e7b4662a52686c61e16",
"assets/assets/avspecification/9.png": "6843d3167c05f9fa63dd0aa6d4151cee",
"assets/assets/banner/1.png": "c7ad0799ab8bacf948fb8f24faab9243",
"assets/assets/banner/2.png": "5d70a13e0a4699e2f788ebfaf697a498",
"assets/assets/banner/3.png": "e6109c1042e0555bc143ce7281321279",
"assets/assets/bg.jpg": "bd2ef14c96aacbdab323c8814a3dc6a1",
"assets/assets/bg_large.jpg": "96029fe918f73ae341c18a7cef331378",
"assets/assets/epson_1776w.png": "4102459e04b4a15f73279dcbd3be82e8",
"assets/assets/epson_2155w.png": "ddb2831f3261855565967627f91288d7",
"assets/assets/epson_x51.png": "525e7a16cd81999442a89cc2b024b5ae",
"assets/assets/fonts/Roboto-Bold.ttf": "2e9b3d16308e1642bf8549d58c60f5c9",
"assets/assets/fonts/Roboto-Regular.ttf": "327362a7c8d487ad3f7970cc8e2aba8d",
"assets/assets/images/eng.jpg": "4d9c3348d7de0f7287a3c5d3fa9ae338",
"assets/assets/novotel/1.png": "aeb4c60be15347d72ebcf43001e8eaba",
"assets/assets/novotel/2.png": "00e2cec797158f8f93e753591ae0fb3b",
"assets/assets/novotel/3.png": "de467199478984bf6fa37a3bcdca219d",
"assets/assets/novotel/4.png": "72f777fc2f99cd7f7f3f4f1e0e8d8fd0",
"assets/assets/novotel/5.png": "fe94010aae28932730df93ff39b28ee1",
"assets/assets/panasonic_ex800.png": "2db76f49ff5bc21c8622bc58e8ea708f",
"assets/assets/png/calendar.png": "4308707d11f2a80e5c7588411cf55898",
"assets/assets/png/hotel.png": "78057f00454b213706e5b294940fbeaa",
"assets/assets/png/info.png": "ea496e3dcd980cf8980dea188429f8c7",
"assets/assets/png/screwdriver_wrench.png": "c0e3b9bc11687177de78bd77b886062c",
"assets/assets/png/stopwatch.png": "9d0a4bc3a2cee08b6fc47f68fcf3f906",
"assets/assets/png/store.png": "e5608b2066da0096bea35ab5b657c32d",
"assets/assets/png/wave_square.png": "f005c05be4afe7ee1bc557d3b50cf292",
"assets/assets/sony_ch370.png": "bed88d42fd31bb173148955e05a6fb74",
"assets/FontManifest.json": "c5238a9df6770f15fb4677c696cfca5f",
"assets/fonts/MaterialIcons-Regular.otf": "afebaafac8ab84375eb4b662023d0195",
"assets/NOTICES": "8bcc178afd9265f2c8489419c6ec5d19",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6c257c6d587c7eb2b6bbbb53bbd8f859",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "f930cd76afc3118f1f7c87d941f012f2",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "eb792e2f7bf404abdb165eddac5d04bc",
"/": "eb792e2f7bf404abdb165eddac5d04bc",
"main.dart.js": "04cbe13e460dd19de8d295c68b1ebd51",
"manifest.json": "4fe2bdc102df2d7a9af04cd82d6ecb23",
"version.json": "73855b5d94312a332a3e56d444d7168c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
