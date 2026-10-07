// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brightness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(BrightnessController)
final brightnessControllerProvider = BrightnessControllerProvider._();

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
final class BrightnessControllerProvider
    extends $AsyncNotifierProvider<BrightnessController, Brightness> {
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
    r'5127a30b36622e8b45d7e5d612101559a7e28f48';

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
