/// Cloudflare Web Analytics is pageview-only (beacon in web/index.html).
/// Custom CTA events are not supported on the free product, so [track] is a
/// no-op on every platform. Call sites stay so a richer backend can be wired
/// later without touching every button.
class Analytics {
  Analytics._();

  static void track(String event, {Map<String, String>? props}) {}
}
