import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Small mono "0N — Label" heading above a section — design brief 2's
/// quiet, recurring nod to the version/changelog vocabulary. A label, not
/// a decoration: real section titles stay in the section headers
/// themselves so a fast scan still finds "Experience"/"Projects" by name.
///
/// Led by a short aurora bar that draws itself in as the section scrolls
/// into view (via the enclosing [ScrollReveal]) — the page's recurring
/// "something new starts here" cue.
///
/// The number is derived from [section]'s position in [AppSection] rather
/// than baked into the translated label, so reordering sections can't
/// leave a stale number behind.
class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow({super.key, required this.section, required this.label});

  final AppSection section;
  final String label;

  static const _barMin = 8.0;
  static const _barMax = 32.0;

  @override
  Widget build(BuildContext context) {
    // Skip the optional video slot while its URL is empty so numbers stay
    // contiguous (05 Open source → 06 Notes, not 05 → 07).
    final videoVisible = tr(LocaleKeys.videoUrl).trim().isNotEmpty;
    final number = section.number(videoVisible: videoVisible).toString().padLeft(2, '0');
    final palette = Palette.of(context);
    final reveal = CurvedAnimation(
      parent: RevealScope.of(context),
      curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: reveal,
          builder: (context, _) => Container(
            width: _barMin + (_barMax - _barMin) * reveal.value,
            height: 3,
            decoration: BoxDecoration(
              gradient: palette.auroraGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SearchableText(
          '$number — $label'.toUpperCase(),
          style: monoLabelStyle(
            fontSize: 12,
            letterSpacing: 0.08,
            color: mutedTextColor(Theme.of(context).colorScheme),
          ),
        ),
      ],
    );
  }
}
