// Custom bootstrap template. `flutter build web` generates
// build/web/flutter_bootstrap.js from this file by substituting the
// double-brace tokens below. Without this file Flutter emits a default that
// is identical except for the `config` block.
//
// (Careful when editing the prose here: the substitution is a plain text
// replace over the whole file, so writing a token's name inside a comment
// inlines the real payload into that comment and corrupts the output.)
//
// canvasKitBaseUrl pins CanvasKit to this origin's own /canvaskit/ directory.
// The default is https://www.gstatic.com/flutter-canvaskit/<engineRevision>/,
// which is the single most expensive thing in a cold page load here: the
// browser cannot start the ~2MB CanvasKit download until it has done a DNS
// lookup, TCP connect and TLS handshake against a third origin, and gstatic
// serves the file gzipped. From this origin it rides the connection that
// already fetched the HTML, and the deploy workflow's Brotli pass makes it
// ~500KB smaller (see .github/workflows/deploy.yml, "Pre-compress static
// assets"). web/index.html preloads the same URLs this resolves to, so keep
// the two in sync.

{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
  },
  // Flutter's service worker is deprecated and, as of 3.47, does nothing but
  // unregister itself. It stays registered anyway: visitors who loaded this
  // site back when Flutter still shipped a *caching* worker have that old one
  // installed, and this is what evicts it. Dropping the registration would
  // strand them on a cached build indefinitely.
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
});
