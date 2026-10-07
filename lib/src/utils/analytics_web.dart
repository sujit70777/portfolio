/// Cloudflare Web Analytics is pageview-only (beacon in [web/index.html]).
/// Custom CTA events are not supported on the free product, so [track] is a
/// no-op — call sites stay so we can wire a richer backend later without
/// touching every button.
class Analytics {
  Analytics._();

  static void track(String event, {Map<String, String>? props}) {}
}
