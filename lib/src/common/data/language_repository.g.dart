// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(languageRepository)
final languageRepositoryProvider = LanguageRepositoryProvider._();

final class LanguageRepositoryProvider extends $FunctionalProvider<
    LanguageRepository,
    LanguageRepository,
    LanguageRepository> with $Provider<LanguageRepository> {
  LanguageRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'languageRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$languageRepositoryHash();

  @$internal
  @override
  $ProviderElement<LanguageRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LanguageRepository create(Ref ref) {
    return languageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LanguageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LanguageRepository>(value),
    );
  }
}

String _$languageRepositoryHash() =>
    r'52a0c28d28ebab9401293863f5363462764f3e54';
