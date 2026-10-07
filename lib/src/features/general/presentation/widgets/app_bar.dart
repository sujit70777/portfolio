import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/data/language_repository.dart';
import 'package:portfolio/src/common/widgets/first_paint_entrance.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/general/presentation/widgets/app_bar_button.dart';
import 'package:portfolio/src/features/general/presentation/widgets/dark_mode_switch.dart';
import 'package:portfolio/src/features/general/presentation/widgets/locale_button.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';

/// Matches the pre-Flutter hero brand mark in `web/index.html` (`.pl-prompt`).
const _brandPrompt = '>_';
/// Site gold — same as `--pl-accent` / dark `ColorScheme.tertiary`.
const _brandPromptGold = Color(0xfffbc771);

/// Below this width the secondary nav items move into a "More" menu so the
/// bar doesn't overflow (seven text buttons + locale + theme ≈ 980px).
const _compactNavBreakpoint = 1180.0;

class MyAppBar extends ConsumerWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < _compactNavBreakpoint;

    return MySelectionArea(
      child: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _scrollToTop(context, ref),
            child: SizedBox(
              height: kToolbarHeight,
              child: SelectionContainer.disabled(
                child: FirstPaintEntrance(
                  offset: const Offset(-64, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        _brandPrompt,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 1,
                          color: _brandPromptGold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          tr(LocaleKeys.portfolio),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          if (Responsive.isDesktop(context))
            FirstPaintEntrance(
              offset: const Offset(64, 0),
              child: Row(
                children: [
                  AppBarButton(
                    title: tr(LocaleKeys.aboutSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(ref.watch(aboutSectionKeyProvider));
                    },
                  ),
                  if (!compact)
                    AppBarButton(
                      title: tr(LocaleKeys.skillsSectionTitle),
                      onPressed: () {
                        _onAppBarButtonTap(ref.watch(skillsSectionKeyProvider));
                      },
                    ),
                  AppBarButton(
                    title: tr(LocaleKeys.experienceSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(
                        ref.watch(experienceSectionKeyProvider),
                      );
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.projectsSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(ref.watch(projectSectionKeyProvider));
                    },
                  ),
                  if (!compact) ...[
                    AppBarButton(
                      title: tr(LocaleKeys.openSourceSectionTitle),
                      onPressed: () {
                        _onAppBarButtonTap(
                            ref.watch(openSourceSectionKeyProvider));
                      },
                    ),
                    AppBarButton(
                      title: tr(LocaleKeys.contractSectionTitle),
                      onPressed: () {
                        _onAppBarButtonTap(
                            ref.watch(contractSectionKeyProvider));
                      },
                    ),
                  ],
                  if (compact)
                    _MoreNavMenu(
                      onSkills: () => _onAppBarButtonTap(
                          ref.watch(skillsSectionKeyProvider)),
                      onOpenSource: () => _onAppBarButtonTap(
                          ref.watch(openSourceSectionKeyProvider)),
                      onContract: () => _onAppBarButtonTap(
                          ref.watch(contractSectionKeyProvider)),
                    ),
                  AppBarButton(
                    title: tr(LocaleKeys.fitCheckSectionTitle),
                    emphasized: true,
                    onPressed: () {
                      _onAppBarButtonTap(ref.watch(fitCheckSectionKeyProvider));
                    },
                  ),
                  _buildLocaleButton(context, ref),
                  gapW8,
                  const DarkModeSwitch(),
                  gapW8,
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _scrollToTop(BuildContext context, WidgetRef ref) {
    if (Responsive.isDesktop(context)) {
      _onAppBarButtonTap(ref.watch(aboutSectionKeyProvider));
    } else {
      _onAppBarButtonTap(ref.watch(homeSectionKeyProvider));
    }
  }

  void _onAppBarButtonTap(GlobalKey sectionKey) {
    final sectionKeyCurrentContext = sectionKey.currentContext;
    if (sectionKeyCurrentContext != null) {
      Scrollable.ensureVisible(
        sectionKeyCurrentContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }

  Widget _buildLocaleButton(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(languageRepositoryProvider).getLanguages();
    if (languages.length > 1) return const LocaleButton();
    return const SizedBox.shrink();
  }
}

class _MoreNavMenu extends StatelessWidget {
  const _MoreNavMenu({
    required this.onSkills,
    required this.onOpenSource,
    required this.onContract,
  });

  final VoidCallback onSkills;
  final VoidCallback onOpenSource;
  final VoidCallback onContract;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<VoidCallback>(
      tooltip: tr(LocaleKeys.navMoreTooltip),
      onSelected: (action) => action(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: onSkills,
          child: Text(tr(LocaleKeys.skillsSectionTitle)),
        ),
        PopupMenuItem(
          value: onOpenSource,
          child: Text(tr(LocaleKeys.openSourceSectionTitle)),
        ),
        PopupMenuItem(
          value: onContract,
          child: Text(tr(LocaleKeys.contractSectionTitle)),
        ),
      ],
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Text(
              tr(LocaleKeys.navMore),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
