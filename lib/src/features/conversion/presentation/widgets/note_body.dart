import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/conversion/domain/note_markup.dart';

/// Draws a note's body (see note_markup.dart) for reading: generous line
/// height, bold lead-ins at full contrast, list markers and `code` in the
/// note's [hue].
class NoteBody extends StatelessWidget {
  const NoteBody({super.key, required this.body, required this.hue});

  final String body;
  final Color hue;

  static const _blockGap = 18.0;
  static const _itemGap = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(height: 1.7);
    final lineHeight = (style?.fontSize ?? 16) * (style?.height ?? 1.7);
    final blocks = parseNoteBody(body);

    InlineSpan spanOf(NoteSpan s) {
      if (s.code) {
        return TextSpan(
          text: s.text,
          style: monoLabelStyle(
            fontSize: (style?.fontSize ?? 16) * 0.88,
            color: hue,
          ).copyWith(backgroundColor: hue.withAlpha(28)),
        );
      }
      return TextSpan(
        text: s.text,
        style: s.bold
            ? TextStyle(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              )
            : null,
      );
    }

    Widget rich(List<NoteSpan> spans) =>
        Text.rich(TextSpan(style: style, children: spans.map(spanOf).toList()));

    Widget item(Widget marker, List<NoteSpan> spans) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 26, child: marker),
            Expanded(child: rich(spans)),
          ],
        );

    final children = <Widget>[];
    for (final (b, block) in blocks.indexed) {
      if (b > 0) children.add(const SizedBox(height: _blockGap));
      switch (block.kind) {
        case NoteBlockKind.paragraph:
          children.add(rich(block.items.first));
        case NoteBlockKind.bullets:
        case NoteBlockKind.numbered:
          for (final (i, spans) in block.items.indexed) {
            if (i > 0) children.add(const SizedBox(height: _itemGap));
            final marker = block.kind == NoteBlockKind.bullets
                // Centred on the first line of text, however it wraps.
                ? Padding(
                    padding: EdgeInsets.only(top: (lineHeight - 7) / 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: hue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  )
                : Text(
                    '${i + 1}.',
                    style: monoLabelStyle(
                      fontSize: style?.fontSize ?? 16,
                      color: hue,
                    ).copyWith(height: style?.height),
                  );
            children.add(item(marker, spans));
          }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
