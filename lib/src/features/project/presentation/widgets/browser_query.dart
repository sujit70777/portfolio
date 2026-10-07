import 'package:portfolio/src/features/project/presentation/widgets/browser_history.dart';

/// Sets (or, with a null/empty [value], removes) one query parameter in the
/// address bar without a navigation, keeping every other parameter — so a
/// `?section=` deep link from a cold email survives opening a modal.
void setBrowserQueryParam(String key, String? value) {
  final params = Map<String, String>.from(Uri.base.queryParameters);
  if (value == null || value.isEmpty) {
    params.remove(key);
  } else {
    params[key] = value;
  }
  // Uri.replace(queryParameters: {}) still leaves a bare "?", so fall back
  // to the path alone; replaceState resolves it against the current origin.
  replaceBrowserUrl(
    params.isEmpty
        ? Uri.base.path
        : Uri.base.replace(queryParameters: params).toString(),
  );
}
