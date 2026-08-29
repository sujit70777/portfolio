import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/utils/fluid_size.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';
import 'package:portfolio/src/common/widgets/device_frame.dart';
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

/// Hero entrance: each line fades up ~20px in sequence, ~80ms apart, total
/// well under 800ms — quick on purpose, since a slow entrance is only
/// charming once and annoying on every repeat visit.
Widget _entrance(int step, Widget child) {
  return AnimatedFadeSlide(
    delay: Duration(milliseconds: 80 * step),
    duration: const Duration(milliseconds: 280),
    offset: const Offset(0, 20),
    child: child,
  );
}

/// The hero screenshot — Peace of Mind's Picture Bank map view. Curated,
/// not derived from the folder-listing provider: the hero is the site's
/// single most prominent image, so it's pinned by hand rather than
/// picking up whatever sorts first alphabetically. Previously showed
/// Tanto; that client's business closed and its UI can no longer be
/// featured here.
const _heroImagePath =
    'assets/projectimage/peace-of-mind-pom/img_picture_bank_demo_9.webp';
const _heroImageAlt =
    'Peace of Mind app — Picture Bank map view showing geotagged photo collections';

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
///   title and the buttons pushes CTAs below the fold. The phone
///   screenshot moves last and lazy-loads, since it's the heaviest asset
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
          Text(
            tr(LocaleKeys.name),
            style: textTheme.displayLarge?.copyWith(fontSize: nameSize),
          ),
        ),
        gapH8,
        _entrance(
          3,
          Text(
            tr(LocaleKeys.description),
            style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
          ),
        ),
        gapH12,
        _entrance(4, _LocationLine()),
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
              if (whatsappUrl != null)
                _HeroCta.secondary(
                    label: tr(LocaleKeys.heroSecondaryCta), url: whatsappUrl!),
              if (resumes.isNotEmpty) ResumeButton(resumes: resumes.cast()),
            ],
          ),
        ),
      ],
    );

    final right = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _entrance(2, const _HeroDevice(width: 230)),
        gapH20,
        _entrance(3, const HeroStatPlaque()),
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
                    child: Text(
                      tr(LocaleKeys.name),
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
              Text(
                tr(LocaleKeys.description),
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
              ),
            ),
            gapH8,
            _entrance(3, _LocationLine()),
            gapH24,
            _entrance(
              4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (emailUrl != null)
                    _HeroCta.primary(
                        label: tr(LocaleKeys.heroPrimaryCta), url: emailUrl!),
                  if (whatsappUrl != null) ...[
                    gapW16,
                    _HeroCta.secondary(
                        label: tr(LocaleKeys.heroSecondaryCta),
                        url: whatsappUrl!),
                  ],
                ],
              ),
            ),
            if (resumes.isNotEmpty) ...[
              gapH12,
              _entrance(5, ResumeButton(resumes: resumes.cast())),
            ],
            gapH40,
            _entrance(6, const _HeroDevice(width: 138)),
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
                child: Text(
                  tr(LocaleKeys.name),
                  style: textTheme.displayMedium?.copyWith(fontSize: nameSize),
                ),
              ),
            ],
          ),
        ),
        gapH12,
        _entrance(
          2,
          Text(
            tr(LocaleKeys.description),
            style: textTheme.titleLarge?.copyWith(fontSize: titleSize),
          ),
        ),
        gapH8,
        _entrance(3, _LocationLine()),
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
              if (whatsappUrl != null) ...[
                gapH12,
                _HeroCta.secondary(
                    label: tr(LocaleKeys.heroSecondaryCta),
                    url: whatsappUrl!,
                    fullWidth: true),
              ],
              if (resumes.isNotEmpty) ...[
                gapH16,
                Center(child: ResumeButton(resumes: resumes.cast())),
              ],
            ],
          ),
        ),
        gapH32,
        // Heaviest asset, least important thing on a phone — last in the
        // order and lazy-loaded.
        _entrance(6, Center(child: const _HeroDevice(width: 200, lazy: true))),
      ],
    );
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine();

  @override
  Widget build(BuildContext context) {
    return Text(
      tr(LocaleKeys.subDescription).toUpperCase(),
      textAlign: TextAlign.center,
      style: monoLabelStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
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
    final width = widget.width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final height = width / DeviceFrame.aspectRatio;
    final theme = Theme.of(context);
    final showImage = !widget.lazy || _isNearViewport;

    final Widget screen = showImage
        ? Image.asset(
            _heroImagePath,
            fit: BoxFit.cover,
            cacheWidth: (width * dpr).round(),
            cacheHeight: (height * dpr).round(),
            semanticLabel: _heroImageAlt,
          )
        : ColoredBox(color: theme.colorScheme.secondaryContainer);

    return DeviceFrame(width: width, screen: screen);
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
      return FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.tertiary),
          foregroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          minimumSize: minimumSize,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          ),
          textStyle: WidgetStatePropertyAll(
            theme.textTheme.labelLarge,
          ),
        ),
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
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }
}
