import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/card_grid.dart';
import 'package:portfolio/src/common/widgets/glass_card.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/conversion/domain/conversion_models.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/note_reader_dialog.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/tag_chips.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Notes from production work as a grid of cards; each opens in place in
/// the note reader rather than on a separate page.
class NotesSection extends ConsumerWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(conversionRepositoryProvider).getNotes();
    if (notes.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 96),
        SectionEyebrow(
          section: AppSection.notes,
          label: tr(LocaleKeys.sectionEyebrowNotes),
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.notesSectionTitle),
          style: theme.textTheme.titleLarge,
        ),
        gapH20,
        CardGrid(
          children: [
            for (final (i, note) in notes.indexed)
              _NoteCard(
                note: note,
                number: i + 1,
                hue: palette.hue(i),
                onOpen: () =>
                    showNoteReader(context, note: note, allNotes: notes),
              ),
          ],
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.number,
    required this.hue,
    required this.onOpen,
  });

  final Note note;
  final int number;
  final Color hue;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = mutedTextColor(theme.colorScheme);
    final readLabel = tr(LocaleKeys.noteReadLabel);

    return GlassCard(
      hue: hue,
      onTap: onOpen,
      semanticLabel: '${note.title}. $readLabel',
      child: Column(
        // In a two-column row the cards share one height; spaceBetween
        // keeps every "Read note" on the same baseline.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [
                  number.toString().padLeft(2, '0'),
                  tr(LocaleKeys.noteMinutesRead,
                          args: ['${note.readingMinutes}'])
                      .toUpperCase(),
                ].join('  ·  '),
                style: monoLabelStyle(
                  fontSize: 12,
                  letterSpacing: 0.08,
                  color: hue,
                ),
              ),
              gapH12,
              SearchableText(
                note.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: hue,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              if (note.description.isNotEmpty) ...[
                gapH8,
                SearchableText(
                  note.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: muted,
                  ),
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                gapH12,
                TagChips(tags: note.tags, hue: hue),
              ],
            ],
          ),
          gapH16,
          Row(
            children: [
              Text(
                readLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: hue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              gapW4,
              Icon(Icons.arrow_forward_rounded, size: 16, color: hue),
            ],
          ),
        ],
      ),
    );
  }
}
