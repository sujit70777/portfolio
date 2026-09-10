// Tests for the theme toggle, which had two independent defects: the stored
// preference was derived from a stale read, and the rendered theme was
// painted by a redundant AnimatedTheme that latched onto an out-of-date
// value. These cover the first.
//
// The second is deliberately not covered here. It only appears against real
// vsync — an equivalent widget test built around MaterialApp.builder passes
// whether or not the bug is present, because pumpAndSettle runs the
// animation to completion and hides the stale latch. A test that passes
// either way is worse than none, so the guard for that one is the structural
// change and the note explaining it in lib/src/app.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/provider/brightness_controller.dart';
import 'package:portfolio/src/features/general/provider/dark_mode_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// The theme toggle used to work exactly once and then look dead: the
  /// stored preference kept flipping, but nothing that rendered the theme
  /// noticed. These walk several toggles rather than one, because a single
  /// toggle passed the whole time the bug was live.
  test('every toggle flips darkMode, not just the first', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // Hold a subscription so the derived provider stays alive between reads,
    // the way a watching widget would.
    container.listen(darkModeProvider, (_, _) {});

    await container.read(brightnessControllerProvider.future);
    final seen = <bool?>[container.read(darkModeProvider).value];

    for (var i = 0; i < 4; i++) {
      await container
          .read(brightnessControllerProvider.notifier)
          .updateBrightness();
      seen.add(container.read(darkModeProvider).value);
    }

    expect(seen[1], isNot(seen[0]), reason: 'first toggle');
    expect(seen[2], seen[0], reason: 'second toggle should come back');
    expect(seen[3], seen[1], reason: 'third toggle');
    expect(seen[4], seen[0], reason: 'fourth toggle');
  });

  test('the flipped value is persisted each time', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(darkModeProvider, (_, _) {});
    await container.read(brightnessControllerProvider.future);

    final prefs = await SharedPreferences.getInstance();
    final written = <String?>[];
    for (var i = 0; i < 3; i++) {
      await container
          .read(brightnessControllerProvider.notifier)
          .updateBrightness();
      await prefs.reload();
      written.add(prefs.getString('brightness'));
    }
    expect(written[0], isNot(written[1]));
    expect(written[2], written[0]);
    expect(
      written.last,
      container.read(darkModeProvider).value! ? 'dark' : 'light',
      reason: 'what is stored must match what is rendered',
    );
  });
}
