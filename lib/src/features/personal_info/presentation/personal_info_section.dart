import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/utils/fluid_size.dart';
import 'package:portfolio/src/common/widgets/aurora_text.dart';
import 'package:portfolio/src/common/widgets/gradient_button.dart';
import 'package:portfolio/src/common/widgets/first_paint_entrance.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/about/presentation/widgets/profile_photo.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/availability_badge.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/hero_background.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/hero_stat_plaque.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_button.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// Hero entrance: each line fades up ~20px in sequence, ~80ms apart, total
/// well under 800ms — quick on purpose, since a slow entrance is only
/// charming once and annoying on every repeat visit.
Widget _entrance(int step, Widget child) {
  return FirstPaintEntrance(
    delay: Duration(milliseconds: 80 * step),
    duration: const Duration(milliseconds: 280),
    offset: const Offset(0, 20),
    child: child,
  );
}

/// The hero image — Finora, a personal-finance app, shown across laptop,
/// tablet and phone. Curated, not derived from the folder-listing provider:
/// the hero is the site's single most prominent image, so it's pinned by
/// hand, and it lives in assets/images/ so it doesn't also show up in any
/// project gallery. Unlike the old single-phone screenshot, this mockup
/// already has its device bezels baked in (on a transparent background), so
/// it's drawn as-is rather than inside `DeviceFrame`.
///
/// Cropped to its opaque bounds; [_heroImageAspectRatio] must track the
/// file's pixel size (960x690).
const _heroImagePath = 'assets/images/hero_finora_devices.webp';
const _heroImageAspectRatio = 960 / 690;
const _heroImageAlt =
    'Finora personal-finance app on laptop, tablet and phone — balance, '
    'income and expenses, recent transactions and spending by category';

/// The hero — design brief 2's signature moment, restructured per an
/// explicit responsive spec (three genuinely different layouts, not one
/// layout scaled down):
///
/// - Desktop (≥1024): two columns ~55/45 — identity/CTAs left, device +
///   stats right. A 72px photo, inline above the name, not a portrait.
/// - Tablet (640–1023): single centred column, max 640px wide. Photo and
///   name share a row; stats run full-width, still 4 across.
/// - Mobile (<640): stats move up ahead of the CTAs — a visitor needs a
///   reason to care before tapping anything, and a big image between the
///   title and the buttons pushes CTAs below the fold. The device
///   mockup moves last and lazy-loads, since it's the heaviest asset
///   and the least important thing on a phone.
class PersonalInfoSection extends ConsumerWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    final emailContact = contacts.firstWhereOrNull(
      (c) => c.url?.startsWith('mailto:') == true,
    );
    final whatsappContact = contacts.firstWhereOrNull(
      (c) => c.url?.contains('wa.me') == true,
    );
    final emailUrl = emailContact?.url;
    final whatsappUrl = whatsappContact?.url;

    final Widget content;
    if (Responsive.isMobile(context)) {
      content = _MobileHero(
        emailUrl: emailUrl,
        whatsappUrl: whatsappUrl,
        resumes: resumes,
      );
    } else if (Responsive.isTablet(context)) {
      content = _TabletHero(
        emailUrl: emailUrl,
        whatsappUrl: whatsappUrl,
        resumes: resumes,
      );
    } else {
      content = _DesktopHero(
        emailUrl: emailUrl,
        whatsappUrl: whatsappUrl,
        resumes: resumes,
      );
    }

    return Stack(
      // The backdrop's light deliberately spills past the hero's box.
      clipBehavior: Clip.none,
      children: [
        const HeroBackground(),
        content,
      ],
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero(
      {required this.emailUrl,
      required this.whatsappUrl,
      required this.resumes});

  final String? emailUrl;
  final String? whatsappUrl;
  final List<dynamic> resumes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameSize =
        fluidSize(context, min: 32, preferredVwPercent: 5, max: 56);
    final titleSize =
        fluidSize(context, min: 16, preferredVwPercent: 2, max: 21.6);

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _entrance(0, const AvailabilityBadge()),
        gapH20,
        // 72px, inline immediately above the name — an identity marker,
        // not a portrait.
        _entrance(1, const ProfilePhoto(size: 72)),
        gapH16,
        _entrance(
          2,
          AuroraText(
            tr(LocaleKeys.name),
            flowing: true,
            style: textTheme.displayLarge?.copyWith(fontSize: nameSize),
          ),
        ),
        gapH8,
        _entrance(
          3,
          SearchableText(
            tr(LocaleKeys.description),
            style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
          ),
        ),
        gapH12,
        _entrance(4, _LocationLine()),
        gapH12,
        _entrance(4, const _ContractBadge()),
        const SizedBox(height: 28),
        _entrance(
          5,
          Wrap(
            spacing: 18,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (emailUrl != null)
                _HeroCta.primary(
                    label: tr(LocaleKeys.heroPrimaryCta), url: emailUrl!),
              if (resumes.isNotEmpty) ResumeButton(resumes: resumes.cast()),
              if (whatsappUrl != null)
                _HeroCta.secondary(
                    label: tr(LocaleKeys.heroSecondaryCta), url: whatsappUrl!),
            ],
          ),
        ),
      ],
    );

    final right = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _entrance(2, const _HeroDevice(width: 460)),
        gapH20,
        _entrance(3, const HeroStatPlaque(fullWidth: true)),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 55, child: left),
        gapW40,
        Expanded(flex: 45, child: Center(child: right)),
      ],
    );
  }
}

class _TabletHero extends StatelessWidget {
  const _TabletHero(
      {required this.emailUrl,
      required this.whatsappUrl,
      required this.resumes});

  final String? emailUrl;
  final String? whatsappUrl;
  final List<dynamic> resumes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameSize =
        fluidSize(context, min: 32, preferredVwPercent: 5, max: 56);
    final titleSize =
        fluidSize(context, min: 16, preferredVwPercent: 2, max: 21.6);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _entrance(0, const AvailabilityBadge()),
            gapH20,
            // Photo and name share a row at this width; the name is free
            // to wrap to two lines.
            _entrance(
              1,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProfilePhoto(size: 64),
                  gapW16,
                  Expanded(
                    child: AuroraText(
                      tr(LocaleKeys.name),
                      flowing: true,
                      style:
                          textTheme.displayLarge?.copyWith(fontSize: nameSize),
                    ),
                  ),
                ],
              ),
            ),
            gapH16,
            _entrance(
              2,
              SearchableText(
                tr(LocaleKeys.description),
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
              ),
            ),
            gapH8,
            _entrance(3, _LocationLine()),
            gapH12,
            _entrance(3, const _ContractBadge()),
            gapH24,
            _entrance(
              4,
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  if (emailUrl != null)
                    _HeroCta.primary(
                        label: tr(LocaleKeys.heroPrimaryCta), url: emailUrl!),
                  if (resumes.isNotEmpty)
                    ResumeButton(resumes: resumes.cast()),
                  if (whatsappUrl != null)
                    _HeroCta.secondary(
                        label: tr(LocaleKeys.heroSecondaryCta),
                        url: whatsappUrl!),
                ],
              ),
            ),
            gapH40,
            _entrance(6, const _HeroDevice(width: 420)),
            gapH24,
            _entrance(7, const HeroStatPlaque(fullWidth: true)),
          ],
        ),
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero(
      {required this.emailUrl,
      required this.whatsappUrl,
      required this.resumes});

  final String? emailUrl;
  final String? whatsappUrl;
  final List<dynamic> resumes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameSize =
        fluidSize(context, min: 32, preferredVwPercent: 5, max: 56);
    final titleSize =
        fluidSize(context, min: 16, preferredVwPercent: 2, max: 21.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _entrance(0, const AvailabilityBadge()),
        gapH16,
        _entrance(
          1,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePhoto(size: 56),
              gapW12,
              Expanded(
                child: AuroraText(
                  tr(LocaleKeys.name),
                  flowing: true,
                  style: textTheme.displayMedium?.copyWith(fontSize: nameSize),
                ),
              ),
            ],
          ),
        ),
        gapH12,
        _entrance(
          2,
          SearchableText(
            tr(LocaleKeys.description),
            style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
          ),
        ),
        gapH8,
        _entrance(3, _LocationLine()),
        gapH12,
        _entrance(3, const _ContractBadge()),
        gapH24,
        // Stats before CTAs: a visitor needs a reason to care before
        // they'll tap anything.
        _entrance(4, const HeroStatPlaque(columns: 2, fullWidth: true)),
        gapH24,
        _entrance(
          5,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (emailUrl != null)
                _HeroCta.primary(
                    label: tr(LocaleKeys.heroPrimaryCta),
                    url: emailUrl!,
                    fullWidth: true),
              if (resumes.isNotEmpty) ...[
                gapH12,
                ResumeButton(resumes: resumes.cast(), fullWidth: true),
              ],
              if (whatsappUrl != null) ...[
                gapH12,
                _HeroCta.secondary(
                    label: tr(LocaleKeys.heroSecondaryCta),
                    url: whatsappUrl!,
                    fullWidth: true),
              ],
            ],
          ),
        ),
        gapH32,
        // Heaviest asset, least important thing on a phone — last in the
        // order and lazy-loaded.
        _entrance(6, Center(child: const _HeroDevice(width: 360, lazy: true))),
      ],
    );
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine();

  @override
  Widget build(BuildContext context) {
    return SearchableText(
      tr(LocaleKeys.subDescription).toUpperCase(),
      textAlign: TextAlign.center,
      style: monoLabelStyle(
        fontSize: 12,
        color: mutedTextColor(Theme.of(context).colorScheme),
      ),
    );
  }
}

/// Removes the "overseas hire = payroll/tax headache" objection up front,
/// right under the location line, rather than leaving it to the last
/// sentence of the About copy. Outlined pill so it reads as a fact/badge,
/// not another button.
class _ContractBadge extends StatelessWidget {
  const _ContractBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.onSurface.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 14, color: scheme.tertiary),
          gapW8,
          Flexible(
            child: SearchableText(
              tr(LocaleKeys.contractBadge).toUpperCase(),
              style: monoLabelStyle(
                fontSize: 11,
                letterSpacing: 0.06,
                color: mutedTextColor(scheme),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDevice extends ConsumerStatefulWidget {
  const _HeroDevice({required this.width, this.lazy = false});

  final double width;
  final bool lazy;

  @override
  ConsumerState<_HeroDevice> createState() => _HeroDeviceState();
}

class _HeroDeviceState extends ConsumerState<_HeroDevice> {
  bool _isNearViewport = false;
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.lazy) {
      // The hero screenshot is this page's LCP element on desktop/tablet —
      // warm the decode cache immediately rather than waiting for
      // Image.asset's own on-demand load.
      precacheImage(const AssetImage(_heroImagePath), context);
      return;
    }
    // On mobile the screenshot is last in the order and genuinely lazy:
    // only decode once it's actually near the viewport.
    final controller = ref.read(scrollControllerProvider);
    if (!identical(controller, _scrollController)) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller..addListener(_checkVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (_isNearViewport || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (top <= screenHeight + 600) {
      setState(() => _isNearViewport = true);
      precacheImage(const AssetImage(_heroImagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // [widget.width] is a cap — the column may be narrower than that.
      final width = math.min(widget.width, constraints.maxWidth);
      final height = width / _heroImageAspectRatio;
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final showImage = !widget.lazy || _isNearViewport;

      return SizedBox(
        width: width,
        height: height,
        child: showImage
            ? Image.asset(
                _heroImagePath,
                fit: BoxFit.contain,
                cacheWidth: (width * dpr).round(),
                semanticLabel: _heroImageAlt,
              )
            : null,
      );
    });
  }
}

class _HeroCta extends StatelessWidget {
  const _HeroCta.primary(
      {required this.label, required this.url, this.fullWidth = false})
      : _isPrimary = true;

  const _HeroCta.secondary(
      {required this.label, required this.url, this.fullWidth = false})
      : _isPrimary = false;

  final String label;
  final String url;
  final bool fullWidth;
  final bool _isPrimary;

  // Every interactive element at least 44x44 on mobile.
  static const _minTouchHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minimumSize = WidgetStatePropertyAll(
      Size(fullWidth ? double.infinity : 0, fullWidth ? _minTouchHeight : 0),
    );
    if (_isPrimary) {
      return GradientButton(
        minimumSize: minimumSize.value,
        onPressed: () => _onTap(context),
        child: Text(label),
      );
    }
    return OutlinedButton(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            width: states.contains(WidgetState.hovered) ? 2 : 1,
            color: states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurface.withAlpha(60),
          );
        }),
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        minimumSize: minimumSize,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        ),
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
      ),
      onPressed: () => _onTap(context),
      child: Text(label),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    const mailto = 'mailto:';
    if (url.startsWith(mailto)) {
      try {
        // Same tab: a mailto opened in a new one leaves a blank tab behind
        // in browsers that hand it straight to a mail app.
        await LaunchUrlHelper.launchURL(url, openInNewTab: false);
      } catch (_) {
        // The fallback below covers this too.
      }
      if (context.mounted) {
        ScaffoldMessengerHelper.showEmailFallback(
          context,
          email: url.substring(mailto.length).split('?').first,
        );
      }
      return;
    }
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }
}
