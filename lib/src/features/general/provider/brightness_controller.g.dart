// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brightness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BrightnessController)
final brightnessControllerProvider = BrightnessControllerProvider._();

final class BrightnessControllerProvider
    extends $AsyncNotifierProvider<BrightnessController, Brightness> {
  BrightnessControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'brightnessControllerProvider',
          isAutoDispose: true,
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
    r'ea3b122a28db7153eb49b41206cb7a457043f3a8';

abstract class _$BrightnessController extends $AsyncNotifier<Brightness> {
  FutureOr<Brightness> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Brightness>, Brightness>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Brightness>, Brightness>,
        AsyncValue<Brightness>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
