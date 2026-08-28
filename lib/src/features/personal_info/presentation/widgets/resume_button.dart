import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_language_dialog.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class ResumeButton extends StatelessWidget {
  const ResumeButton({super.key, required this.resumes});

  final List<Resume> resumes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SelectionContainer.disabled(
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                : null;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              width: states.contains(WidgetState.hovered) ? 2 : 1,
              color: theme.colorScheme.tertiary,
            );
          }),
          elevation: const WidgetStatePropertyAll(16),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          ),
        ),
        onPressed: () => _onPressed(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Icon(
              const IconData(
                0xeec7,
                fontFamily: "FontAwesome",
              ),
              size: 24,
              color: theme.colorScheme.inverseSurface,
            ),
            gapW12,
            Text(
              tr(LocaleKeys.downloadResume),
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
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
