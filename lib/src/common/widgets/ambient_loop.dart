import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// An infinitely-repeating ticker never "settles", so it must never start
/// under widget-test's TestWidgetsFlutterBinding — `pumpAndSettle()` would
/// spin forever waiting for a frame that's never the last one. Runtime
/// type name check avoids pulling the flutter_test package into app code.
bool get _isTestBinding => WidgetsBinding.instance.runtimeType
    .toString()
    .contains('TestWidgetsFlutterBinding');

/// Whether looping, decorative motion should run at all: not when the
/// visitor has asked for less motion, and not under widget tests.
bool ambientMotionAllowed(BuildContext context) =>
    !MediaQuery.disableAnimationsOf(context) && !_isTestBinding;

/// Flips to true on the visitor's first pointer (mouse move, touch, wheel)
/// or key event, and stays true. Ambient loops hold their still frame until
/// then. Every hero loop running from first paint meant a repaint every
/// frame forever: on a mid-range phone each one is a 100ms+ main-thread
/// task, so the page never went idle and Lighthouse scored ~20s of Total
/// Blocking Time. A desktop visitor moves the mouse within moments; on
/// phones the first touch or scroll starts the motion.
final _firstInteraction = ValueNotifier<bool>(false);
var _watchingForInteraction = false;

void _watchForFirstInteraction() {
  if (_watchingForInteraction || _firstInteraction.value) return;
  _watchingForInteraction = true;
  GestureBinding.instance.pointerRouter.addGlobalRoute(_onFirstPointer);
  HardwareKeyboard.instance.addHandler(_onFirstKey);
}

void _onFirstPointer(PointerEvent event) => _markInteracted();

bool _onFirstKey(KeyEvent event) {
  _markInteracted();
  return false;
}

void _markInteracted() {
  if (_firstInteraction.value) return;
  _firstInteraction.value = true;
  // Deferred so the handlers aren't removed from inside their own dispatch.
  scheduleMicrotask(() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onFirstPointer);
    HardwareKeyboard.instance.removeHandler(_onFirstKey);
  });
}

/// Drives a slow, endlessly repeating decorative animation — the hero's
/// aurora, the flowing name gradient, the photo ring, the flagship card's
/// border — and hands [builder] the loop's phase `t` in `[0, 1)`.
///
/// The loop only runs while this widget is on screen (checked against the
/// page's scroll controller, the same way ScrollReveal is), so a dozen of
/// these cost nothing once scrolled past. It also waits for the visitor's
/// first interaction before starting at all (see [_firstInteraction]). Under `prefers-reduced-motion` and
/// in tests it never starts, and [builder] gets `t = 0`: a still frame of
/// the same design, not a missing one.
class AmbientLoop extends ConsumerStatefulWidget {
  const AmbientLoop({
    super.key,
    required this.period,
    required this.builder,
    this.child,
  });

  final Duration period;
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  /// Passed through to [builder] untouched, for subtrees that don't depend
  /// on `t` and shouldn't rebuild every frame.
  final Widget? child;

  @override
  ConsumerState<AmbientLoop> createState() => _AmbientLoopState();
}

class _AmbientLoopState extends ConsumerState<AmbientLoop>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: widget.period);
  ScrollController? _scrollController;
  bool _allowed = false;
  bool _listeningForInteraction = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allowed = ambientMotionAllowed(context);
    if (!_allowed) {
      _controller.stop();
      return;
    }
    if (!_listeningForInteraction) {
      _listeningForInteraction = true;
      _watchForFirstInteraction();
      _firstInteraction.addListener(_checkVisibility);
    }
    final controller = ref.read(scrollControllerProvider);
    if (!identical(controller, _scrollController)) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller..addListener(_checkVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _firstInteraction.removeListener(_checkVisibility);
    _scrollController?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (!_allowed || !mounted || !_firstInteraction.value) return;
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          widget.builder(context, _controller.value, child),
      child: widget.child,
    );
  }
}
