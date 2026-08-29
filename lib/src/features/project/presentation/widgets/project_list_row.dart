import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/icon.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// A dense, image-free row for the long-tail project list (design brief
/// 2, content problem #5) — most of these are small pub.dev packages or
/// in-progress repos with no screenshot to show, so this doesn't pretend
/// they need one the way FeaturedProjectCard's tier does.
///
/// Tapping the row opens the full project detail modal; the trailing
/// arrow icon is a separate hit target that bypasses it and goes straight
/// to the project's own URL.
class ProjectListRow extends StatelessWidget {
  const ProjectListRow({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showProjectDetailModal(context, project: project),
        hoverColor: theme.colorScheme.tertiary.withAlpha(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: MyIcon(
                  icon: project.icon,
                  size: 20,
                  placeholder: Icon(
                    Icons.code,
                    size: 20,
                    color: theme.colorScheme.onSurface.withAlpha(180),
                  ),
                ),
              ),
              gapW16,
              Expanded(
                flex: 2,
                child: Text(
                  project.name ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gapW12,
              ProjectStatusBadge(status: project.status, fontSize: 10),
              gapW16,
              Expanded(
                flex: 5,
                child: Text(
                  project.description ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(180),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gapW16,
              if (project.url != null)
                Tooltip(
                  message: 'Open project directly',
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.arrow_outward,
                      size: 16,
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                    onPressed: () => _openDirectly(context),
                  ),
                ),
            ],
          ),
        ),
      ),
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
