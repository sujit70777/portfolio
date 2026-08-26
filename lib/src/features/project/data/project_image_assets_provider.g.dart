// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_image_assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectImageAssetsHash() =>
    r'c0dc812a567ae54a1caff8c3f0347de8f1974147';

/// Every bundled asset path under assets/projectimage/, refreshed on each
/// app start (i.e. each hot restart / rebuild) so a screenshot dropped into
/// a project's folder shows up without touching any code or translations.
///
/// Copied from [projectImageAssets].
@ProviderFor(projectImageAssets)
final projectImageAssetsProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  projectImageAssets,
  name: r'projectImageAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectImageAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectImageAssetsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$projectImagesHash() => r'93843d61bcc18a1bd973dd0389ed985f7e0884b6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.
///
/// Copied from [projectImages].
@ProviderFor(projectImages)
const projectImagesProvider = ProjectImagesFamily();

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.
///
/// Copied from [projectImages].
class ProjectImagesFamily extends Family<AsyncValue<List<String>>> {
  /// All bundled images inside a project's `assets/projectimage/<slug>/`
  /// folder, sorted alphabetically. Empty if the project has none. The first
  /// entry is what the card uses as its thumbnail, so existing single-image
  /// callers stay unaffected — this just also exposes the rest for a gallery.
  ///
  /// Copied from [projectImages].
  const ProjectImagesFamily();

  /// All bundled images inside a project's `assets/projectimage/<slug>/`
  /// folder, sorted alphabetically. Empty if the project has none. The first
  /// entry is what the card uses as its thumbnail, so existing single-image
  /// callers stay unaffected — this just also exposes the rest for a gallery.
  ///
  /// Copied from [projectImages].
  ProjectImagesProvider call(
    String projectName,
  ) {
    return ProjectImagesProvider(
      projectName,
    );
  }

  @override
  ProjectImagesProvider getProviderOverride(
    covariant ProjectImagesProvider provider,
  ) {
    return call(
      provider.projectName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectImagesProvider';
}

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.
///
/// Copied from [projectImages].
class ProjectImagesProvider extends AutoDisposeFutureProvider<List<String>> {
  /// All bundled images inside a project's `assets/projectimage/<slug>/`
  /// folder, sorted alphabetically. Empty if the project has none. The first
  /// entry is what the card uses as its thumbnail, so existing single-image
  /// callers stay unaffected — this just also exposes the rest for a gallery.
  ///
  /// Copied from [projectImages].
  ProjectImagesProvider(
    String projectName,
  ) : this._internal(
          (ref) => projectImages(
            ref as ProjectImagesRef,
            projectName,
          ),
          from: projectImagesProvider,
          name: r'projectImagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectImagesHash,
          dependencies: ProjectImagesFamily._dependencies,
          allTransitiveDependencies:
              ProjectImagesFamily._allTransitiveDependencies,
          projectName: projectName,
        );

  ProjectImagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectName,
  }) : super.internal();

  final String projectName;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(ProjectImagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectImagesProvider._internal(
        (ref) => create(ref as ProjectImagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectName: projectName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _ProjectImagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectImagesProvider && other.projectName == projectName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectImagesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `projectName` of this provider.
  String get projectName;
}

class _ProjectImagesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with ProjectImagesRef {
  _ProjectImagesProviderElement(super.provider);

  @override
  String get projectName => (origin as ProjectImagesProvider).projectName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
