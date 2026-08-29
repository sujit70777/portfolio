import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/featured_project_card.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_list_row.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

const _gridSpacing = 20.0;
const _collapsedCount = 6;

/// Curated (design brief 2, content problem #5): featured projects — real
/// shipped work with the strongest story — get the device-frame treatment
/// in a 4-column grid; the other, longer tail (small pub.dev packages,
/// in-progress repos) render as plain rows, collapsed to the first
/// [_collapsedCount] by default.
class ProjectDesktop extends ConsumerWidget {
  const ProjectDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects =
        ref.watch(projectRepositoryProvider).getProjects().toList();
    final featured = projects.where((p) => p.featured == true).toList();
    final others = projects.where((p) => p.featured != true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow(
          section: AppSection.projects,
          label: tr(LocaleKeys.sectionEyebrowProjects),
        ),
        gapH8,
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            tr(LocaleKeys.projectsSectionTitle),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (featured.isNotEmpty) _FeaturedGrid(projects: featured),
        if (others.isNotEmpty) ...[
          gapH40,
          Text(
            tr(LocaleKeys.projectsMoreLabel),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          gapH8,
          _CollapsibleProjectList(projects: others),
        ],
      ],
    );
  }
}

/// 4 columns on desktop, 2 on tablet, 1 on mobile.
class _FeaturedGrid extends StatelessWidget {
  const _FeaturedGrid({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.isDesktop(context)
        ? 4
        : Responsive.isTablet(context)
            ? 2
            : 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - _gridSpacing * (columns - 1)) / columns;
        return Wrap(
          spacing: _gridSpacing,
          runSpacing: _gridSpacing,
          children: projects.map((project) {
            return SizedBox(
              width: cardWidth,
              child:
                  FeaturedProjectCard(project: project, width: cardWidth - 24),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Shows the first [_collapsedCount] rows with a "Show all (N)" toggle
/// that reveals the rest — a real, focusable button with `expanded`
/// semantics rather than a bare tap handler, so screen readers announce
/// the collapsed/expanded state.
class _CollapsibleProjectList extends StatefulWidget {
  const _CollapsibleProjectList({required this.projects});

  final List<Project> projects;

  @override
  State<_CollapsibleProjectList> createState() =>
      _CollapsibleProjectListState();
}

class _CollapsibleProjectListState extends State<_CollapsibleProjectList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final projects = widget.projects;
    final visible =
        _expanded ? projects : projects.take(_collapsedCount).toList();
    final divider = Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
    );

    return Column(
      children: [
        ...visible.mapIndexed((index, project) {
          return Column(
            children: [
              ProjectListRow(project: project),
              if (index != visible.length - 1) divider,
            ],
          );
        }),
        if (projects.length > _collapsedCount) ...[
          gapH12,
          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              button: true,
              expanded: _expanded,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Show less' : 'Show all (${projects.length})',
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
