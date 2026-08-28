import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/device_frame.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// A device-framed card for the curated "featured" project tier (design
/// brief 2, content problem #5: 24 projects isn't a portfolio, it's a
/// list — this is the small, strongest-work-first set; the rest render as
/// plain rows in ProjectListRow, no image required).
///
/// Simpler than the general-grid ProjectImage/ProjectCard it sits
/// alongside: tapping opens the project's URL directly rather than the
/// image lightbox gallery — a deliberate scope cut for this pass rather
/// than reshaping the tested, landscape-oriented ProjectImage into a
/// portrait device frame.
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
        ? ColoredBox(
            color: theme.colorScheme.secondaryContainer,
            child: const Center(
              child: Icon(Icons.smartphone_outlined, color: Colors.white38),
            ),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            cacheWidth: (width * dpr).round(),
            cacheHeight: (screenHeight * dpr).round(),
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onTap(context),
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
              Text(
                _statusTag(),
                style: monoLabelStyle(
                  fontSize: 11,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusTag() {
    final firstTech = project.technologies?.firstOrNull?.name;
    return [
      'SHIPPED',
      if (firstTech != null) firstTech.toUpperCase(),
    ].join(' · ');
  }

  Future<void> _onTap(BuildContext context) async {
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
