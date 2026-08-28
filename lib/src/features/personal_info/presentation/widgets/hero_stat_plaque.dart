import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// The evidence card anchored to the hero's [DeviceFrame] — rating, apps,
/// users, years in one composed plaque rather than three flat stat boxes.
/// Design brief 2, content problem #1: make the numbers credible by
/// showing them as one real object, not a landing-page template pattern.
class HeroStatPlaque extends StatelessWidget {
  const HeroStatPlaque({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(90),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Stat(
              value: '★${tr(LocaleKeys.stats_rating)}',
              label: tr(LocaleKeys.stats_ratingLabel),
            ),
            _divider(theme),
            _Stat(
              value: tr(LocaleKeys.stats_apps),
              label: tr(LocaleKeys.stats_appsLabel),
            ),
            _divider(theme),
            _Stat(
              value: tr(LocaleKeys.stats_users),
              label: tr(LocaleKeys.stats_usersLabel),
            ),
            _divider(theme),
            _Stat(
              value: '${tr(LocaleKeys.stats_years)}yr',
              label: tr(LocaleKeys.stats_yearsLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        width: 1,
        height: 24,
        child: ColoredBox(color: theme.colorScheme.onSurface.withAlpha(24)),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: monoLabelStyle(fontSize: 16, color: theme.colorScheme.tertiary),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            letterSpacing: 0.04,
            color: theme.colorScheme.onSurface.withAlpha(140),
          ),
        ),
      ],
    );
  }
}
