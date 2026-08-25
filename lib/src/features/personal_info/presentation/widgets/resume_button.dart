import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_language_dialog.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Pubspec-relative path the resume PDF must be added at (see pubspec.yaml
/// `assets/documents/`) for the Download Resume button to actually resolve.
const _resumeAssetPath = 'assets/documents/resume.pdf';

class ResumeButton extends ConsumerStatefulWidget {
  const ResumeButton({super.key, required this.resumes});

  final List<Resume> resumes;

  @override
  ConsumerState<ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends ConsumerState<ResumeButton> {
  bool _isHovered = false;
  void _hoverEffectOn() => setState(() => _isHovered = true);
  void _hoverEffectOff() => setState(() => _isHovered = false);

  @override
  void initState() {
    super.initState();
    unawaited(_warnIfResumeAssetMissing());
  }

  Future<void> _warnIfResumeAssetMissing() async {
    try {
      await rootBundle.load(_resumeAssetPath);
    } catch (_) {
      debugPrint(
        'ResumeButton: no resume found at "$_resumeAssetPath" — the '
        'Download Resume button is wired up but will 404 until you add '
        'your resume PDF at that exact path.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _hoverEffectOn(),
      onExit: (_) => _hoverEffectOff(),
      child: GestureDetector(
        onLongPress: _hoverEffectOn,
        onLongPressUp: _hoverEffectOff,
        child: SelectionContainer.disabled(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: _isHovered
                  ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                  : null,
              side: BorderSide(
                width: _isHovered ? 2 : 1,
                color: theme.colorScheme.tertiary,
              ),
              elevation: 16,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
            onPressed: () => _onPressed(context, ref),
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
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    if (widget.resumes.length > 1) {
      showAdaptiveDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ResumeLanguageDialog(resumes: widget.resumes),
      );
    } else if (widget.resumes.length == 1) {
      final resumeFirstUrl = widget.resumes.first.url;
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
