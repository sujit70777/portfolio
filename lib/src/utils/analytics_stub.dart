/// No-op analytics outside web (and Cloudflare free is pageview-only anyway).
class Analytics {
  Analytics._();

  static void track(String event, {Map<String, String>? props}) {}
}
