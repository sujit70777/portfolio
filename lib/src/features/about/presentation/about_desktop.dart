import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/aurora_text.dart';
import 'package:portfolio/src/common/widgets/rich_description.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/about/data/about_repository.dart';
import 'package:portfolio/src/features/about/presentation/widgets/skills_panel.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class AboutDesktop extends ConsumerWidget {
  const AboutDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillCategories =
        ref.watch(aboutRepositoryProvider).getSkillCategories();
    // The first paragraph is the one-line pitch, set as a lead in the
    // aurora; the rest is body copy with its bullet lists drawn as lists.
    final description = tr(LocaleKeys.aboutDescription);
    final split = description.indexOf('\n\n');
    final lead = split < 0 ? description : description.substring(0, split);
    final rest = split < 0 ? '' : description.substring(split + 2);
    final theme = Theme.of(context);

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
          child: Text(
            tr(LocaleKeys.aboutSectionTitleAlt),
            style: theme.textTheme.titleLarge,
          ),
        ),
        AuroraText(
          lead,
          style: theme.textTheme.headlineSmall?.copyWith(height: 1.3),
        ),
        if (rest.isNotEmpty) ...[
          gapH20,
          RichDescription(
            text: rest,
            style: theme.textTheme.bodyLarge,
            markerColors: Palette.of(context).aurora,
            paragraphGap: 16,
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
            child: Text(
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
