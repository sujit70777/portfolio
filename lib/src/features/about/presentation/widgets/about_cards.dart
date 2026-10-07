import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/glass_card.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/about/domain/about_story.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// One "problem I've solved": its title in the card's hue, the story as
/// body copy underneath.
class AboutProblemCard extends StatelessWidget {
  const AboutProblemCard({
    super.key,
    required this.problem,
    required this.hue,
    required this.index,
  });

  final AboutProblem problem;
  final Color hue;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative counter — plain Text so find-on-page skips it.
          Text(
            (index + 1).toString().padLeft(2, '0'),
            style: monoLabelStyle(fontSize: 12, letterSpacing: 0.08, color: hue),
          ),
          gapH8,
          SearchableText(
            problem.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: hue,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          if (problem.body.isNotEmpty) ...[
            gapH8,
            SearchableText(
              problem.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: mutedTextColor(theme.colorScheme),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A closing "Label: body" paragraph — what I can do, how I work, what
/// I'm open to — with its label set small, mono and caps in [hue].
class AboutNoteCard extends StatelessWidget {
  const AboutNoteCard({super.key, required this.note, required this.hue});

  final AboutNote note;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = note.label;
    return GlassCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: hue,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(color: hue.withAlpha(120), blurRadius: 8),
                    ],
                  ),
                ),
                gapW12,
                Expanded(
                  child: SearchableText(
                    label.toUpperCase(),
                    style: monoLabelStyle(
                      fontSize: 12,
                      letterSpacing: 0.08,
                      color: hue,
                    ),
                  ),
                ),
              ],
            ),
            gapH12,
          ],
          SearchableText(
            note.body,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

/// Small mono caps heading over a group of About cards, in the same voice
/// as RichDescription's subheadings.
class AboutGroupHeading extends StatelessWidget {
  const AboutGroupHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SearchableText(
      text.toUpperCase(),
      style: monoLabelStyle(
        fontSize: 12,
        letterSpacing: 0.08,
        color: Palette.of(context).hue(0),
      ),
    );
  }
}
