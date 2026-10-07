import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/document_link_button.dart';
import 'package:portfolio/src/features/general/presentation/widgets/legal_links_bar.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Contact/store links plus resume / one-pager downloads.
class SiteFooter extends ConsumerWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final resumeUrl = resumes.isNotEmpty ? resumes.first.url : null;
    final onePagerUrl = tr(LocaleKeys.onePagerUrl).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Theme.of(context).colorScheme.onSurface.withAlpha(24)),
        gapH24,
        if (contacts.isNotEmpty) ...[
          ContactBar(contacts: contacts),
          gapH16,
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (resumeUrl != null && resumeUrl.isNotEmpty)
              DocumentLinkButton(
                label: tr(LocaleKeys.downloadResume),
                url: resumeUrl,
                analyticsEvent: 'resume_click',
                icon: Icons.download_rounded,
                outlined: true,
              ),
            if (onePagerUrl.isNotEmpty)
              DocumentLinkButton(
                label: tr(LocaleKeys.downloadOnePager),
                url: onePagerUrl,
                analyticsEvent: 'onepager_click',
                icon: Icons.description_outlined,
                outlined: true,
              ),
          ],
        ),
        gapH16,
        const LegalLinksBar(),
      ],
    );
  }
}
