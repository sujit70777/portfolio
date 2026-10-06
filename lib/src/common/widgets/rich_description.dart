import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// Renders plain copy from en.json with enough structure to scan, inferred
/// from its shape so the source stays plain text (the same text Fit Check
/// reads):
///
/// - a line starting with "• " is a bullet, with a small coloured square
///   marker cycling through [markerColors];
/// - with [subheadingColor] set, a plain line directly followed by bullets
///   is a subheading ("Live on the Mac App Store", "Now building: …"), set
///   small, mono, caps and in that colour;
/// - a blank line is a paragraph break of [paragraphGap]; anything else is
///   body text in [style].
class RichDescription extends StatelessWidget {
  const RichDescription({
    super.key,
    required this.text,
    required this.markerColors,
    this.style,
    this.subheadingColor,
    this.paragraphGap = 12,
  });

  final String text;
  final List<Color> markerColors;
  final TextStyle? style;
  final Color? subheadingColor;
  final double paragraphGap;

  static const _bullet = '• ';

  @override
  Widget build(BuildContext context) {
    final body = style ?? Theme.of(context).textTheme.bodyMedium;
    final lineHeight = (body?.fontSize ?? 16) * (body?.height ?? 1.55);
    final lines = text.split('\n');
    final children = <Widget>[];
    var bulletIndex = 0;

    for (final (index, line) in lines.indexed) {
      final next = index + 1 < lines.length ? lines[index + 1] : '';
      if (line.trim().isEmpty) {
        children.add(SizedBox(height: paragraphGap));
      } else if (line.startsWith(_bullet)) {
        final marker = markerColors[bulletIndex++ % markerColors.length];
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Centred on the first line of text, however it wraps.
                Padding(
                  padding: EdgeInsets.only(top: (lineHeight - 6) / 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: marker,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SearchableText(line.substring(_bullet.length), style: body),
                ),
              ],
            ),
          ),
        );
      } else if (subheadingColor != null && next.startsWith(_bullet)) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: SearchableText(
              line.toUpperCase(),
              style: monoLabelStyle(
                fontSize: 12,
                letterSpacing: 0.08,
                color: subheadingColor,
              ),
            ),
          ),
        );
      } else {
        children.add(SearchableText(line, style: body));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
