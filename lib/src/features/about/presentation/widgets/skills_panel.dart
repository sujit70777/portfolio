import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/about/domain/skill_category.dart';

/// Categorized skills grid: two columns on wide layouts, one on narrow ones.
class SkillsPanel extends StatelessWidget {
  const SkillsPanel({super.key, required this.categories});

  final List<SkillCategory> categories;

  static const double _twoColumnBreakpoint = 640;
  static const double _columnGap = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= _twoColumnBreakpoint;
        final cardWidth = twoColumns
            ? (constraints.maxWidth - _columnGap) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: _columnGap,
          runSpacing: _columnGap,
          children: categories.map((category) {
            return SizedBox(
              width: cardWidth,
              child: _SkillCategoryCard(category: category),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  const _SkillCategoryCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skills = category.skills ?? const <String>[];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.tertiary.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.category ?? '',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
          gapH12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => _SkillChip(label: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

/// Plain-text pill matching TechnologyChip's shape and background so the
/// skills panel reads as the same visual family as the tech-stack chips
/// used elsewhere (experience/project cards).
class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
