import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/icon.dart';

/// Every FontAwesome codepoint referenced anywhere in
/// assets/translations/en.json, as compile-time-constant [IconData]
/// literals. Flutter's font tree-shaker (`flutter build --tree-shake-icons`,
/// the default) only keeps glyphs it can prove are used by finding a literal
/// `const IconData(...)` expression in the compiled source — a codepoint
/// assembled from a runtime string (as icon.codePoint is, coming from JSON)
/// is invisible to it, which is why this app used to need
/// `--no-tree-shake-icons` and shipped the full ~580KB FontAwesome.ttf.
///
/// Add an entry here whenever a new FontAwesome codepoint is added to
/// en.json. A codepoint missing from this map renders [MyIcon.placeholder]
/// instead of the glyph — loud and visible in dev — rather than silently
/// vanishing only in release builds once its glyph gets tree-shaken away.
const _faIconsByCodePoint = <String, IconData>{
  '0xea6f': IconData(0xea6f, fontFamily: 'FontAwesome'), // cube — project icon
  '0xeaad': IconData(0xeaad, fontFamily: 'FontAwesome'), // envelope
  '0xeb3e': IconData(0xeb3e, fontFamily: 'FontAwesome'), // globe — website
  '0xee48': IconData(0xee48, fontFamily: 'FontAwesome'), // vr-cardboard
  '0xef1c': IconData(0xef1c, fontFamily: 'FontAwesome'), // android
  '0xef21': IconData(0xef21, fontFamily: 'FontAwesome'), // apple
  '0xef22': IconData(0xef22, fontFamily: 'FontAwesome'), // apple pay
  '0xef23': IconData(0xef23, fontFamily: 'FontAwesome'), // app-store-ios
  '0xefb7': IconData(0xefb7, fontFamily: 'FontAwesome'), // github
  '0xefc5': IconData(0xefc5, fontFamily: 'FontAwesome'), // google play
  '0xefe7': IconData(0xefe7, fontFamily: 'FontAwesome'), // java (coffee cup)
  '0xeffb': IconData(0xeffb, fontFamily: 'FontAwesome'), // linkedin
  '0xed85': IconData(0xed85, fontFamily: 'FontAwesome'), // star (solid) — rating
  '0xf0aa': IconData(0xf0aa, fontFamily: 'FontAwesome'), // swift
  '0xf0d9': IconData(0xf0d9, fontFamily: 'FontAwesome'), // whatsapp
};

class MyIcon extends ConsumerWidget {
  const MyIcon({
    super.key,
    this.icon,
    this.placeholder = const SizedBox.shrink(),
    this.size = 24,
    this.padding,
  });

  final IconModel? icon;
  final double? size;
  final Widget placeholder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconAssetName = icon?.assetName;
    final iconCodePoint = icon?.codePoint;
    final iconFontFamily = icon?.fontFamily;
    final iconColor = icon?.color;
    Color? color;
    if (iconColor != null) {
      final colorHex = int.tryParse(iconColor);
      if (colorHex != null) {
        color = Color(colorHex);
      }
    }
    if (iconCodePoint != null && iconFontFamily == 'FontAwesome') {
      final iconData = _faIconsByCodePoint[iconCodePoint];
      if (iconData != null) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: FittedBox(
            child: Icon(
              iconData,
              color: color,
              size: size,
            ),
          ),
        );
      }
      assert(() {
        debugPrint(
          'MyIcon: codePoint "$iconCodePoint" has no entry in '
          '_faIconsByCodePoint (icon.dart) — add one so it renders and '
          'survives font tree-shaking.',
        );
        return true;
      }());
    } else if (iconAssetName != null) {
      return SvgPicture.asset(
        iconAssetName,
        width: size,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return placeholder;
  }
}
