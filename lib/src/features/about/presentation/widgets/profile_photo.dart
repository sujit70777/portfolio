import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';
import 'package:portfolio/src/constants/palette.dart';

const _webpPath = 'assets/images/profile.webp';
const _jpgPath = 'assets/images/profile.jpg';
const _photoAlt = 'Shekh Ehsanur Rahman, Senior Mobile & Full-Stack AI Engineer';

/// Circular profile photo — WebP first (CanvasKit decodes it natively, no
/// browser fallback needed), falling back to a JPEG if the WebP is ever
/// missing. Framed by an aurora ring that turns slowly, with a matching
/// soft glow. web/index.html paints the same ring, unrotated, as a CSS
/// conic-gradient on `.pl-avatar`.
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cachePx = (size * dpr).round();

    final photo = ClipOval(
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
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: palette.aurora.first.withAlpha(palette.glowAlpha),
            blurRadius: 24,
            offset: const Offset(-4, 0),
          ),
          BoxShadow(
            color: palette.aurora[1].withAlpha(palette.glowAlpha ~/ 2),
            blurRadius: 24,
            offset: const Offset(4, 2),
          ),
        ],
      ),
      child: AmbientLoop(
        period: const Duration(seconds: 8),
        child: Padding(padding: const EdgeInsets.all(5), child: photo),
        builder: (context, t, child) => CustomPaint(
          painter: _RingPainter(colors: palette.aurora, rotation: t),
          child: child,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.colors, required this.rotation});

  final List<Color> colors;

  /// 0→1, one full turn.
  final double rotation;

  static const _stroke = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(_stroke / 2);
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..shader = SweepGradient(
          // Closed loop: last stop repeats the first so there's no seam.
          colors: [...colors, colors.first],
          transform: GradientRotation(rotation * 2 * math.pi),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.rotation != rotation || old.colors != colors;
}
