import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/pulse_dot.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// The hiring facts a recruiter scans for first — availability, location,
/// sponsorship, engagement type, time zone — gathered into one tinted card
/// so they read as a single highlighted status block instead of a line of
/// small caps lost above the name.
class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({super.key, this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final signal = scheme.tertiary;
    final facts = <(IconData, String)>[
      (Icons.public, tr(LocaleKeys.availability_remote)),
      (Icons.verified_user_outlined, tr(LocaleKeys.availability_sponsorship)),
      (Icons.work_outline, tr(LocaleKeys.availability_engagement)),
      (Icons.schedule, tr(LocaleKeys.availability_timezone)),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
      decoration: BoxDecoration(
        color: signal.withAlpha(24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: signal.withAlpha(110)),
        boxShadow: [
          BoxShadow(color: signal.withAlpha(28), blurRadius: 24),
        ],
      ),
      child: Wrap(
        alignment: centered ? WrapAlignment.center : WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 18,
        runSpacing: 8,
        children: [
          // A live indicator: the one thing a recruiter should notice first.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PulseDot(color: signal),
              gapW8,
              SearchableText(
                tr(LocaleKeys.availability_status).toUpperCase(),
                style: monoLabelStyle(
                  fontSize: 12.5,
                  letterSpacing: 0.08,
                  color: signal,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          for (final (icon, label) in facts) _Fact(icon: icon, label: label),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: scheme.tertiary.withAlpha(220)),
        const SizedBox(width: 6),
        Flexible(
          child: SearchableText(
            label,
            style: monoLabelStyle(fontSize: 12.5, color: scheme.onSurface),
          ),
        ),
      ],
    );
  }
}
