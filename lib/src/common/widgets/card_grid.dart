import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';

/// Two equal-height columns on wide layouts, one on narrow ones; an odd
/// last card spans the full width so the grid never ends on a half row.
/// Each card rises in on scroll, staggered across its row.
class CardGrid extends StatelessWidget {
  const CardGrid({super.key, required this.children});

  final List<Widget> children;

  static const double _twoColumnBreakpoint = 640;
  static const double _gap = 16;
  static const _stagger = Duration(milliseconds: 90);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= _twoColumnBreakpoint;
        Widget reveal(Widget child, int column) => ScrollReveal(
              // Stagger across a row, not down the whole list.
              delay: _stagger * column,
              duration: const Duration(milliseconds: 900),
              child: child,
            );

        final rows = <Widget>[];
        if (!twoColumns) {
          for (final child in children) {
            rows.add(reveal(child, 0));
          }
        } else {
          for (var i = 0; i < children.length; i += 2) {
            if (i + 1 >= children.length) {
              rows.add(reveal(children[i], 0));
              break;
            }
            rows.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: reveal(children[i], 0)),
                    const SizedBox(width: _gap),
                    Expanded(child: reveal(children[i + 1], 1)),
                  ],
                ),
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, row) in rows.indexed) ...[
              if (i > 0) const SizedBox(height: _gap),
              row,
            ],
          ],
        );
      },
    );
  }
}
