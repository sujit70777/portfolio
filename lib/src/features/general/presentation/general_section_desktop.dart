import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/features/about/presentation/about_section.dart';
import 'package:portfolio/src/features/experience/data/experience_repository.dart';
import 'package:portfolio/src/features/experience/presentation/experience_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/site_footer.dart';
import 'package:portfolio/src/features/general/presentation/widgets/version_rail.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/project/presentation/project_section.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';

/// Single scrolling column (design brief 2) — the previous layout split
/// the viewport into a fixed hero column beside an independently
/// scrolling twin, the most-cloned developer-portfolio pattern named in
/// the brief. The hero is a normal, short, non-pinned block here like
/// everything else; VersionRail is the one piece of extra structure this
/// width alone affords, next to Experience/Projects only.
class GeneralDesktop extends ConsumerWidget {
  const GeneralDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);
    final experienceCount =
        ref.watch(experienceRepositoryProvider).getExperiences().length;

    return Column(
      children: [
        const MyAppBar(),
        Expanded(
          child: MySelectionArea(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(100, 60, 100, 100),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final contentWidth =
                          constraints.maxWidth < 1040 ? constraints.maxWidth : 1040.0;
                      return SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PersonalInfoSection(),
                            const SizedBox(height: 96),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: ScrollReveal(
                                child: AboutSection(
                                  key: ref.watch(aboutSectionKeyProvider),
                                ),
                              ),
                            ),
                            const SizedBox(height: 96),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: VersionRail(count: experienceCount),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ScrollReveal(
                                        child: ExperienceSection(
                                          key: ref.watch(
                                              experienceSectionKeyProvider),
                                        ),
                                      ),
                                      const SizedBox(height: 96),
                                      ScrollReveal(
                                        child: ProjectSection(
                                          key: ref
                                              .watch(projectSectionKeyProvider),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 96),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: ScrollReveal(child: const SiteFooter()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
