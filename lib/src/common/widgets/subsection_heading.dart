import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// A heading inside a section ("Who I help", "FAQ"): bold title text led
/// by a short bar in the aurora gradient, so it reads as a step below the
/// section title rather than as body copy.
class SubsectionHeading extends StatelessWidget {
  const SubsectionHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aurora = Palette.of(context).aurora;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: aurora,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: SearchableText(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
