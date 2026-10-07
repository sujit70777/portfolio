import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/about/presentation/about_section.dart';
import 'package:portfolio/src/features/conversion/presentation/contract_work_section.dart';
import 'package:portfolio/src/features/conversion/presentation/notes_section.dart';
import 'package:portfolio/src/features/conversion/presentation/open_source_section.dart';
import 'package:portfolio/src/features/conversion/presentation/testimonials_section.dart';
import 'package:portfolio/src/features/conversion/presentation/video_intro_section.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/recruiter_fit_strip.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/trust_strip.dart';
import 'package:portfolio/src/features/experience/presentation/experience_section.dart';
import 'package:portfolio/src/features/fit_check/presentation/fit_check_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/page_background.dart';
import 'package:portfolio/src/features/general/presentation/widgets/site_footer.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/sliver_app_bar.dart';
import 'package:portfolio/src/features/project/presentation/project_section.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';

class GeneralTablet extends ConsumerWidget {
  const GeneralTablet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return Column(
      children: [
        Expanded(
          child: MySelectionArea(
            child: PageBackground(
              color: Theme.of(context).colorScheme.primary,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  const MySliverAppBar(),
                  SliverList.list(
                    children: [
                      Padding(
                        padding: _buildResponsivePadding(context: context),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: PersonalInfoSection(
                                  key: ref.watch(homeSectionKeyProvider),
                                ),
                              ),
                              gapH40,
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: TrustStrip(),
                              ),
                              gapH24,
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: RecruiterFitStrip(),
                              ),
                              gapH100,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: AboutSection(
                                    key: ref.watch(aboutSectionKeyProvider),
                                  ),
                                ),
                              ),
                              gapH100,
                              ScrollReveal(
                                child: ExperienceSection(
                                  key: ref
                                      .watch(experienceSectionKeyProvider),
                                ),
                              ),
                              gapH100,
                              ScrollReveal(
                                child: ProjectSection(
                                  key: ref.watch(projectSectionKeyProvider),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: ScrollReveal(
                                  child: TestimonialsSection(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: OpenSourceSection(
                                    key: ref
                                        .watch(openSourceSectionKeyProvider),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: VideoIntroSection(
                                    key: ref.watch(videoSectionKeyProvider),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: NotesSection(
                                    key: ref.watch(notesSectionKeyProvider),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: ContractWorkSection(
                                    key: ref.watch(contractSectionKeyProvider),
                                  ),
                                ),
                              ),
                              gapH100,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ScrollReveal(
                                  child: FitCheckSection(
                                    key: ref.watch(fitCheckSectionKeyProvider),
                                  ),
                                ),
                              ),
                              gapH100,
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: ScrollReveal(child: SiteFooter()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  EdgeInsetsGeometry _buildResponsivePadding({required BuildContext context}) {
    if (Responsive.isMobile(context)) {
      return const EdgeInsets.fromLTRB(20, 32, 20, 88);
    }
    return const EdgeInsets.fromLTRB(48, 60, 48, 88);
  }
}
