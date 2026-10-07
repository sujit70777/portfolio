import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Renders only when real testimonials exist — empty array hides entirely.
class TestimonialsSection extends ConsumerWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(conversionRepositoryProvider).getTestimonials();
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        SearchableText(
          tr(LocaleKeys.sectionEyebrowTestimonials),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        gapH16,
        for (final (i, t) in items.indexed) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                palette.hue(i).withAlpha(18),
                theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.hue(i).withAlpha(55)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchableText(
                  '“${t.quote}”',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                gapH12,
                SearchableText(
                  [
                    t.name,
                    if ((t.role ?? '').isNotEmpty) t.role,
                    if ((t.company ?? '').isNotEmpty) t.company,
                  ].join(' · '),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: palette.hue(i),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((t.linkedinUrl ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () async {
                      final url = t.linkedinUrl!;
                      try {
                        await LaunchUrlHelper.launchURL(url);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessengerHelper.showLaunchUrlError(
                            context,
                            url: url,
                          );
                        }
                      }
                    },
                    child: const Text('LinkedIn recommendation'),
                  ),
                ],
              ],
            ),
          ),
          if (i < items.length - 1) gapH12,
        ],
      ],
    );
  }
}
