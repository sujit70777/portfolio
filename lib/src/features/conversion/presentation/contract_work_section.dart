import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/card_grid.dart';
import 'package:portfolio/src/common/widgets/glass_card.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/common/widgets/subsection_heading.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/conversion/domain/conversion_models.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/document_link_button.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/tag_chips.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Contract work: the pitch and booking link in an accent card, then who
/// I help (cards), how an engagement runs (a numbered timeline) and the
/// FAQ (cards) — the same card surface as About and Skills.
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
    final intro = tr(LocaleKeys.contractIntro).trim();
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
        if (intro.isNotEmpty || bookingUrl.isNotEmpty) ...[
          gapH20,
          GlassCard(
            hue: palette.aurora.first,
            accent: palette.aurora,
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (intro.isNotEmpty)
                    SearchableText(
                      intro,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                  if (bookingUrl.isNotEmpty) ...[
                    gapH20,
                    DocumentLinkButton(
                      label: tr(LocaleKeys.bookingLabel),
                      url: bookingUrl,
                      analyticsEvent: 'book_call_click',
                      icon: Icons.event_available_outlined,
                      outlined: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        if (cards.isNotEmpty) ...[
          gapH40,
          SubsectionHeading(tr(LocaleKeys.whoIHelpTitle)),
          gapH16,
          CardGrid(
            children: [
              for (final (i, card) in cards.indexed)
                _HelpCard(card: card, number: i + 1, hue: palette.hue(i)),
            ],
          ),
        ],
        if (steps.isNotEmpty) ...[
          gapH40,
          SubsectionHeading(tr(LocaleKeys.engagementProcessTitle)),
          gapH16,
          for (final (i, step) in steps.indexed)
            ScrollReveal(
              duration: const Duration(milliseconds: 900),
              child: _TimelineStep(
                step: step,
                number: i + 1,
                hue: palette.hue(i),
                nextHue: i < steps.length - 1 ? palette.hue(i + 1) : null,
              ),
            ),
        ],
        if (faqs.isNotEmpty) ...[
          gapH40,
          SubsectionHeading(tr(LocaleKeys.faqTitle)),
          gapH16,
          CardGrid(
            children: [
              for (final (i, faq) in faqs.indexed)
                _FaqCard(faq: faq, hue: palette.hue(i)),
            ],
          ),
        ],
      ],
    );
  }
}

/// Mono "01"-style counter in [hue] — decorative, so a plain Text that
/// find-on-page skips.
Widget _counter(int number, Color hue) => Text(
      number.toString().padLeft(2, '0'),
      style: monoLabelStyle(fontSize: 12, letterSpacing: 0.08, color: hue),
    );

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.card, required this.number, required this.hue});

  final HelpCard card;
  final int number;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _counter(number, hue),
          gapH8,
          SearchableText(
            card.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: hue,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          gapH8,
          SearchableText(
            card.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: mutedTextColor(theme.colorScheme),
            ),
          ),
          if (card.tags.isNotEmpty) ...[
            gapH12,
            TagChips(tags: card.tags, hue: hue),
          ],
        ],
      ),
    );
  }
}

/// One engagement step: a numbered node on the left, joined to the next
/// step's node by a line that fades from this step's hue into the next
/// one's, and the step itself as a card on the right.
class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.step,
    required this.number,
    required this.hue,
    required this.nextHue,
  });

  final ProcessStep step;
  final int number;
  final Color hue;

  /// Null for the last step, which has no line below it.
  final Color? nextHue;

  static const _node = 36.0;
  static const _gap = 14.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = nextHue;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _node,
            child: Column(
              children: [
                Container(
                  width: _node,
                  height: _node,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.alphaBlend(
                      hue.withAlpha(40),
                      theme.colorScheme.primary,
                    ),
                    border: Border.all(color: hue, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: hue.withAlpha(90), blurRadius: 12),
                    ],
                  ),
                  child: Text(
                    '$number',
                    style: monoLabelStyle(fontSize: 14, color: hue)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (next != null)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [hue.withAlpha(160), next.withAlpha(160)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          gapW16,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: next == null ? 0 : _gap),
              child: GlassCard(
                hue: hue,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchableText(
                        step.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: hue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      gapH4,
                      SearchableText(
                        step.body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: mutedTextColor(theme.colorScheme),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faq, required this.hue});

  final FaqItem faq;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Q',
                  style: monoLabelStyle(fontSize: 14, color: hue)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              gapW12,
              Expanded(
                child: SearchableText(
                  faq.question,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: hue,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          gapH8,
          Padding(
            // Answer lines up under the question text, past the "Q".
            padding: const EdgeInsets.only(left: 21),
            child: SearchableText(
              faq.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: mutedTextColor(theme.colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
