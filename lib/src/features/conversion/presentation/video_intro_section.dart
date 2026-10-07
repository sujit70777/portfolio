import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hidden until [LocaleKeys.videoUrl] is a non-empty URL.
class VideoIntroSection extends StatelessWidget {
  const VideoIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final url = tr(LocaleKeys.videoUrl).trim();
    if (url.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final caption = tr(LocaleKeys.videoCaption);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 96),
        SectionEyebrow(
          section: AppSection.video,
          label: tr(LocaleKeys.sectionEyebrowVideo),
        ),
        gapH8,
        SearchableText(
          tr(LocaleKeys.videoSectionTitle),
          style: theme.textTheme.titleLarge,
        ),
        if (caption.isNotEmpty) ...[
          gapH8,
          SearchableText(
            caption,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(170),
            ),
          ),
        ],
        gapH16,
        Material(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              Analytics.track('video_play_click');
              try {
                final uri = Uri.parse(url);
                if (url.endsWith('.mp4') || url.startsWith('assets/')) {
                  await LaunchUrlHelper.launchURL(url, openInNewTab: true);
                } else {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessengerHelper.showLaunchUrlError(
                    context,
                    url: url,
                  );
                }
              }
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: 64,
                      color: theme.colorScheme.tertiary,
                    ),
                    gapH8,
                    Text(
                      'Play intro (60–90 s)',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
