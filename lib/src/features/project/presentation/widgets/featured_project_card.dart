import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/device_frame.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/empty_project_placeholder.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// A device-framed card for the curated "featured" project tier (design
/// brief 2, content problem #5: 24 projects isn't a portfolio, it's a
/// list — this is the small, strongest-work-first set; the rest render as
/// plain rows in ProjectListRow, no image required).
///
/// Tapping the card body opens the full project detail modal (gallery,
/// description, tech stack, role); the small corner icon bypasses it and
/// goes straight to the project's own URL, for visitors who just want the
/// store link.
class FeaturedProjectCard extends ConsumerWidget {
  const FeaturedProjectCard({super.key, required this.project, required this.width});

  final Project project;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projectName = project.name;
    final images = projectName == null
        ? const <String>[]
        : ref.watch(projectImagesProvider(projectName)).maybeWhen(
              data: (value) => value,
              orElse: () => const <String>[],
            );
    final imagePath = project.screenshotPath ??
        (images.isNotEmpty ? images.first : null);

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final screenHeight = width / DeviceFrame.aspectRatio;
    final Widget screen = imagePath == null
        ? EmptyProjectPlaceholder(project: project)
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            cacheWidth: (width * dpr).round(),
            cacheHeight: (screenHeight * dpr).round(),
          );

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => showProjectDetailModal(context, project: project),
            hoverColor: theme.colorScheme.tertiary.withAlpha(15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: DeviceFrame(width: width, screen: screen)),
                  gapH12,
                  Text(
                    projectName ?? '',
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gapH4,
                  _statusTag(context),
                ],
              ),
            ),
          ),
          if (project.url != null)
            Positioned(
              top: 4,
              right: 4,
              child: Tooltip(
                message: 'Open project directly',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                  onPressed: () => _openDirectly(context),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusTag(BuildContext context) {
    final firstTech = project.technologies?.firstOrNull?.name;
    return Text(
      [
        statusLabel(project.status),
        if (firstTech != null) firstTech.toUpperCase(),
      ].join(' · '),
      style: monoLabelStyle(fontSize: 11, color: statusColor(context, project.status)),
    );
  }

  Future<void> _openDirectly(BuildContext context) async {
    final url = project.url;
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
