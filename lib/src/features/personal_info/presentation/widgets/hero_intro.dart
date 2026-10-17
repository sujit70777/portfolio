import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// Everything under the name, split into a clear hierarchy instead of one
/// long run-on title plus a wall of small caps:
///
/// 1. Role — the headline a recruiter matches against.
/// 2. Platforms — a short accented mono line.
/// 3. Tagline — one sentence, muted body text.
/// 4. Focus areas — scannable chips, sentence case.
class HeroIntro extends StatelessWidget {
  const HeroIntro({
    super.key,
    required this.titleSize,
    this.centered = false,
  });

  final double titleSize;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final focusAreas = tr(LocaleKeys.subDescription)
        .split(' · ')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchableText(
          tr(LocaleKeys.heroRole),
          textAlign: textAlign,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: titleSize * 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.heroPlatforms),
          textAlign: textAlign,
          style: monoLabelStyle(
            fontSize: 14,
            letterSpacing: 0.04,
            color: scheme.tertiary,
          ),
        ),
        gapH16,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SearchableText(
            tr(LocaleKeys.heroTagline),
            textAlign: textAlign,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              color: mutedTextColor(scheme),
            ),
          ),
        ),
        gapH20,
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [for (final area in focusAreas) _FocusChip(label: area)],
        ),
      ],
    );
  }
}

class _FocusChip extends StatelessWidget {
  const _FocusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.onSurface.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.onSurface.withAlpha(36)),
      ),
      child: SearchableText(
        label,
        style: monoLabelStyle(fontSize: 12.5, color: mutedTextColor(scheme)),
      ),
    );
  }
}
