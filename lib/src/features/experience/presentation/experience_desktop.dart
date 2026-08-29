import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/experience/data/experience_repository.dart';
import 'package:portfolio/src/features/experience/presentation/widgets/experience_card.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class ExperienceDesktop extends ConsumerWidget {
  const ExperienceDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences =
        ref.watch(experienceRepositoryProvider).getExperiences().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: SectionEyebrow(
            section: AppSection.experience,
            label: tr(LocaleKeys.sectionEyebrowExperience),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 20),
          child: Text(
            tr(LocaleKeys.experienceSectionTitle),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...experiences.mapIndexed((index, experience) {
          // Highest number = current/most-recent role, matching a
          // changelog's newest-version-first convention — see
          // VersionRail's doc comment for the same numbering.
          final version = experiences.length - index;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 34,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        'v$version',
                        style: monoLabelStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: ExperienceCard(experience: experience)),
                ],
              ),
              if (index != experiences.length - 1) gapH24,
            ],
          );
        }),
      ],
    );
  }
}
