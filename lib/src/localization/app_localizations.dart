import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class AppLocalizations {
  static const translationsPath = "assets/translations";

  static Future<List<Locale>> supportedLocales() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> assets = assetManifest.listAssets().where((String key) {
      return key.startsWith(translationsPath);
    }).toList();
    List<Locale> fileNames = assets.map((String asset) {
      final filenameLanguageCode = path.basenameWithoutExtension(asset);
      return Locale(filenameLanguageCode);
    }).toList();
    return fileNames;
  }
}
