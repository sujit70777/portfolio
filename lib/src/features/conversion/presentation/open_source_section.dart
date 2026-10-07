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

class OpenSourceSection extends ConsumerWidget {
  const OpenSourceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages =
        ref.watch(conversionRepositoryProvider).getOpenSourcePackages();
    if (packages.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 96),
        SectionEyebrow(
          section: AppSection.openSource,
          label: tr(LocaleKeys.sectionEyebrowOpenSource),
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.openSourceSectionTitle),
          style: theme.textTheme.titleLarge,
        ),
        gapH20,
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final width = wide
                ? (constraints.maxWidth - 24) / 3
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final (i, pkg) in packages.indexed)
                  SizedBox(
                    width: width,
                    child: Material(
                      color: Color.alphaBlend(
                        palette.hue(i).withAlpha(20),
                        theme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Analytics.track('pubdev_click',
                              props: {'package': pkg.name});
                          LaunchUrlHelper.launchURL(pkg.url);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: palette.hue(i).withAlpha(70)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchableText(
                                pkg.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: palette.hue(i),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              gapH8,
                              SearchableText(
                                pkg.blurb,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.35,
                                  color: theme.colorScheme.onSurface
                                      .withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
