import 'dart:ui';

import 'package:portfolio/src/features/general/provider/brightness_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode_controller.g.dart';

/// [BrightnessController] expressed as a boolean, for the widgets that think
/// in "is it dark" rather than in [Brightness].
///
/// This watches the controller's state, not its `.future`. Watching the
/// future looks equivalent and isn't: the future only changes identity when
/// the notifier passes through a loading state, so a straight data-to-data
/// flip — which is exactly what toggling the theme now does — left every
/// dependent holding the already-completed future from the first build and
/// never rebuilt them. The visible symptom was a toggle that worked once and
/// then appeared dead.
///
/// It is deliberately not a notifier. There is one writer, and it lives on
/// [BrightnessController]; a second entry point that only forwarded to it was
/// an easy way to end up with two ideas of the current theme.
@riverpod
AsyncValue<bool> darkMode(Ref ref) {
  return ref
      .watch(brightnessControllerProvider)
      .whenData((brightness) => brightness == Brightness.dark);
}
