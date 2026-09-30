import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/app_section.dart';
import 'package:portfolio/src/common/widgets/gradient_button.dart';
import 'package:portfolio/src/common/widgets/section_eyebrow.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/fit_check/application/fit_summary.dart';
import 'package:portfolio/src/features/fit_check/data/fit_analyzer_provider.dart';
import 'package:portfolio/src/features/fit_check/domain/fit_report.dart';
import 'package:portfolio/src/features/fit_check/presentation/widgets/fit_results.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Paste a job description or project brief, get every requirement mapped
/// to the role or project on this page that backs it up — gaps included.
/// See FitAnalyzer for why this is a deterministic in-browser match rather
/// than an AI chat.
class FitCheckSection extends ConsumerStatefulWidget {
  const FitCheckSection({super.key});

  @override
  ConsumerState<FitCheckSection> createState() => _FitCheckSectionState();
}

class _FitCheckSectionState extends ConsumerState<FitCheckSection> {
  static const _minLength = 40;
  // mailto bodies past ~2000 characters get truncated or rejected by some
  // mail clients; the full summary is always one "Copy summary" away.
  static const _maxMailBodyLength = 1800;

  final _controller = TextEditingController();
  FitReport? _report;
  String? _message;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final text = _controller.text.trim();
    setState(() {
      if (text.length < _minLength) {
        _report = null;
        _message = tr(LocaleKeys.fitCheck_tooShort);
        return;
      }
      final report = ref.read(fitAnalyzerProvider).analyze(text);
      _report = report.isEmpty ? null : report;
      _message = report.isEmpty ? tr(LocaleKeys.fitCheck_nothingFound) : null;
    });
  }

  void _trySample() {
    _controller.text = tr(LocaleKeys.fitCheck_sampleText);
    _check();
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _report = null;
      _message = null;
    });
  }

  String? get _email => ref
      .read(personalInfoRepositoryProvider)
      .getContacts()
      .map((c) => c.url)
      .firstWhereOrNull((url) => url?.startsWith('mailto:') == true)
      ?.substring('mailto:'.length);

  String _summary(FitReport report) => buildFitSummary(
    report,
    name: tr(LocaleKeys.name),
    headline: tr(LocaleKeys.description),
    siteUrl: tr(LocaleKeys.siteUrl),
    email: _email,
    presentLabel: tr(LocaleKeys.present),
  );

  Future<void> _copySummary(FitReport report) async {
    await Clipboard.setData(ClipboardData(text: _summary(report)));
    if (!mounted) return;
    ScaffoldMessengerHelper.showMessage(
      context,
      tr(LocaleKeys.fitCheck_copiedSummary),
    );
  }

  Future<void> _emailAboutRole(FitReport report) async {
    final email = _email;
    if (email == null) return;
    var summary = _summary(report);
    if (summary.length > _maxMailBodyLength) {
      summary = '${summary.substring(0, _maxMailBodyLength)}…';
    }
    // Encoded by hand: Uri's queryParameters encodes spaces as "+", which
    // several mail clients show literally.
    final body = '\n\n---\n$summary';
    final url =
        'mailto:$email'
        '?subject=${Uri.encodeComponent(tr(LocaleKeys.fitCheck_emailSubject))}'
        '&body=${Uri.encodeComponent(body)}';
    try {
      await LaunchUrlHelper.launchURL(url, openInNewTab: false);
    } catch (_) {
      // Handled below either way.
    }
    if (!mounted) return;
    ScaffoldMessengerHelper.showEmailFallback(context, email: email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = mutedTextColor(scheme);
    final report = _report;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow(
          section: AppSection.fitCheck,
          label: tr(LocaleKeys.sectionEyebrowFitCheck),
        ),
        gapH8,
        Text(tr(LocaleKeys.fitCheck_title), style: theme.textTheme.titleLarge),
        gapH8,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            tr(LocaleKeys.fitCheck_intro),
            style: theme.textTheme.bodyMedium?.copyWith(color: muted),
          ),
        ),
        gapH12,
        Row(
          children: [
            Icon(Icons.lock_outline, size: 14, color: scheme.tertiary),
            gapW8,
            Flexible(
              child: Text(
                tr(LocaleKeys.fitCheck_privacy).toUpperCase(),
                style: monoLabelStyle(
                  fontSize: 11,
                  letterSpacing: 0.06,
                  color: muted,
                ),
              ),
            ),
          ],
        ),
        gapH20,
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.tertiary.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                      _check,
                  const SingleActivator(
                    LogicalKeyboardKey.enter,
                    control: true,
                  ): _check,
                },
                child: TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 14,
                  keyboardType: TextInputType.multiline,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: tr(LocaleKeys.fitCheck_inputHint),
                    filled: true,
                    fillColor: scheme.secondary,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.tertiary),
                    ),
                  ),
                ),
              ),
              gapH12,
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GradientButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    onPressed: _check,
                    icon: const Icon(Icons.fact_check_outlined, size: 18),
                    child: Text(tr(LocaleKeys.fitCheck_checkButton)),
                  ),
                  _TextAction(
                    label: tr(LocaleKeys.fitCheck_sampleButton),
                    onPressed: _trySample,
                  ),
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) => _controller.text.isEmpty
                        ? const SizedBox.shrink()
                        : _TextAction(
                            label: tr(LocaleKeys.fitCheck_clearButton),
                            onPressed: _clear,
                          ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: report != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: FitResults(
                          report: report,
                          onEmail: _email == null
                              ? null
                              : () => _emailAboutRole(report),
                          onCopySummary: () => _copySummary(report),
                        ),
                      )
                    : _message != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _message!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: muted,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.tertiary,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
