import 'package:flutter/material.dart';

const _webpPath = 'assets/images/profile.webp';
const _jpgPath = 'assets/images/profile.jpg';
const _photoAlt = 'Shekh Ehsanur Rahman, Senior Flutter Engineer';

/// Circular profile photo beside the About text — WebP first (CanvasKit
/// decodes it natively, no browser fallback needed), falling back to a
/// JPEG if the WebP is ever missing. A thin accent ring, not a glow: the
/// site's one accent used sparingly, same restraint as everywhere else.
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cachePx = (size * dpr).round();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.tertiary.withAlpha(160), width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withAlpha(40),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          _webpPath,
          fit: BoxFit.cover,
          cacheWidth: cachePx,
          cacheHeight: cachePx,
          semanticLabel: _photoAlt,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              _jpgPath,
              fit: BoxFit.cover,
              cacheWidth: cachePx,
              cacheHeight: cachePx,
              semanticLabel: _photoAlt,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(color: theme.colorScheme.secondaryContainer);
              },
            );
          },
        ),
      ),
    );
  }
}
