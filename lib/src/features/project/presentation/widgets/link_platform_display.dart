import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/domain/link.dart';

String linkPlatformLabel(LinkPlatform? platform) {
  return switch (platform) {
    LinkPlatform.ios => 'App Store',
    LinkPlatform.android => 'Google Play',
    LinkPlatform.pubdev => 'View on pub.dev',
    LinkPlatform.github => 'View on GitHub',
    LinkPlatform.web => 'Visit site',
    null => 'Visit project',
  };
}

IconModel? linkPlatformIcon(LinkPlatform? platform) {
  return switch (platform) {
    LinkPlatform.ios =>
      const IconModel(assetName: 'assets/icons/other/app-store.svg'),
    LinkPlatform.android =>
      const IconModel(assetName: 'assets/icons/other/google-play.svg'),
    LinkPlatform.github =>
      const IconModel(assetName: 'assets/icons/other/github.svg'),
    LinkPlatform.web =>
      const IconModel(assetName: 'assets/icons/other/globe.svg'),
    LinkPlatform.pubdev =>
      const IconModel(assetName: 'assets/icons/other/dart.svg'),
    null => null,
  };
}
