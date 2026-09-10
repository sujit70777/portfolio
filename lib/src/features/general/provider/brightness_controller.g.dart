// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brightness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(BrightnessController)
final brightnessControllerProvider = BrightnessControllerProvider._();

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
final class BrightnessControllerProvider
    extends $AsyncNotifierProvider<BrightnessController, Brightness> {
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
  BrightnessControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brightnessControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brightnessControllerHash();

  @$internal
  @override
  BrightnessController create() => BrightnessController();
}

String _$brightnessControllerHash() =>
    r'7593f0f039c10a586a53507ccfac9be7aa64d192';

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

abstract class _$BrightnessController extends $AsyncNotifier<Brightness> {
  FutureOr<Brightness> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Brightness>, Brightness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Brightness>, Brightness>,
              AsyncValue<Brightness>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
