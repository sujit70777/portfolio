import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/document_link_button.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class ContractWorkSection extends ConsumerWidget {
  const ContractWorkSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(conversionRepositoryProvider);
    final cards = repo.getContractHelpCards();
    final steps = repo.getEngagementSteps();
    final faqs = repo.getFaqItems();
    if (cards.isEmpty && steps.isEmpty && faqs.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final bookingUrl = tr(LocaleKeys.bookingUrl).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 96),
        SectionEyebrow(
          section: AppSection.contract,
          label: tr(LocaleKeys.sectionEyebrowContract),
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.contractSectionTitle),
          style: theme.textTheme.titleLarge,
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.contractIntro),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(180),
            height: 1.4,
          ),
        ),
        if (bookingUrl.isNotEmpty) ...[
          gapH16,
          DocumentLinkButton(
            label: tr(LocaleKeys.bookingLabel),
            url: bookingUrl,
            analyticsEvent: 'book_call_click',
            icon: Icons.event_available_outlined,
            outlined: true,
          ),
        ],
        if (cards.isNotEmpty) ...[
          gapH32,
          SearchableText(
            tr(LocaleKeys.whoIHelpTitle),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          gapH16,
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 700;
              final w = wide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final (i, card) in cards.indexed)
                    SizedBox(
                      width: w,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            palette.hue(i).withAlpha(18),
                            theme.colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: palette.hue(i).withAlpha(60)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchableText(
                              card.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: palette.hue(i),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            gapH8,
                            SearchableText(
                              card.body,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.35,
                                color: theme.colorScheme.onSurface
                                    .withAlpha(180),
                              ),
                            ),
                            if (card.tags.isNotEmpty) ...[
                              gapH8,
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final tag in card.tags)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: palette.hue(i).withAlpha(90),
                                        ),
                                      ),
                                      child: Text(
                                        tag,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: palette.hue(i),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        if (steps.isNotEmpty) ...[
          gapH32,
          SearchableText(
            tr(LocaleKeys.engagementProcessTitle),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          gapH16,
          for (final (i, step) in steps.indexed) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.hue(i).withAlpha(36),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: palette.hue(i).withAlpha(100)),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.hue(i),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchableText(
                        step.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SearchableText(
                        step.body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(170),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1) gapH12,
          ],
        ],
        if (faqs.isNotEmpty) ...[
          gapH32,
          SearchableText(
            tr(LocaleKeys.faqTitle),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          gapH8,
          for (final (i, faq) in faqs.indexed) ...[
            SearchableText(
              faq.question,
              style: theme.textTheme.titleSmall?.copyWith(
                color: palette.hue(i),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            SearchableText(
              faq.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
            if (i < faqs.length - 1) gapH16,
          ],
        ],
      ],
    );
  }
}
