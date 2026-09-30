import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/palette.dart';

/// A project's short architecture bullets ([Project.highlights]) — shared by
/// the flagship card and the detail modal so both read the same. The marker
/// is a small Signal-coloured square rather than a bullet glyph, echoing
/// the mono/changelog vocabulary elsewhere on the page.
class ProjectHighlights extends StatelessWidget {
  const ProjectHighlights({super.key, required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aurora = Palette.of(context).aurora;
    final style = theme.textTheme.bodySmall;
    final lineHeight = (style?.fontSize ?? 14) * (style?.height ?? 1.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, highlight) in highlights.indexed) ...[
          if (index > 0) const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centred on the first line of text, however it wraps.
              Padding(
                padding: EdgeInsets.only(top: (lineHeight - 6) / 2),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    // Stepping through the aurora, bullet by bullet.
                    color: aurora[index % aurora.length],
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(highlight, style: style)),
            ],
          ),
        ],
      ],
    );
  }
}
