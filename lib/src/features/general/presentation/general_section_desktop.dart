import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/features/about/presentation/about_section.dart';
import 'package:portfolio/src/features/conversion/presentation/contract_work_section.dart';
import 'package:portfolio/src/features/conversion/presentation/notes_section.dart';
import 'package:portfolio/src/features/conversion/presentation/open_source_section.dart';
import 'package:portfolio/src/features/conversion/presentation/testimonials_section.dart';
import 'package:portfolio/src/features/conversion/presentation/video_intro_section.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/recruiter_fit_strip.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/sticky_available_bar.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/trust_strip.dart';
import 'package:portfolio/src/features/experience/data/experience_repository.dart';
import 'package:portfolio/src/features/experience/presentation/experience_section.dart';
import 'package:portfolio/src/features/fit_check/presentation/fit_check_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/page_background.dart';
import 'package:portfolio/src/features/general/presentation/widgets/site_footer.dart';
import 'package:portfolio/src/features/general/presentation/widgets/version_rail.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/project/presentation/project_section.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';

/// Single scrolling column (design brief 2) — recruiter-first conversion
/// blocks sit under the hero; contract work stays lower on the page.
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
          child: Stack(
            children: [
              MySelectionArea(
                child: PageBackground(
                  color: Theme.of(context).colorScheme.primary,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(100, 60, 100, 100),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final contentWidth = constraints.maxWidth < 1200
                              ? constraints.maxWidth
                              : 1200.0;
                          return SizedBox(
                            width: contentWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const PersonalInfoSection(),
                                const SizedBox(height: 40),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: TrustStrip(),
                                ),
                                const SizedBox(height: 24),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: RecruiterFitStrip(),
                                ),
                                const SizedBox(height: 96),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
                                        child: VersionRail(
                                            count: experienceCount),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              key: ref.watch(
                                                  projectSectionKeyProvider),
                                            ),
                                          ),
                                          const ScrollReveal(
                                            child: TestimonialsSection(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ScrollReveal(
                                    child: OpenSourceSection(
                                      key: ref
                                          .watch(openSourceSectionKeyProvider),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ScrollReveal(
                                    child: VideoIntroSection(
                                      key: ref.watch(videoSectionKeyProvider),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ScrollReveal(
                                    child: NotesSection(
                                      key: ref.watch(notesSectionKeyProvider),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ScrollReveal(
                                    child: ContractWorkSection(
                                      key:
                                          ref.watch(contractSectionKeyProvider),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 96),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ScrollReveal(
                                    child: FitCheckSection(
                                      key:
                                          ref.watch(fitCheckSectionKeyProvider),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 96),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: ScrollReveal(child: SiteFooter()),
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
              const Align(
                alignment: Alignment.bottomCenter,
                child: StickyAvailableBar(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
