import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// How far outside the viewport (in logical pixels) an image starts loading,
/// so it's usually decoded by the time it scrolls into view.
const _preloadMargin = 800.0;

/// An [Image.asset] that doesn't load until it's near the viewport, and
/// decodes at the size it's laid out at rather than the file's full
/// resolution.
///
/// The page builds every section up front, so a plain Image.asset in a
/// project card downloads and decodes its screenshot on first load even when
/// it's far below the fold. Some of those are 1400x3000 phone captures, and
/// together they added ~900KB to the initial page. Uses the same
/// scroll-position visibility check as ScrollReveal and AmbientLoop. Once
/// loaded it stays loaded.
class LazyAssetImage extends ConsumerStatefulWidget {
  const LazyAssetImage(
    this.asset, {
    super.key,
    this.fit = BoxFit.cover,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  final String asset;
  final BoxFit fit;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  @override
  ConsumerState<LazyAssetImage> createState() => _LazyAssetImageState();
}

class _LazyAssetImageState extends ConsumerState<LazyAssetImage> {
  bool _nearViewport = false;
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nearViewport) return;
    final controller = ref.read(scrollControllerProvider);
    if (!identical(controller, _scrollController)) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller..addListener(_checkVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (_nearViewport || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (bottom >= -_preloadMargin && top <= screenHeight + _preloadMargin) {
      _scrollController?.removeListener(_checkVisibility);
      setState(() => _nearViewport = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_nearViewport) return const SizedBox.expand();
    return LayoutBuilder(builder: (context, constraints) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      // Only width is pinned, so the decoder keeps the aspect ratio. Sharp
      // for every box at or near the screenshot's own proportions, which is
      // how the cards size them.
      final cacheWidth = constraints.hasBoundedWidth
          ? (constraints.maxWidth * dpr).round()
          : null;
      return Image.asset(
        widget.asset,
        fit: widget.fit,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth,
        semanticLabel: widget.semanticLabel,
        excludeFromSemantics: widget.excludeFromSemantics,
      );
    });
  }
}
