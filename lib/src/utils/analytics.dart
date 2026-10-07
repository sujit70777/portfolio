/// No analytics backend is wired up (the site loads no third-party
/// scripts), so [track] is a no-op on every platform. Call sites stay so a
/// backend can be wired later without touching every button.
class Analytics {
  Analytics._();

  static void track(String event, {Map<String, String>? props}) {}
}
