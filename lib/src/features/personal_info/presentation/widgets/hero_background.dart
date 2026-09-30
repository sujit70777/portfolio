import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';
import 'package:portfolio/src/constants/palette.dart';

/// One full drift cycle — slow enough that the motion reads as light
/// moving, never as something "playing".
const _driftPeriod = Duration(seconds: 24);

/// How far the glow spills past the hero's own box. The hero sits inside
/// the page's content column; without this the light would stop in a hard
/// vertical line at the column edge.
const heroBackgroundBleed = EdgeInsets.fromLTRB(140, 110, 140, 60);

/// The hero's backdrop, after the OG card (web/og-preview.jpg): a faint
/// line grid, soft glows drifting on slow out-of-phase orbits (emerald on
/// the left, gold on the right where the card's ring glows, mint low in
/// the middle), and a scatter of gold dust that twinkles.
///
/// Plain radial gradients and dots — no blur filter — so it costs one
/// cheap layer per frame and nothing at all once scrolled past (see
/// [AmbientLoop]). It isn't part of web/index.html's pre-Flutter hero: the
/// glows fade in when Flutter takes over, so the page visibly "lights up"
/// as it becomes interactive instead of trying to match a static copy.
class HeroBackground extends StatelessWidget {
  const HeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return Positioned(
      left: -heroBackgroundBleed.left,
      top: -heroBackgroundBleed.top,
      right: -heroBackgroundBleed.right,
      bottom: -heroBackgroundBleed.bottom,
      child: IgnorePointer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _GridPainter(color: theme.colorScheme.onSurface),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: ambientMotionAllowed(context) ? 0 : 1,
                end: 1,
              ),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOut,
              builder: (context, fadeIn, child) =>
                  Opacity(opacity: fadeIn, child: child),
              child: RepaintBoundary(
                child: AmbientLoop(
                  period: _driftPeriod,
                  builder: (context, t, _) => CustomPaint(
                    painter: _GlowPainter(
                      t: t,
                      glows: [palette.aurora[0], palette.aurora[2], palette.aurora[1]],
                      dust: palette.aurora[2],
                      alpha: palette.glowAlpha,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The hero's own box inside the painter's (the painter's minus the
/// bleed). Height is capped: on a phone the hero is ~3 screens tall, and
/// the light belongs behind the name and CTAs, not smeared down the column.
Rect _heroBox(Size size) {
  final box = heroBackgroundBleed.deflateRect(Offset.zero & size);
  return Rect.fromLTWH(box.left, box.top, box.width, math.min(box.height, 720));
}

class _GlowPainter extends CustomPainter {
  _GlowPainter({
    required this.t,
    required this.glows,
    required this.dust,
    required this.alpha,
  });

  final double t;

  /// Left, right, low-middle.
  final List<Color> glows;
  final Color dust;
  final int alpha;

  /// Fixed positions (fractions of the hero box), sizes and twinkle phases —
  /// seeded, so the dust is the same scatter on every visit.
  static final _motes = () {
    final random = math.Random(11);
    return List.generate(22, (_) {
      return (
        Offset(random.nextDouble(), random.nextDouble()),
        0.8 + random.nextDouble() * 1.4,
        random.nextDouble(),
        1 + random.nextInt(2),
      );
    });
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final box = _heroBox(size);
    final radius = (box.width * 0.42).clamp(220.0, 520.0);
    final a = t * 2 * math.pi;

    final blobs = <(Offset, Color, double)>[
      (Offset(0.12 + 0.06 * math.sin(a), 0.22 + 0.08 * math.cos(a)),
          glows[0], 0.9),
      (Offset(0.8 + 0.06 * math.cos(a + 2.1), 0.2 + 0.08 * math.sin(a + 2.1)),
          glows[1], 1.0),
      (Offset(0.5 + 0.1 * math.sin(a * 2 + 4.2), 0.72 + 0.06 * math.cos(a + 4.2)),
          glows[2], 0.5),
    ];
    for (final (position, color, weight) in blobs) {
      final center = Offset(
        box.left + position.dx * box.width,
        box.top + position.dy * box.height,
      );
      final r = radius * (0.85 + 0.15 * weight);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withAlpha((alpha * weight).round()),
              color.withAlpha((alpha * weight * 0.35).round()),
              color.withAlpha(0),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    // Gold dust: each mote brightens and fades on its own phase, a whole
    // number of times per loop so the cycle closes without a jump. Scaled
    // down hard on the light theme, where bright specks read as dirt.
    final dustScale = math.pow(alpha / 70, 2).toDouble();
    for (final (position, moteRadius, phase, speed) in _motes) {
      final twinkle =
          (0.5 + 0.5 * math.sin((t * speed + phase) * 2 * math.pi)) *
              dustScale;
      canvas.drawCircle(
        Offset(
          box.left + position.dx * box.width,
          box.top + position.dy * box.height,
        ),
        moteRadius,
        Paint()
          ..color = dust.withAlpha((40 * dustScale + 150 * twinkle).round()),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlowPainter old) =>
      old.t != t || old.alpha != alpha || old.glows != glows || old.dust != dust;
}

/// The OG card's faint square grid, behind the hero only — the bleed is
/// for light, not texture.
class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;
  static const _spacing = 64.0;

  @override
  void paint(Canvas canvas, Size size) {
    final area = heroBackgroundBleed.deflateRect(Offset.zero & size);
    // Fades out downwards, so the texture never stops in a hard line where
    // the hero ends.
    final paint = Paint()
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withAlpha(14), color.withAlpha(0)],
      ).createShader(area);
    for (double x = area.left; x <= area.right; x += _spacing) {
      canvas.drawLine(Offset(x, area.top), Offset(x, area.bottom), paint);
    }
    for (double y = area.top; y <= area.bottom; y += _spacing) {
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}
