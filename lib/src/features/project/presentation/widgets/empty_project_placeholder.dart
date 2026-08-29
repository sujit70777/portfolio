import 'package:flutter/material.dart';
import 'package:portfolio/src/common/domain/technology.dart';
import 'package:portfolio/src/common/widgets/icon.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/domain/project.dart';

/// Shown in place of a screenshot when a project has none yet. Deliberately
/// designed rather than a generic "broken image" glyph: the project's
/// primary tech logo at low opacity, or failing that the project's first
/// initial in the accent color — either reads as "no screenshot yet", not
/// "something failed to load".
class EmptyProjectPlaceholder extends StatelessWidget {
  const EmptyProjectPlaceholder({super.key, required this.project, this.iconSize = 40});

  final Project project;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final techWithIcon = project.technologies?.firstWhere(
      (tech) => tech.icon?.assetName != null || tech.icon?.codePoint != null,
      orElse: () => const Technology(),
    );

    return ColoredBox(
      color: theme.colorScheme.secondaryContainer,
      child: Center(
        child: techWithIcon?.icon != null
            ? Opacity(
                opacity: 0.35,
                child: MyIcon(icon: techWithIcon!.icon, size: iconSize),
              )
            : Text(
                (project.name?.trim().isNotEmpty == true
                        ? project.name!.trim()[0]
                        : '?')
                    .toUpperCase(),
                style: monoLabelStyle(
                  fontSize: iconSize,
                  color: theme.colorScheme.tertiary.withAlpha(120),
                ),
              ),
      ),
    );
  }
}
