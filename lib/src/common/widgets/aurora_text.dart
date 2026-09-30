import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';
import 'package:portfolio/src/constants/palette.dart';

/// Text filled with the aurora gradient.
///
/// With [flowing] on, the colours drift slowly along the text and back —
/// a mirrored gradient sliding one full width per [period], so there's
/// never a seam. At rest (reduced motion, off screen, tests) it shows the
/// plain emerald → mint → gold sweep, which is also exactly what
/// web/index.html paints on `.pl-name` before Flutter boots.
class AuroraText extends StatelessWidget {
  const AuroraText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.flowing = false,
    this.period = const Duration(seconds: 9),
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool flowing;
  final Duration period;

  @override
  Widget build(BuildContext context) {
    final colors = Palette.of(context).aurora;
    final label = Text(text, style: style, textAlign: textAlign);

    Widget masked(double t) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          // A cosine wave, so the sweep eases out and back, lingering at
          // each end, rather than snapping to the start each period.
          final phase = (1 - math.cos(t * math.pi * 2)) / 2;
          return LinearGradient(
            colors: colors,
            tileMode: TileMode.mirror,
            transform: _SlideGradient(
              -phase * bounds.width * 0.9,
            ),
          ).createShader(bounds);
        },
        child: label,
      );
    }

    if (!flowing) return masked(0);
    return AmbientLoop(
      period: period,
      builder: (context, t, _) => masked(t),
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);

  final double dx;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}
