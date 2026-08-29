// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_image_assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every bundled asset path under assets/projectimage/, refreshed on each
/// app start (i.e. each hot restart / rebuild) so a screenshot dropped into
/// a project's folder shows up without touching any code or translations.

@ProviderFor(projectImageAssets)
final projectImageAssetsProvider = ProjectImageAssetsProvider._();

/// Every bundled asset path under assets/projectimage/, refreshed on each
/// app start (i.e. each hot restart / rebuild) so a screenshot dropped into
/// a project's folder shows up without touching any code or translations.

final class ProjectImageAssetsProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Every bundled asset path under assets/projectimage/, refreshed on each
  /// app start (i.e. each hot restart / rebuild) so a screenshot dropped into
  /// a project's folder shows up without touching any code or translations.
  ProjectImageAssetsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'projectImageAssetsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$projectImageAssetsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return projectImageAssets(ref);
  }
}

String _$projectImageAssetsHash() =>
    r'c0dc812a567ae54a1caff8c3f0347de8f1974147';

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.

@ProviderFor(projectImages)
final projectImagesProvider = ProjectImagesFamily._();

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.

final class ProjectImagesProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// All bundled images inside a project's `assets/projectimage/<slug>/`
  /// folder, sorted alphabetically. Empty if the project has none. The first
  /// entry is what the card uses as its thumbnail, so existing single-image
  /// callers stay unaffected — this just also exposes the rest for a gallery.
  ProjectImagesProvider._(
      {required ProjectImagesFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'projectImagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$projectImagesHash();

  @override
  String toString() {
    return r'projectImagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return projectImages(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectImagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectImagesHash() => r'93843d61bcc18a1bd973dd0389ed985f7e0884b6';

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.

final class ProjectImagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  ProjectImagesFamily._()
      : super(
          retry: null,
          name: r'projectImagesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// All bundled images inside a project's `assets/projectimage/<slug>/`
  /// folder, sorted alphabetically. Empty if the project has none. The first
  /// entry is what the card uses as its thumbnail, so existing single-image
  /// callers stay unaffected — this just also exposes the rest for a gallery.

  ProjectImagesProvider call(
    String projectName,
  ) =>
      ProjectImagesProvider._(argument: projectName, from: this);

  @override
  String toString() => r'projectImagesProvider';
}
