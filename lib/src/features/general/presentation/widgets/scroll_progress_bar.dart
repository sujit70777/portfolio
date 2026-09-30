import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// A thin aurora line across the very top of the window that fills as the
/// visitor reads down the page — a quiet "how much is left" for someone
/// skimming between interviews.
///
/// Overlaid rather than laid out, so it never shifts the app bar (or the
/// pre-Flutter copy of it in web/index.html) by a pixel. Repaints only its
/// own layer on scroll; nothing else rebuilds.
class ScrollProgressBar extends ConsumerWidget {
  const ScrollProgressBar({super.key});

  static const _height = 3.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(scrollControllerProvider);
    final palette = Palette.of(context);
    return IgnorePointer(
      child: SizedBox(
        height: _height,
        width: double.infinity,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _ProgressPainter(
              controller: controller,
              gradient: palette.auroraGradient,
              glow: palette.aurora[1].withAlpha(palette.glowAlpha * 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter({
    required this.controller,
    required this.gradient,
    required this.glow,
  }) : super(repaint: controller);

  final ScrollController controller;
  final Gradient gradient;
  final Color glow;

  double get _progress {
    if (!controller.hasClients) return 0;
    final position = controller.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return 0;
    }
    return (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width * _progress;
    if (width <= 0) return;
    // The gradient spans the full window, so the bar reveals the aurora
    // rather than squashing it into the filled part.
    final full = Offset.zero & size;
    final bar = Rect.fromLTWH(0, 0, width, size.height);
    canvas.drawRect(bar, Paint()..shader = gradient.createShader(full));
    canvas.drawCircle(
      Offset(width, size.height / 2),
      size.height * 1.6,
      Paint()
        ..color = glow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter old) =>
      old.controller != controller ||
      old.gradient != gradient ||
      old.glow != glow;
}
