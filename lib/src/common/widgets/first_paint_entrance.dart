import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';

/// Whether the things that are on screen at first frame should animate in.
///
/// False on web, and that is the whole point. web/index.html paints a static
/// copy of the app bar and hero in plain HTML long before Flutter has
/// finished downloading, and Flutter's first frame replaces it. If those
/// elements then faded and slid in from nothing, the handover would read as
/// the page blinking: content the visitor had been looking at for a second or
/// more would vanish and re-enter. On web they arrive already settled, so the
/// swap is invisible.
///
/// The entrance is kept for the native builds, where nothing precedes the
/// first frame and the animation is the visitor's introduction to the page.
const bool kAnimateFirstPaintEntrance = !kIsWeb;

/// An [AnimatedFadeSlide] for content that is already on screen before
/// Flutter starts — the app bar and the hero.
///
/// Anything the pre-Flutter markup does *not* draw should keep using
/// [AnimatedFadeSlide] directly: the end drawer, for instance, is opened long
/// after the handover, so its entrance is never in competition with the HTML
/// hero and should still play on every platform.
///
/// This is unrelated to reduced-motion, which [AnimatedFadeSlide] handles
/// separately and for a different reason.
class FirstPaintEntrance extends StatelessWidget {
  const FirstPaintEntrance({
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 280),
    this.offset = const Offset(0, -64),
    required this.child,
  });

  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kAnimateFirstPaintEntrance) return child;
    return AnimatedFadeSlide(
      delay: delay,
      duration: duration,
      offset: offset,
      child: child,
    );
  }
}
