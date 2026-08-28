import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/profile_avatar.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_button.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Avatar size, side-by-side vs. stacked layout, and resume-button padding
/// used to differ across three near-identical desktop/tablet/mobile widgets.
/// Collapsed into one widget driven by [Responsive]'s breakpoints — the
/// breakpoints used here (isSplitScreenDesktop for the wide layout, isMobile
/// for the stacked one) match what the old PersonalInfoSection picked
/// between PersonalInfoDesktop/Tablet/Mobile, so the rendered layout at any
/// given width is unchanged.
class PersonalInfoSection extends ConsumerWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();

    final isWide = Responsive.isSplitScreenDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final textTheme = Theme.of(context).textTheme;

    final avatarSize = isWide
        ? 160.0
        : isMobile
            ? 96.0
            : 130.0;
    final resumeVerticalPadding = isWide
        ? 24.0
        : isMobile
            ? 28.0
            : 36.0;

    final nameAndDescription = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LocaleKeys.name),
          style: isMobile ? textTheme.displayMedium : textTheme.displayLarge,
        ),
        gapH4,
        Text(
          tr(LocaleKeys.description),
          style: isMobile
              ? textTheme.titleLarge?.copyWith(fontSize: 20)
              : textTheme.titleLarge,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) ...[
          ProfileAvatar(size: avatarSize),
          gapH16,
          nameAndDescription,
          gapH8,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(size: avatarSize),
              isWide ? gapW24 : gapW20,
              Expanded(child: nameAndDescription),
            ],
          ),
          gapH16,
        ],
        Text(
          tr(LocaleKeys.subDescription),
          style: textTheme.bodyLarge,
        ),
        if (isWide) gapH40,
        _buildResumeButton(
          resumes: resumes,
          verticalPadding: resumeVerticalPadding,
        ),
        gapH8,
        ContactBar(contacts: contacts),
      ],
    );
  }

  Widget _buildResumeButton({
    required List<Resume> resumes,
    required double verticalPadding,
  }) {
    if (resumes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: ResumeButton(resumes: resumes),
    );
  }
}
