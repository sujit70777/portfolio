import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';

/// Small mono "0N — Label" heading above a section — design brief 2's
/// quiet, recurring nod to the version/changelog vocabulary. A label, not
/// a decoration: real section titles stay in the section headers
/// themselves so a fast scan still finds "Experience"/"Projects" by name.
class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: monoLabelStyle(
        fontSize: 12,
        letterSpacing: 0.08,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
      ),
    );
  }
}
