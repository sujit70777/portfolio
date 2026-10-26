import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';
import 'package:portfolio/src/common/widgets/aurora_text.dart';
import 'package:portfolio/src/common/widgets/gradient_button.dart';
import 'package:portfolio/src/common/widgets/icon.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/technology_chip.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/empty_project_placeholder.dart';
import 'package:portfolio/src/features/project/presentation/widgets/link_platform_display.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/common/widgets/lazy_asset_image.dart';

/// The top tier of the projects section — one wide card per flagship
/// product, above the featured grid. Exists because [FeaturedProjectCard]
/// is phone-shaped (9:19.5) and a desktop app's 16:10 screenshot would
/// shrink to a strip inside it; here the screenshot gets a landscape box
/// and the copy gets room for the architecture highlights that make the
/// case to a technical reader.
///
/// One column: header (store and site buttons beside the name on desktop),
/// a justified screenshot strip, the case study, then the stack. Tapping
/// the strip opens the full detail modal (gallery included); the store and
/// site links are real buttons.
class FlagshipProjectCard extends ConsumerStatefulWidget {
  const FlagshipProjectCard({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<FlagshipProjectCard> createState() =>
      _FlagshipProjectCardState();
}

class _FlagshipProjectCardState extends ConsumerState<FlagshipProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final theme = Theme.of(context);
    final projectName = project.name;
    final images = projectName == null
        ? const <String>[]
        : ref.watch(projectImagesProvider(projectName)).maybeWhen(
              data: (value) => value,
              orElse: () => const <String>[],
            );
    final primaryImage =
        project.screenshotPath ?? (images.isNotEmpty ? images.first : null);

    // Lead image first, then the rest. Repha leads with a ~2:1 store
    // banner then phone screenshots, Hourwise with 16:10 Mac windows; only
    // the lead and the first of the rest are measured, since a gallery's
    // screenshots share one shape.
    final gallery = [
      ?primaryImage,
      ...images.where((image) => image != primaryImage),
    ];
    for (final image in gallery.take(2)) {
      _resolveAspectRatio(image);
    }
    final leadAspect =
        _aspectRatios[gallery.firstOrNull] ?? _fallbackAspectRatio;
    final restAspect = gallery.length > 1
        ? _aspectRatios[gallery[1]] ?? _fallbackAspectRatio
        : leadAspect;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final media = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => showProjectDetailModal(context, project: project),
        child: Semantics(
          button: true,
          label: 'Open ${projectName ?? 'project'} details and screenshots',
          child: gallery.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _fallbackAspectRatio,
                    child: ColoredBox(
                      color: theme.colorScheme.secondaryContainer,
                      child: EmptyProjectPlaceholder(
                        project: project,
                        iconSize: 48,
                      ),
                    ),
                  ),
                )
              : _GalleryStrip(
                  images: gallery,
                  aspectRatios: [
                    for (var i = 0; i < gallery.length; i++)
                      i == 0 ? leadAspect : restAspect,
                  ],
                  targetHeight: isDesktop ? 300 : (isMobile ? 180 : 240),
                ),
        ),
      ),
    );

    final highlights = project.highlights ?? const <String>[];
    final technologies = project.technologies ?? const [];
    final links = project.links?.where((l) => l.url != null).toList() ??
        const <Link>[];
    final linkButtons = Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        for (final (index, link) in links.indexed)
          _FlagshipLinkButton(link: link, primary: index == 0),
      ],
    );

    // One column, top to bottom, every block as tall as its own content:
    // side-by-side columns of different lengths always left a gap.
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FlagshipHeader(
          project: project,
          trailing: isDesktop && links.isNotEmpty ? linkButtons : null,
        ),
        gapH20,
        media,
        if (highlights.isNotEmpty) ...[
          gapH20,
          _CaseStudy(highlights: highlights, horizontal: !isMobile),
        ],
        if (technologies.isNotEmpty) ...[
          gapH20,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: technologies
                .map((tech) => TechnologyChip(technology: tech))
                .toList(),
          ),
        ],
        if (!isDesktop && links.isNotEmpty) ...[gapH20, linkButtons],
      ],
    );

    final palette = Palette.of(context);
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 14 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: palette.aurora.first
                .withAlpha(_hovered ? palette.glowAlpha : palette.glowAlpha ~/ 3),
            blurRadius: _hovered ? 48 : 28,
            offset: Offset(-8, _hovered ? 18 : 10),
          ),
          BoxShadow(
            color: palette.aurora[1]
                .withAlpha(_hovered ? palette.glowAlpha : palette.glowAlpha ~/ 3),
            blurRadius: _hovered ? 48 : 28,
            offset: Offset(8, _hovered ? 18 : 10),
          ),
        ],
      ),
      child: body,
    );

    // The flagship is the one card with a living border: the aurora
    // turning slowly round its edge, so the eye lands here first in a
    // section full of cards.
    return AmbientLoop(
      period: const Duration(seconds: 10),
      child: card,
      builder: (context, t, child) => CustomPaint(
        foregroundPainter: _AuroraBorderPainter(
          colors: palette.aurora,
          rotation: t,
          radius: _radius,
          strokeWidth: _hovered ? 2.5 : 1.5,
        ),
        child: child,
      ),
    );
  }

  static const _radius = 20.0;
  static const _fallbackAspectRatio = 16 / 10;

  final Map<String, double> _aspectRatios = {};
  final Set<String> _resolving = {};

  /// Reads [asset]'s width/height once, then drops the full-size decode —
  /// only the shape is needed here; LazyAssetImage paints the real thing.
  void _resolveAspectRatio(String asset) {
    if (!_resolving.add(asset)) return;
    final provider = AssetImage(asset);
    final stream = provider.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        final aspectRatio = info.image.width / info.image.height;
        info.dispose();
        provider.evict();
        if (mounted) setState(() => _aspectRatios[asset] = aspectRatio);
      },
      onError: (_, _) => stream.removeListener(listener),
    );
    stream.addListener(listener);
  }
}

class _AuroraBorderPainter extends CustomPainter {
  const _AuroraBorderPainter({
    required this.colors,
    required this.rotation,
    required this.radius,
    required this.strokeWidth,
  });

  final List<Color> colors;
  final double rotation;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = SweepGradient(
          colors: [...colors, colors.first],
          transform: GradientRotation(rotation * 2 * math.pi),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _AuroraBorderPainter old) =>
      old.rotation != rotation ||
      old.strokeWidth != strokeWidth ||
      old.colors != colors;
}

/// The gallery as one justified row: every image at its own shape, all at
/// one height, chosen so the row fills the width exactly — no letterboxing
/// and no gap at the end. Takes as many images as keeps that height
/// closest to [targetHeight]; the last tile counts the rest.
class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip({
    required this.images,
    required this.aspectRatios,
    required this.targetHeight,
  });

  final List<String> images;
  final List<double> aspectRatios;
  final double targetHeight;

  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      var count = 1;
      var height = width / aspectRatios.first;
      var aspectSum = 0.0;
      for (var n = 1; n <= images.length; n++) {
        aspectSum += aspectRatios[n - 1];
        final fitted = (width - _gap * (n - 1)) / aspectSum;
        if ((fitted - targetHeight).abs() < (height - targetHeight).abs()) {
          count = n;
          height = fitted;
        }
        if (fitted < targetHeight) break;
      }
      final remaining = images.length - count;

      return SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < count; index++) ...[
              if (index > 0) const SizedBox(width: _gap),
              Expanded(
                // Widths in proportion to shape, so each tile is exactly
                // its image's aspect ratio at the shared height.
                flex: (aspectRatios[index] * 1000).round(),
                child: _Tile(
                  image: images[index],
                  moreCount: index == count - 1 ? remaining : 0,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.image, required this.moreCount});

  final String image;
  // Gallery images past the strip, as a pill in the corner so it never
  // covers the screenshot itself.
  final int moreCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: theme.colorScheme.secondaryContainer,
            child: LazyAssetImage(
              image,
              fit: BoxFit.cover,
              // The whole strip is one button into the gallery; the modal
              // carries the real alt text.
              excludeFromSemantics: true,
            ),
          ),
          if (moreCount > 0)
            Positioned(
              right: 8,
              bottom: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(170),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    '+$moreCount',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Label, name, status and description; on desktop the store and site
/// buttons sit at the top right, beside the name.
class _FlagshipHeader extends StatelessWidget {
  const _FlagshipHeader({required this.project, this.trailing});

  final Project project;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuroraText(
          'FLAGSHIP PRODUCT',
          style: monoLabelStyle(fontSize: 11, letterSpacing: 0.08),
        ),
        gapH8,
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SearchableText(
              project.name ?? '',
              style: theme.textTheme.headlineSmall,
            ),
            ProjectStatusBadge(status: project.status),
          ],
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trailing == null)
          title
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: title),
              gapW16,
              trailing!,
            ],
          ),
        gapH12,
        SearchableText(
          project.description ?? '',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// The flagship's highlights as a case study: "Problem: …", "What I did: …",
/// "Result: …" become rows on a tinted panel — label on the left, text on
/// the right (label above text on phones). Rows grow with their own text,
/// so a long entry never leaves a short one beside empty space.
class _CaseStudy extends StatelessWidget {
  const _CaseStudy({required this.highlights, required this.horizontal});

  final List<String> highlights;
  final bool horizontal;

  static final _labelPattern = RegExp(r'^([^:]{1,24}):\s*');
  static const _labelWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aurora = Palette.of(context).aurora;
    final divider = Divider(
      height: 1,
      color: theme.colorScheme.onSurface.withAlpha(20),
    );

    Widget entry(int index, String highlight) {
      final match = _labelPattern.firstMatch(highlight);
      final text = match == null ? highlight : highlight.substring(match.end);
      final label = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              // Stepping through the aurora, entry by entry.
              color: aurora[index % aurora.length],
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          gapW8,
          Flexible(
            child: Text(
              (match?.group(1) ?? '').toUpperCase(),
              style: monoLabelStyle(
                fontSize: 11,
                letterSpacing: 0.08,
                color: theme.colorScheme.onSurface.withAlpha(170),
              ),
            ),
          ),
        ],
      );
      final body = SearchableText(text, style: theme.textTheme.bodySmall);
      if (!horizontal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [label, gapH8, body],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nudged down to sit on the body text's first line.
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(width: _labelWidth, child: label),
          ),
          gapW16,
          Expanded(child: body),
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, highlight) in highlights.indexed) ...[
              if (index > 0) divider,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: entry(index, highlight),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlagshipLinkButton extends StatelessWidget {
  const _FlagshipLinkButton({required this.link, required this.primary});

  final Link link;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = link.label ?? linkPlatformLabel(link.platform);
    final foreground =
        primary ? Palette.of(context).onAurora : theme.colorScheme.onSurface;
    final icon = linkPlatformIcon(link.platform);
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          MyIcon(
            icon: icon.copyWith(
              color: '0x${foreground.toARGB32().toRadixString(16)}',
            ),
            size: 16,
          ),
          gapW8,
        ],
        Text(label),
      ],
    );
    final style = ButtonStyle(
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      textStyle: WidgetStatePropertyAll(theme.textTheme.labelMedium),
      foregroundColor: WidgetStatePropertyAll(foreground),
    );

    if (primary) {
      return GradientButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: theme.textTheme.labelMedium,
        onPressed: () => _open(context),
        child: child,
      );
    }
    return OutlinedButton(
      style: style.copyWith(
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            width: states.contains(WidgetState.hovered) ? 2 : 1,
            color: states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurface.withAlpha(60),
          );
        }),
      ),
      onPressed: () => _open(context),
      child: child,
    );
  }

  Future<void> _open(BuildContext context) async {
    final url = link.url;
    if (url == null) return;
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }
}
