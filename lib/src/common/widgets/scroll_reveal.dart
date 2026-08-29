import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// How far below the fold (in logical pixels) an element still counts as
/// "entering" — small on purpose so reveal happens just before an element
/// is actually on screen rather than the moment it's technically visible.
const _revealBuffer = 60.0;
const _riseDistance = 20.0;

/// Fades a child in and rises it ~20px as it scrolls into view, once. Reuses
/// the same scroll-position visibility check as ProjectImage's near-viewport
/// gating rather than a new dependency. Respects `prefers-reduced-motion`
/// (via [MediaQuery.disableAnimationsOf]) by showing the final state
/// immediately with no animation, and never re-triggers on scrolling back up
/// — this is a one-time entrance, not a repeating scroll effect.
class ScrollReveal extends ConsumerStatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  ConsumerState<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends ConsumerState<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  ScrollController? _scrollController;
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_revealed && MediaQuery.disableAnimationsOf(context)) {
      _revealed = true;
      _controller.value = 1;
    }
    final controller = ref.read(scrollControllerProvider);
    if (!identical(controller, _scrollController)) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller..addListener(_checkVisibility);
    }
    // Runs after this frame's layout, so elements already on screen on
    // first paint (nothing scrolled yet) still get revealed.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_revealed || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (top <= screenHeight - _revealBuffer) {
      _revealed = true;
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        return Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _curve.value) * _riseDistance),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
