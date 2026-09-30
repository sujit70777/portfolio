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
import 'package:portfolio/src/features/project/presentation/widgets/project_highlights.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// The top tier of the projects section — one wide card per flagship
/// product, above the featured grid. Exists because [FeaturedProjectCard]
/// is phone-shaped (9:19.5) and a desktop app's 16:10 screenshot would
/// shrink to a strip inside it; here the screenshot gets a landscape box
/// and the copy gets room for the architecture highlights that make the
/// case to a technical reader.
///
/// Screenshot left / copy right on desktop, stacked below that. Tapping the
/// screenshot opens the full detail modal (gallery included); the store and
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

  static const _screenshotAspectRatio = 16 / 10;

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

    final screenshot = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => showProjectDetailModal(context, project: project),
        child: Semantics(
          button: true,
          label: 'Open ${projectName ?? 'project'} details and screenshots',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _screenshotAspectRatio,
              child: ColoredBox(
                color: theme.colorScheme.secondaryContainer,
                child: primaryImage == null
                    ? EmptyProjectPlaceholder(project: project, iconSize: 48)
                    : AnimatedScale(
                        scale: _hovered ? 1.02 : 1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        child: Image.asset(primaryImage, fit: BoxFit.cover),
                      ),
              ),
            ),
          ),
        ),
      ),
    );

    // The rest of the gallery as a thumbnail strip under the main shot, so
    // the card shows the product's breadth at a glance — and so the image
    // column isn't left short beside the taller copy column on desktop.
    final thumbnails = images.length > 1
        ? Row(
            children: [
              for (final (index, image) in images.skip(1).take(4).indexed) ...[
                if (index > 0) gapW8,
                Expanded(
                  child: _Thumbnail(
                    image: image,
                    onTap: () =>
                        showProjectDetailModal(context, project: project),
                  ),
                ),
              ],
            ],
          )
        : null;
    final media = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        screenshot,
        if (thumbnails != null) ...[gapH8, thumbnails],
      ],
    );

    final details = _FlagshipDetails(project: project);

    final Widget body;
    if (Responsive.isDesktop(context)) {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 11, child: media),
          gapW32,
          Expanded(flex: 9, child: details),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [media, gapH20, details],
      );
    }

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

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.image, required this.onTap});

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              // Thumbnails render ~130px wide; no need to decode 1280px.
              cacheWidth: 320,
              // Purely a shortcut into the gallery; the modal carries the
              // real alt text.
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _FlagshipDetails extends StatelessWidget {
  const _FlagshipDetails({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final links = project.links?.where((l) => l.url != null).toList() ??
        const <Link>[];
    final highlights = project.highlights ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuroraText(
          'FLAGSHIP PRODUCT',
          style: monoLabelStyle(fontSize: 11, letterSpacing: 0.08),
        ),
        gapH8,
        Text(project.name ?? '', style: theme.textTheme.headlineSmall),
        gapH4,
        ProjectStatusBadge(status: project.status),
        gapH12,
        Text(project.description ?? '', style: theme.textTheme.bodyMedium),
        if (highlights.isNotEmpty) ...[
          gapH16,
          ProjectHighlights(highlights: highlights),
        ],
        if (project.technologies?.isNotEmpty == true) ...[
          gapH16,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.technologies!
                .map((tech) => TechnologyChip(technology: tech))
                .toList(),
          ),
        ],
        if (links.isNotEmpty) ...[
          gapH20,
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              for (final (index, link) in links.indexed)
                _FlagshipLinkButton(link: link, primary: index == 0),
            ],
          ),
        ],
      ],
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
