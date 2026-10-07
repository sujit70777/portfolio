import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/document_link_button.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Desktop-only bar after the hero leaves the viewport. Dismissible for the
/// session. Hidden on tablet/mobile.
class StickyAvailableBar extends ConsumerStatefulWidget {
  const StickyAvailableBar({super.key});

  @override
  ConsumerState<StickyAvailableBar> createState() => _StickyAvailableBarState();
}

class _StickyAvailableBarState extends ConsumerState<StickyAvailableBar> {
  static bool _dismissedThisSession = false;

  bool _visible = false;
  VoidCallback? _scrollListener;
  ScrollController? _boundController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ref.read(scrollControllerProvider);
    if (!identical(_boundController, controller)) {
      _boundController?.removeListener(_scrollListener ?? () {});
      _boundController = controller;
      _scrollListener = _onScroll;
      controller.addListener(_onScroll);
      // Mid-mount: build runs right after, so no setState here.
      _visible = _shouldShow();
    }
  }

  bool _shouldShow() {
    final c = _boundController;
    if (c == null || !c.hasClients || _dismissedThisSession) return false;
    // `positions.last`, not `offset`: both layouts' scroll views share this
    // controller, and for the one frame in which the page swaps between
    // them both are attached — `offset` asserts there is exactly one. The
    // newest is the layout being built, same as ScrollProgressBar.
    // Hero is roughly the first viewport; show after ~420px of scroll.
    return c.positions.last.pixels > 420;
  }

  void _onScroll() {
    final show = _shouldShow();
    if (show != _visible) setState(() => _visible = show);
  }

  @override
  void dispose() {
    if (_scrollListener != null) {
      _boundController?.removeListener(_scrollListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context) ||
        _dismissedThisSession ||
        !_visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final email = contacts
        .firstWhereOrNull((c) => c.url?.startsWith('mailto:') == true)
        ?.url;
    final resumeUrl = resumes.firstOrNull?.url;

    return Material(
      elevation: 8,
      color: theme.colorScheme.secondary,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.tertiary.withAlpha(80),
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              gapW8,
              Expanded(
                child: Text(
                  tr(LocaleKeys.stickyAvailableLabel),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (resumeUrl != null && resumeUrl.isNotEmpty)
                DocumentLinkButton(
                  label: tr(LocaleKeys.stickyResumeLabel),
                  url: resumeUrl,
                  analyticsEvent: 'resume_click',
                  outlined: true,
                ),
              if (email != null) ...[
                gapW8,
                DocumentLinkButton(
                  label: tr(LocaleKeys.stickyEmailLabel),
                  url: email,
                  analyticsEvent: 'email_click',
                  outlined: true,
                ),
              ],
              IconButton(
                tooltip: tr(LocaleKeys.stickyDismissLabel),
                onPressed: () {
                  setState(() {
                    _dismissedThisSession = true;
                    _visible = false;
                  });
                },
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
