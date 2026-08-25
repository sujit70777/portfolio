import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedFadeSlide extends HookConsumerWidget {
  const AnimatedFadeSlide({
    super.key,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 280),
    this.offset = const Offset(0, -64),
    required this.child,
  });

  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final controller = useAnimationController(
      duration: reduceMotion ? Duration.zero : duration,
    );
    final curveAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    final dxAnimation = useAnimation(
      Tween(begin: reduceMotion ? 0.0 : offset.dx, end: 0.0)
          .animate(curveAnimation),
    );
    final dyAnimation = useAnimation(
      Tween(begin: reduceMotion ? 0.0 : offset.dy, end: 0.0)
          .animate(curveAnimation),
    );

    useEffect(() {
      Future.delayed(reduceMotion ? Duration.zero : delay, () {
        if (context.mounted) {
          controller.forward();
        }
      });
      return null;
    }, [controller]);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Opacity(
          opacity: controller.value,
          child: Transform.translate(
            offset: Offset(dxAnimation, dyAnimation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
