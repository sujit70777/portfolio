import 'package:flutter/material.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/constants/themes.dart';

/// Small mono "0N — Label" heading above a section — design brief 2's
/// quiet, recurring nod to the version/changelog vocabulary. A label, not
/// a decoration: real section titles stay in the section headers
/// themselves so a fast scan still finds "Experience"/"Projects" by name.
///
/// The number is derived from [section]'s position in [AppSection] rather
/// than baked into the translated label, so reordering sections can't
/// leave a stale number behind.
class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow({super.key, required this.section, required this.label});

  final AppSection section;
  final String label;

  @override
  Widget build(BuildContext context) {
    final number = section.number.toString().padLeft(2, '0');
    return Text(
      '$number — $label'.toUpperCase(),
      style: monoLabelStyle(
        fontSize: 12,
        letterSpacing: 0.08,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
      ),
    );
  }
}
