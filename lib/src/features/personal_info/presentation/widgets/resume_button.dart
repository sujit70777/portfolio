import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_language_dialog.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class ResumeButton extends StatelessWidget {
  const ResumeButton({super.key, required this.resumes});

  final List<Resume> resumes;

  // Deliberately quiet — design brief 2, content problem #3: the resume is
  // the secondary ask. Email/WhatsApp (see PersonalInfoSection) carry the
  // primary-CTA visual weight; this is a plain underlined text link.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SelectionContainer.disabled(
      child: TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurface.withAlpha(180);
          }),
        ),
        onPressed: () => _onPressed(context),
        child: Text(
          tr(LocaleKeys.downloadResume),
          style: theme.textTheme.bodyMedium?.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: theme.colorScheme.onSurface.withAlpha(100),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    if (resumes.length > 1) {
      showAdaptiveDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ResumeLanguageDialog(resumes: resumes),
      );
    } else if (resumes.length == 1) {
      final resumeFirstUrl = resumes.first.url;
      if (resumeFirstUrl == null) {
        ScaffoldMessengerHelper.showLaunchUrlError(context);
      } else {
        try {
          await LaunchUrlHelper.launchURL(resumeFirstUrl, openInNewTab: true);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessengerHelper.showLaunchUrlError(
              context,
              url: resumeFirstUrl,
            );
          }
        }
      }
    } else {
      ScaffoldMessengerHelper.showLaunchUrlError(context);
    }
  }
}
