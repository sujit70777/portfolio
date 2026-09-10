// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dark_mode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(darkMode)
final darkModeProvider = DarkModeProvider._();

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

final class DarkModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<bool>,
          AsyncValue<bool>,
          AsyncValue<bool>
        >
    with $Provider<AsyncValue<bool>> {
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
  DarkModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkModeHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<bool>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<bool> create(Ref ref) {
    return darkMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$darkModeHash() => r'e99cc7e73af019fe70e536fc122cfce22bd16533';
