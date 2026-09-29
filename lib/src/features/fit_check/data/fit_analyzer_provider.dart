import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/about/data/about_repository.dart';
import 'package:portfolio/src/features/experience/data/experience_repository.dart';
import 'package:portfolio/src/features/fit_check/application/fit_analyzer.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Built from the same repositories the page renders, so evidence always
/// matches what a visitor can see and click.
final fitAnalyzerProvider = Provider<FitAnalyzer>((ref) {
  return FitAnalyzer(
    experiences: ref.watch(experienceRepositoryProvider).getExperiences(),
    projects: ref.watch(projectRepositoryProvider).getProjects(),
    skills: [
      for (final category
          in ref.watch(aboutRepositoryProvider).getSkillCategories())
        ...?category.skills,
    ],
    totalYears: int.tryParse(tr(LocaleKeys.stats_years)) ?? 0,
  );
});
