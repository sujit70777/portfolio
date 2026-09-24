import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_language_dialog.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class ResumeButton extends StatelessWidget {
  const ResumeButton({super.key, required this.resumes, this.fullWidth = false});

  final List<Resume> resumes;
  final bool fullWidth;

  // Same pill size as the hero's Email/WhatsApp CTAs.
  static const _minTouchHeight = 48.0;

  // Recruiters land here wanting the CV first, so this carries near-equal
  // weight to the primary "Email me" fill: a Signal-coloured border and
  // download icon, sitting between the filled primary and WhatsApp's muted
  // outline. Previously a quiet underlined text link, which read as an
  // afterthought.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signal = theme.colorScheme.tertiary;

    return SelectionContainer.disabled(
      child: OutlinedButton.icon(
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              width: states.contains(WidgetState.hovered) ? 2.5 : 1.5,
              color: signal,
            );
          }),
          foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
          iconColor: WidgetStatePropertyAll(signal),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiaryContainer.withAlpha(90)
                : Colors.transparent;
          }),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          minimumSize: WidgetStatePropertyAll(
            Size(fullWidth ? double.infinity : 0,
                fullWidth ? _minTouchHeight : 0),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          ),
          textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
        ),
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.download_rounded, size: 18),
        label: Text(tr(LocaleKeys.downloadResume)),
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
