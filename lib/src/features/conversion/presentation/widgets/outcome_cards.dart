import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// Verified outcome facts under / beside the hero stat plaque.
class OutcomeCards extends ConsumerWidget {
  const OutcomeCards({super.key, this.columns = 2});

  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomes = ref.watch(conversionRepositoryProvider).getOutcomes();
    if (outcomes.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 10.0;
        final width = columns <= 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (i, outcome) in outcomes.indexed)
              SizedBox(
                width: width,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      palette.hue(i).withAlpha(22),
                      theme.colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.hue(i).withAlpha(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchableText(
                        outcome.value,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: palette.hue(i),
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SearchableText(
                        outcome.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(160),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
