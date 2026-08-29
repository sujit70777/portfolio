import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// Full rotation period for the gradient drift — slow enough that the
/// motion reads as ambient depth, never as something actively "playing".
const _driftPeriod = Duration(seconds: 26);

/// Very subtle depth behind the hero: a slow-drifting low-opacity gradient
/// plus an optional static dot grid. Deliberately not a "hero animation" —
/// no particles, no shapes, nothing that draws the eye away from the
/// content in front of it.
///
/// The drift pauses whenever the hero scrolls out of view and never starts
/// at all under `prefers-reduced-motion`, so this never costs a frame when
/// nobody can see it and never runs when the visitor has asked for less
/// motion.
class HeroBackground extends ConsumerStatefulWidget {
  const HeroBackground({super.key});

  @override
  ConsumerState<HeroBackground> createState() => _HeroBackgroundState();
}

class _HeroBackgroundState extends ConsumerState<HeroBackground>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: _driftPeriod);
  ScrollController? _scrollController;
  bool _reduceMotion = false;

  // An infinitely-repeating ticker never "settles", so it must never start
  // under widget-test's TestWidgetsFlutterBinding — `pumpAndSettle()` would
  // spin forever waiting for a frame that's never the last one. Runtime
  // type name check avoids pulling the flutter_test package into app code.
  static bool get _isTestBinding => WidgetsBinding.instance.runtimeType
      .toString()
      .contains('TestWidgetsFlutterBinding');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context) || _isTestBinding;
    if (_reduceMotion) {
      _controller.stop();
    } else {
      final controller = ref.read(scrollControllerProvider);
      if (!identical(controller, _scrollController)) {
        _scrollController?.removeListener(_checkVisibility);
        _scrollController = controller..addListener(_checkVisibility);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_reduceMotion || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final visible = bottom >= 0 && top <= screenHeight;
    if (visible && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!visible && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.tertiary;
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            CustomPaint(
                size: Size.infinite,
                painter: _DotGridPainter(color: theme.colorScheme.onSurface)),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final angle = _controller.value * 2 * math.pi;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(math.cos(angle), math.sin(angle)),
                      end: Alignment(-math.cos(angle), -math.sin(angle)),
                      colors: [
                        accent.withAlpha(14),
                        Colors.transparent,
                        accent.withAlpha(8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.color});

  final Color color;
  static const _spacing = 28.0;
  static const _radius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withAlpha(12);
    for (double y = 0; y < size.height; y += _spacing) {
      for (double x = 0; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
