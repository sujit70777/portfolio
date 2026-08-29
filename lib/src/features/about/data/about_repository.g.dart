// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aboutRepository)
final aboutRepositoryProvider = AboutRepositoryProvider._();

final class AboutRepositoryProvider extends $FunctionalProvider<AboutRepository,
    AboutRepository, AboutRepository> with $Provider<AboutRepository> {
  AboutRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aboutRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aboutRepositoryHash();

  @$internal
  @override
  $ProviderElement<AboutRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AboutRepository create(Ref ref) {
    return aboutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutRepository>(value),
    );
  }
}

String _$aboutRepositoryHash() => r'b1d3c81555bea9f128d4546fd11a5f1860bb5494';
