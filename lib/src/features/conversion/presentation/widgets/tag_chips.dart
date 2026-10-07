import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';

/// Tags (a note's, a contract card's) as small mono chips outlined in [hue].
class TagChips extends StatelessWidget {
  const TagChips({super.key, required this.tags, required this.hue});

  final List<String> tags;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final tag in tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: hue.withAlpha(16),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: hue.withAlpha(70)),
            ),
            child: Text(
              tag,
              style: monoLabelStyle(fontSize: 11, color: hue),
            ),
          ),
      ],
    );
  }
}
