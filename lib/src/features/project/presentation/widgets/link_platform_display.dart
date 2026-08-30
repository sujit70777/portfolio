import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/domain/link.dart';

/// Codepoints reused from the whitelist in common/widgets/icon.dart — see
/// that file's comment for why an arbitrary FontAwesome codepoint can't be
/// used without registering it there first (font tree-shaking).
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
      const IconModel(codePoint: '0xef23', fontFamily: 'FontAwesome'),
    LinkPlatform.android =>
      const IconModel(codePoint: '0xefc5', fontFamily: 'FontAwesome'),
    LinkPlatform.github =>
      const IconModel(codePoint: '0xefb7', fontFamily: 'FontAwesome'),
    LinkPlatform.web =>
      const IconModel(codePoint: '0xeb3e', fontFamily: 'FontAwesome'),
    LinkPlatform.pubdev =>
      const IconModel(assetName: 'assets/icons/other/dart.svg'),
    null => null,
  };
}
