import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

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
        for (final (i, note) in notes.indexed) ...[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                Analytics.track('note_click', props: {'title': note.title});
                try {
                  await LaunchUrlHelper.launchURL(note.url, openInNewTab: true);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessengerHelper.showLaunchUrlError(
                      context,
                      url: note.url,
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: palette.hue(i),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchableText(
                            note.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: palette.hue(i),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SearchableText(
                            note.summary,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withAlpha(170),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: palette.hue(i).withAlpha(180),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i < notes.length - 1)
            Divider(color: theme.colorScheme.onSurface.withAlpha(20)),
        ],
      ],
    );
  }
}
