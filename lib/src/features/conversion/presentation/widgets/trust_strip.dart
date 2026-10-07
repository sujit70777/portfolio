import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// NDA-safe text chips + store/pub.dev badges under the hero.
class TrustStrip extends ConsumerWidget {
  const TrustStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(conversionRepositoryProvider);
    final chips = repo.getTrustChips();
    final badges = repo.getTrustBadgeLinks();
    if (chips.isEmpty && badges.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chips.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (i, chip) in chips.indexed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      palette.hue(i).withAlpha(20),
                      theme.colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: palette.hue(i).withAlpha(55)),
                  ),
                  child: SearchableText(
                    chip,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(200),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        if (chips.isNotEmpty && badges.isNotEmpty) gapH12,
        if (badges.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final badge in badges)
                Tooltip(
                  message: badge.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      Analytics.track('store_badge_click', props: {
                        'label': badge.label,
                      });
                      try {
                        await LaunchUrlHelper.launchURL(badge.url);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessengerHelper.showLaunchUrlError(
                            context,
                            url: badge.url,
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: badge.iconAsset == null
                          ? Text(badge.label,
                              style: theme.textTheme.labelMedium)
                          : SvgPicture.asset(
                              badge.iconAsset!,
                              width: 22,
                              height: 22,
                            ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
