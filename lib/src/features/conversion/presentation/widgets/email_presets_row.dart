import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class EmailPresetsRow extends ConsumerWidget {
  const EmailPresetsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(conversionRepositoryProvider).getEmailPresets();
    if (presets.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final email = ref
        .watch(personalInfoRepositoryProvider)
        .getContacts()
        .map((c) => c.url)
        .firstWhereOrNull((u) => u?.startsWith('mailto:') == true)
        ?.substring('mailto:'.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchableText(
          tr(LocaleKeys.emailPresetsTitle),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        gapH8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (i, preset) in presets.indexed)
              ActionChip(
                label: Text(preset.label),
                backgroundColor: Color.alphaBlend(
                  palette.hue(i).withAlpha(22),
                  theme.colorScheme.secondary,
                ),
                side: BorderSide(color: palette.hue(i).withAlpha(70)),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: palette.hue(i),
                  fontWeight: FontWeight.w600,
                ),
                onPressed: email == null
                    ? null
                    : () async {
                        Analytics.track('email_preset_click', props: {
                          'label': preset.label,
                        });
                        final uri = Uri(
                          scheme: 'mailto',
                          path: email,
                          queryParameters: {
                            'subject': preset.subject,
                            'body': preset.body,
                          },
                        );
                        try {
                          await LaunchUrlHelper.launchURL(
                            uri.toString(),
                            openInNewTab: false,
                          );
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessengerHelper.showEmailFallback(
                              context,
                              email: email,
                            );
                          }
                        }
                      },
              ),
          ],
        ),
      ],
    );
  }
}
