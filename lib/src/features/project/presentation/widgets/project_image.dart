import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/transparent_image.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image_lightbox.dart';
import 'package:portfolio/src/common/widgets/icon.dart';

/// How far outside the visible screen (in logical pixels) a card is still
/// considered "near" enough to start decoding its screenshot. Large enough
/// that images are ready before they're scrolled into view, small enough
/// that most of the 24-card grid stays undecoded until the visitor scrolls.
const _revealBuffer = 600.0;

/// Container height range project_image.dart renders screenshots at — see
/// the BoxConstraints below. Used to size cacheHeight/the placeholder so
/// neither over-decodes nor shifts layout when the real image arrives.
const _maxImageHeight = 190.0;

class ProjectImage extends ConsumerStatefulWidget {
  const ProjectImage({
    super.key,
    required this.project,
    required this.isHovered,
  });

  final Project project;
  final bool isHovered;

  static const double _iconSize = 36;

  @override
  ConsumerState<ProjectImage> createState() => _ProjectImageState();
}

class _ProjectImageState extends ConsumerState<ProjectImage> {
  bool _isNearViewport = false;
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ref.read(scrollControllerProvider);
    if (!identical(controller, _scrollController)) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller..addListener(_checkVisibility);
    }
    // Runs after this frame's layout, so cards already on screen on first
    // paint (nothing scrolled yet, so no ScrollController notification
    // fires) still get revealed instead of staying placeholders forever.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    super.dispose();
  }

  /// Approximates "is this card in or near the viewport" from its on-screen
  /// position rather than the scroll offset arithmetic a real viewport
  /// intersection check would need — the desktop layout scrolls a
  /// SingleChildScrollView nested beside a fixed hero column, while
  /// tablet/mobile scroll the whole page via CustomScrollView slivers, and
  /// localToGlobal already accounts for whichever one is active without
  /// this needing to know which it is.
  void _checkVisibility() {
    if (_isNearViewport || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (bottom >= -_revealBuffer && top <= screenHeight + _revealBuffer) {
      setState(() => _isNearViewport = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isHovered = widget.isHovered;
    // An explicit screenshotPath is a manual single-image override — the
    // folder-based gallery only kicks in when nothing is pinned that way.
    final images = project.screenshotPath != null
        ? const <String>[]
        : ref.watch(projectImagesProvider(project.name ?? '')).maybeWhen(
              data: (value) => value,
              orElse: () => const <String>[],
            );
    final galleryEnabled = images.isNotEmpty;

    return GestureDetector(
      onTap: galleryEnabled
          ? () => showProjectImageLightbox(
                context,
                projectName: project.name ?? '',
                images: images,
                initialIndex: 0,
              )
          : null,
      behavior:
          galleryEnabled ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 160,
              maxHeight: _maxImageHeight,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 4,
                color: Theme.of(context).colorScheme.tertiary.withAlpha(100),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  return AnimatedContainer(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        tileMode: TileMode.decal,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isHovered ? Colors.black12 : Colors.transparent,
                          isHovered ? Colors.black26 : Colors.transparent,
                          isHovered ? Colors.black54 : Colors.transparent,
                        ],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    curve: Curves.decelerate,
                    transform: isHovered
                        ? (Matrix4.identity()
                          ..translateByDouble(0.5 * width, 0.5 * width, 0, 1)
                          ..scaleByDouble(1.2, 1.2, 1.2, 1)
                          ..translateByDouble(
                              0.5 * -width, 0.5 * -width, 0, 1))
                        : Matrix4.identity(),
                    child: _isNearViewport
                        ? _buildScreenshotImage(context, images, width)
                        : const ColoredBox(color: Colors.transparent),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox.square(
              dimension: ProjectImage._iconSize,
              child: AnimatedCrossFade(
                alignment: Alignment.center,
                firstCurve: Curves.decelerate,
                secondCurve: Curves.decelerate,
                sizeCurve: Curves.decelerate,
                crossFadeState: isHovered
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(milliseconds: 500),
                firstChild: const SizedBox.shrink(),
                secondChild: MyIcon(
                  icon: project.icon,
                  size: ProjectImage._iconSize,
                ),
              ),
            ),
          ),
          if (images.length > 1)
            Positioned(
              top: 12,
              left: 12,
              child: _MoreImagesBadge(count: images.length - 1),
            ),
        ],
      ),
    );
  }

  Widget _buildScreenshotImage(
    BuildContext context,
    List<String> images,
    double width,
  ) {
    final screenshotPath =
        widget.project.screenshotPath ??
            (images.isNotEmpty ? images.first : null);
    if (screenshotPath == null) return const Icon(Icons.code);
    // Sized to the card's actual rendered box (LayoutBuilder's width, and
    // the fixed max container height) in physical pixels, so the decoder
    // doesn't allocate a full-resolution bitmap for a screenshot that only
    // ever renders at a few hundred logical pixels.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (width * dpr).round();
    final cacheHeight = (_maxImageHeight * dpr).round();
    return FadeInImage(
      placeholder: MemoryImage(transparentImage),
      image: ResizeImage(
        AssetImage(screenshotPath),
        width: cacheWidth,
        height: cacheHeight,
      ),
      imageErrorBuilder: (_, __, ___) => const Placeholder(),
      fit: BoxFit.cover,
      placeholderFit: BoxFit.cover,
    );
  }
}

class _MoreImagesBadge extends StatelessWidget {
  const _MoreImagesBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.tertiary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(130),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withAlpha(180)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.photo_library_outlined,
                size: 13,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                '+$count more',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
