import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/technology_chip.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/empty_project_placeholder.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Screenshot-forward card for the curated "featured" project tier — the
/// projects section is meant to read as the page's centrepiece, so the
/// screenshot fills nearly the whole card with minimal chrome around it,
/// rather than sitting inside a phone bezel (that treatment stays unique
/// to the hero).
///
/// Tapping the card body opens the full project detail modal; the small
/// corner icon bypasses it and goes straight to the project's own URL.
class FeaturedProjectCard extends ConsumerStatefulWidget {
  const FeaturedProjectCard({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<FeaturedProjectCard> createState() =>
      _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends ConsumerState<FeaturedProjectCard> {
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
    final hoverImage = images.length > 1 ? images[1] : null;
    final showHoverImage = _hovered && hoverImage != null;

    final borderColor = _hovered
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurface.withAlpha(24);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_hovered ? 60 : 30),
              blurRadius: _hovered ? 32 : 16,
              offset: Offset(0, _hovered ? 16 : 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              InkWell(
                onTap: () => showProjectDetailModal(context, project: project),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      // Matches real screenshots' own portrait proportions
                      // (~9:19.5, same as DeviceFrame's ratio) so the full
                      // screenshot shows uncropped rather than being sliced
                      // to fit a squarer box.
                      aspectRatio: 9 / 19.5,
                      child: ColoredBox(
                        color: theme.colorScheme.secondaryContainer,
                        child: primaryImage == null
                            ? EmptyProjectPlaceholder(
                                project: project, iconSize: 48)
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Image.asset(
                                  showHoverImage ? hoverImage : primaryImage,
                                  key: ValueKey(showHoverImage),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            projectName ?? '',
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          gapH4,
                          ProjectStatusBadge(status: project.status),
                          if (project.technologies?.isNotEmpty == true) ...[
                            gapH8,
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: project.technologies!
                                  .take(3)
                                  .map((tech) =>
                                      TechnologyChip(technology: tech))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (project.url != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _ExternalLinkButton(
                      onPressed: () => _openDirectly(context)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDirectly(BuildContext context) async {
    final url = widget.project.url;
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

class _ExternalLinkButton extends StatelessWidget {
  const _ExternalLinkButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Open project directly',
      child: Material(
        color: Colors.black.withAlpha(130),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.open_in_new, size: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
