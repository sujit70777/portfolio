import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
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
    final paragraphs = tr(LocaleKeys.aboutDescription).split('\n');

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
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        for (final (index, paragraph) in paragraphs.indexed)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == paragraphs.length - 1 ? 0 : 16,
            ),
            child: Text(
              paragraph,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
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
