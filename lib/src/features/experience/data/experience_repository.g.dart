// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(experienceRepository)
final experienceRepositoryProvider = ExperienceRepositoryProvider._();

final class ExperienceRepositoryProvider
    extends
        $FunctionalProvider<
          ExperienceRepository,
          ExperienceRepository,
          ExperienceRepository
        >
    with $Provider<ExperienceRepository> {
  ExperienceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'experienceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$experienceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExperienceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExperienceRepository create(Ref ref) {
    return experienceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExperienceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExperienceRepository>(value),
    );
  }
}

String _$experienceRepositoryHash() =>
    r'e2c93a9890fd3b967e19e1f30e156328bc48034b';
