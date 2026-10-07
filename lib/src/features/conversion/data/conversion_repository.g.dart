// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conversionRepository)
final conversionRepositoryProvider = ConversionRepositoryProvider._();

final class ConversionRepositoryProvider
    extends
        $FunctionalProvider<
          ConversionRepository,
          ConversionRepository,
          ConversionRepository
        >
    with $Provider<ConversionRepository> {
  ConversionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConversionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversionRepository create(Ref ref) {
    return conversionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversionRepository>(value),
    );
  }
}

String _$conversionRepositoryHash() =>
    r'd80d5b69859b4b938f460bf489e7dabbe58c6335';
