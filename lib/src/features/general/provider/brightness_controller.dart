import 'dart:ui';

import 'package:portfolio/src/common/provider/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness_controller.g.dart';

/// The active [Brightness], persisted across visits.
///
/// Absence of a stored value means "follow the operating system" — it is not
/// recorded on first load. Writing it down eagerly would pin the very first
/// visit's OS setting forever, so a visitor whose machine switches to dark at
/// sunset would keep getting the light site. It also has to stay unwritten
/// for the pre-Flutter hero in web/index.html to agree with the app: that
/// markup reads this same key out of localStorage and falls back to the
/// `prefers-color-scheme` media query, which is exactly this rule.
// keepAlive: an app-wide setting, not per-screen state. Auto-disposing it
// means every rebuild re-reads storage, which throws away a toggle that has
// not finished being written — see the note on sharedPreferencesProvider.
@Riverpod(keepAlive: true)
class BrightnessController extends _$BrightnessController {
  static const _brightnessKey = "brightness";

  @override
  FutureOr<Brightness> build() async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return switch (sharedPreferences.getString(_brightnessKey)) {
      'dark' => Brightness.dark,
      'light' => Brightness.light,
      _ => PlatformDispatcher.instance.platformBrightness,
    };
  }

  Future<void> updateBrightness() async {
    // Flip the value already on screen rather than re-reading storage. The
    // previous version read the preference back, decided from that, and wrote
    // the result without awaiting it — so a second tap that arrived before
    // the write landed read the stale value and "toggled" to the theme
    // already showing.
    final current =
        state.value ?? PlatformDispatcher.instance.platformBrightness;
    final next =
        current == Brightness.dark ? Brightness.light : Brightness.dark;

    // Publish synchronously, and never through AsyncLoading. Everything that
    // reads this falls back to the OS theme whenever the value isn't `data`
    // (see MyApp and DarkModeSwitch), so passing through a loading state
    // mid-toggle snapped the whole UI to the platform brightness — which is
    // what made the toggle look stuck on machines whose OS theme was the one
    // being toggled away from.
    state = AsyncValue.data(next);

    // ref.read, not ref.watch: this runs outside build(), where watching
    // would register a dependency at the wrong time.
    final sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.setString(_brightnessKey, next.name);
  }
}
