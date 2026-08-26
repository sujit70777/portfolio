import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/transparent_image.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image_lightbox.dart';
import 'package:portfolio/src/common/widgets/icon.dart';

class ProjectImage extends ConsumerWidget {
  const ProjectImage({
    super.key,
    required this.project,
    required this.isHovered,
  });

  final Project project;
  final bool isHovered;

  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              maxHeight: 190,
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
                    child: _buildScreenshotImage(images),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox.square(
              dimension: _iconSize,
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
                  size: _iconSize,
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

  Widget _buildScreenshotImage(List<String> images) {
    final screenshotPath =
        project.screenshotPath ?? (images.isNotEmpty ? images.first : null);
    if (screenshotPath == null) return const Icon(Icons.code);
    return FadeInImage(
      placeholder: MemoryImage(transparentImage),
      image: AssetImage(screenshotPath),
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
