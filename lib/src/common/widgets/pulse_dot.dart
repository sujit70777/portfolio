import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';

/// A small status dot with a ring that ripples out and fades, like a live
/// indicator — "available now", "current role". Still (dot plus soft halo)
/// under reduced motion.
class PulseDot extends StatelessWidget {
  const PulseDot({super.key, required this.color, this.size = 8});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final extent = size * 3;
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withAlpha(90), blurRadius: 6, spreadRadius: 1),
        ],
      ),
    );
    // Laid out at [size] so it lines up with text exactly as a plain dot
    // would; the ripple paints outside that box without taking up space.
    return SizedBox(
      width: size,
      height: size,
      child: OverflowBox(
        maxWidth: extent,
        maxHeight: extent,
        child: SizedBox(
          width: extent,
          height: extent,
          child: AmbientLoop(
            period: const Duration(milliseconds: 1800),
            child: dot,
            builder: (context, t, child) {
              final eased = Curves.easeOutCubic.transform(t);
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (t > 0)
                    Container(
                      width: size + (extent - size) * eased,
                      height: size + (extent - size) * eased,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withAlpha((180 * (1 - eased)).round()),
                          width: 1.5,
                        ),
                      ),
                    ),
                  child!,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
