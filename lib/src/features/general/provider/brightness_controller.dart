import 'dart:ui';

import 'package:portfolio/src/common/provider/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness_controller.g.dart';

/// The active [Brightness], persisted across visits.
///
/// Absence of a stored value means dark — the site's default, whatever the
/// operating system prefers. Only an explicit toggle writes a value, so a
/// visitor who never touches the switch keeps getting the default even if it
/// changes later. The pre-Flutter hero in web/index.html reads this same key
/// out of localStorage and falls back to dark too, so the two agree.
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
      _ => Brightness.dark,
    };
  }

  Future<void> updateBrightness() async {
    // Flip the value already on screen rather than re-reading storage. The
    // previous version read the preference back, decided from that, and wrote
    // the result without awaiting it — so a second tap that arrived before
    // the write landed read the stale value and "toggled" to the theme
    // already showing.
    final current = state.value ?? Brightness.dark;
    final next =
        current == Brightness.dark ? Brightness.light : Brightness.dark;

    // Publish synchronously, and never through AsyncLoading. Everything that
    // reads this falls back to dark whenever the value isn't `data` (see
    // MyApp and DarkModeSwitch), so passing through a loading state
    // mid-toggle snapped the whole UI to dark — which made toggling to dark
    // look stuck.
    state = AsyncValue.data(next);

    // ref.read, not ref.watch: this runs outside build(), where watching
    // would register a dependency at the wrong time.
    final sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.setString(_brightnessKey, next.name);
  }
}
