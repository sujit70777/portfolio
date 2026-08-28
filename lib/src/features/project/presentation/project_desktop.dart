import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/featured_project_card.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_list_row.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

const _cardWidth = 200.0;
const _gridSpacing = 20.0;

/// Curated (design brief 2, content problem #5): featured projects — real
/// shipped work with the strongest story — get the device-frame treatment
/// in a grid; the other ~18 (small pub.dev packages, in-progress repos)
/// render as plain rows, no image implied where none exists.
class ProjectDesktop extends ConsumerWidget {
  const ProjectDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectRepositoryProvider).getProjects().toList();
    final featured = projects.where((p) => p.featured == true).toList();
    final others = projects.where((p) => p.featured != true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow(label: tr(LocaleKeys.sectionEyebrowProjects)),
        gapH8,
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            tr(LocaleKeys.projectsSectionTitle),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (featured.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  constraints.maxWidth < _cardWidth ? constraints.maxWidth : _cardWidth;
              return Wrap(
                spacing: _gridSpacing,
                runSpacing: _gridSpacing,
                children: featured.map((project) {
                  return SizedBox(
                    width: cardWidth,
                    child: FeaturedProjectCard(project: project, width: cardWidth - 24),
                  );
                }).toList(),
              );
            },
          ),
        if (others.isNotEmpty) ...[
          gapH40,
          Text(
            tr(LocaleKeys.projectsMoreLabel),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          gapH8,
          _ProjectList(projects: others),
        ],
      ],
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
    );
    return Column(
      children: [
        ...projects.mapIndexed((index, project) {
          return Column(
            children: [
              ProjectListRow(project: project),
              if (index != projects.length - 1) divider,
            ],
          );
        }),
      ],
    );
  }
}
