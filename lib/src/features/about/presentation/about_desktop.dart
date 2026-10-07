import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/aurora_text.dart';
import 'package:portfolio/src/common/widgets/card_grid.dart';
import 'package:portfolio/src/common/widgets/glass_card.dart';
import 'package:portfolio/src/common/widgets/rich_description.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/about/data/about_repository.dart';
import 'package:portfolio/src/features/about/domain/about_story.dart';
import 'package:portfolio/src/features/about/presentation/widgets/about_cards.dart';
import 'package:portfolio/src/features/about/presentation/widgets/skills_panel.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

class AboutDesktop extends ConsumerWidget {
  const AboutDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillCategories =
        ref.watch(aboutRepositoryProvider).getSkillCategories();
    // The first paragraph is the one-line pitch, set as a lead in the
    // aurora; the rest is split into cards (intro, problems, closing notes)
    // so it reads like the rest of the page rather than one long column.
    final description = tr(LocaleKeys.aboutDescription);
    final story = AboutStory.parse(description);
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow(
          section: AppSection.about,
          label: tr(LocaleKeys.sectionEyebrowAbout),
        ),
        gapH8,
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: SearchableText(
            tr(LocaleKeys.aboutSectionTitleAlt),
            style: theme.textTheme.titleLarge,
          ),
        ),
        GlassCard(
          hue: palette.aurora.first,
          accent: palette.aurora,
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuroraText(
                  story.lead,
                  style: theme.textTheme.headlineSmall?.copyWith(height: 1.3),
                ),
                for (final paragraph in story.intro) ...[
                  gapH16,
                  // RichDescription still draws any "• " lists in the intro.
                  RichDescription(
                    text: paragraph,
                    style: bodyStyle,
                    markerColors: palette.aurora,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (story.problems.isNotEmpty) ...[
          gapH32,
          if (story.heading case final heading?) ...[
            AboutGroupHeading(heading),
            gapH16,
          ],
          CardGrid(
            children: [
              for (final (i, problem) in story.problems.indexed)
                AboutProblemCard(
                  problem: problem,
                  hue: palette.hue(i),
                  index: i,
                ),
            ],
          ),
        ],
        if (story.notes.isNotEmpty) ...[
          gapH16,
          CardGrid(
            children: [
              for (final (i, note) in story.notes.indexed)
                AboutNoteCard(
                  note: note,
                  hue: palette.hue(story.problems.length + i),
                ),
            ],
          ),
        ],
        if (skillCategories.isNotEmpty) ...[
          gapH40,
          KeyedSubtree(
            key: ref.watch(skillsSectionKeyProvider),
            child: SectionEyebrow(
              section: AppSection.skills,
              label: tr(LocaleKeys.sectionEyebrowSkills),
            ),
          ),
          gapH8,
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SearchableText(
              tr(LocaleKeys.skillsSectionTitle),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SkillsPanel(categories: skillCategories),
        ],
      ],
    );
  }
}
