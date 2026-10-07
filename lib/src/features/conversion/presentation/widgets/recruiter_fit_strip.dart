import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/document_link_button.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
/// Scannable shortlist block for recruiters — directly under the trust strip.
class RecruiterFitStrip extends ConsumerWidget {
  const RecruiterFitStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final title = tr(LocaleKeys.recruiterFit_title);
    if (title.trim().isEmpty) return const SizedBox.shrink();

    final rows = <(String, String)>[
      (
        tr(LocaleKeys.recruiterFit_targetRolesLabel),
        tr(LocaleKeys.recruiterFit_targetRoles)
      ),
      (
        tr(LocaleKeys.recruiterFit_experienceLabel),
        tr(LocaleKeys.recruiterFit_experience)
      ),
      (tr(LocaleKeys.recruiterFit_stackLabel), tr(LocaleKeys.recruiterFit_stack)),
      (
        tr(LocaleKeys.recruiterFit_locationLabel),
        tr(LocaleKeys.recruiterFit_location)
      ),
      (
        tr(LocaleKeys.recruiterFit_timezoneLabel),
        tr(LocaleKeys.recruiterFit_timezone)
      ),
      (
        tr(LocaleKeys.recruiterFit_availabilityLabel),
        tr(LocaleKeys.recruiterFit_availability)
      ),
      (
        tr(LocaleKeys.recruiterFit_engagementLabel),
        tr(LocaleKeys.recruiterFit_engagement)
      ),
    ].where((r) => r.$1.isNotEmpty && r.$2.isNotEmpty).toList();

    if (rows.isEmpty) return const SizedBox.shrink();

    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final email = contacts
        .firstWhereOrNull((c) => c.url?.startsWith('mailto:') == true)
        ?.url;
    final linkedin = contacts
        .firstWhereOrNull(
          (c) => c.url?.contains('linkedin.com') == true,
        )
        ?.url;
    final resumeUrl = resumes.firstOrNull?.url;
    final onePagerUrl = tr(LocaleKeys.onePagerUrl);
    final bookingUrl = tr(LocaleKeys.bookingUrl);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              palette.hue(1).withAlpha(28),
              theme.colorScheme.primary,
            ),
            theme.colorScheme.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.hue(1).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchableText(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: palette.hue(1),
            ),
          ),
          gapH16,
          for (final (label, value) in rows) ...[
            SearchableText(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(130),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            SearchableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            gapH12,
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (resumeUrl != null && resumeUrl.isNotEmpty)
                DocumentLinkButton(
                  label: tr(LocaleKeys.recruiterFit_resumeLabel),
                  url: resumeUrl,
                  analyticsEvent: 'resume_click',
                  icon: Icons.download_rounded,
                  outlined: true,
                ),
              if (onePagerUrl.trim().isNotEmpty)
                DocumentLinkButton(
                  label: tr(LocaleKeys.recruiterFit_onePagerLabel),
                  url: onePagerUrl,
                  analyticsEvent: 'onepager_click',
                  icon: Icons.description_outlined,
                  outlined: true,
                ),
              if (email != null)
                DocumentLinkButton(
                  label: tr(LocaleKeys.recruiterFit_emailLabel),
                  url: email,
                  analyticsEvent: 'email_click',
                  icon: Icons.mail_outline,
                  outlined: true,
                ),
              if (linkedin != null && linkedin.isNotEmpty)
                DocumentLinkButton(
                  label: tr(LocaleKeys.recruiterFit_linkedinLabel),
                  url: linkedin,
                  analyticsEvent: 'linkedin_click',
                  icon: Icons.link,
                  outlined: true,
                ),
              if (bookingUrl.trim().isNotEmpty)
                DocumentLinkButton(
                  label: tr(LocaleKeys.bookingLabel),
                  url: bookingUrl,
                  analyticsEvent: 'book_call_click',
                  icon: Icons.event_available_outlined,
                  outlined: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
