import 'package:flutter/services.dart';
import 'package:portfolio/src/utils/slugify.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_image_assets_provider.g.dart';

const projectImageExtensions = {'.png', '.jpg', '.jpeg', '.webp', '.gif'};

/// Every bundled asset path under assets/projectimage/, refreshed on each
/// app start (i.e. each hot restart / rebuild) so a screenshot dropped into
/// a project's folder shows up without touching any code or translations.
@riverpod
Future<List<String>> projectImageAssets(Ref ref) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  return manifest
      .listAssets()
      .where((path) => path.startsWith('assets/projectimage/'))
      .toList();
}

/// All bundled images inside a project's `assets/projectimage/<slug>/`
/// folder, sorted alphabetically. Empty if the project has none. The first
/// entry is what the card uses as its thumbnail, so existing single-image
/// callers stay unaffected — this just also exposes the rest for a gallery.
@riverpod
Future<List<String>> projectImages(Ref ref, String projectName) async {
  final assets = await ref.watch(projectImageAssetsProvider.future);
  final folder = 'assets/projectimage/${slugify(projectName)}/';
  final matches = assets.where((path) {
    if (!path.startsWith(folder)) return false;
    final dot = path.lastIndexOf('.');
    return dot != -1 &&
        projectImageExtensions.contains(path.substring(dot).toLowerCase());
  }).toList()
    ..sort();
  return matches;
}
