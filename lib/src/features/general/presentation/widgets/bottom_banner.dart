import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Slides up once the visitor reaches the end of the page, pointing at the
/// repository this site is built from.
class BottomBanner extends ConsumerStatefulWidget {
  const BottomBanner({super.key});

  @override
  ConsumerState<BottomBanner> createState() => _BottomBannerState();
}

class _BottomBannerState extends ConsumerState<BottomBanner> {
  static const _bannerHeight = kBottomNavigationBarHeight;

  /// How close to the bottom of the page the visitor has to be, in pixels,
  /// before the banner reveals itself.
  static const _revealThreshold = 64.0;

  static const _iconSize = 18.0;
  static const _flutterLogoAsset = 'assets/icons/flutter.svg';

  final _linkRecognizer = TapGestureRecognizer();
  ScrollController? _scrollController;
  bool _isVisible = false;
  bool _isLinkHovered = false;

  @override
  void initState() {
    super.initState();
    _linkRecognizer.onTap = _openRepository;
    _scrollController = ref.read(scrollControllerProvider)!
      ..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _linkRecognizer.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;

    final position = controller.position;
    if (!position.hasPixels || !position.hasContentDimensions) return;

    final shouldBeVisible =
        position.pixels >= position.maxScrollExtent - _revealThreshold;

    // Scroll fires on every frame; only rebuild when the state actually flips.
    if (shouldBeVisible == _isVisible) return;
    setState(() => _isVisible = shouldBeVisible);
  }

  void _setLinkHovered(bool value) {
    if (value == _isLinkHovered) return;
    setState(() => _isLinkHovered = value);
  }

  Future<void> _openRepository() async {
    final url = tr(LocaleKeys.bottomBanner_linkUrl);
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = colorScheme.onSecondary;
    final textStyle = Theme.of(
      context,
    ).textTheme.titleSmall!.copyWith(color: foreground);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      width: double.maxFinite,
      height: _isVisible ? _bannerHeight : 0,
      color: colorScheme.secondary,
      // The content keeps its full height while the container animates, so the
      // row slides in behind the clip instead of squashing and overflowing.
      child: ClipRect(
        child: OverflowBox(
          minHeight: _bannerHeight,
          maxHeight: _bannerHeight,
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: textStyle,
            child: MySelectionArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _buildLogo(foreground),
                        ),
                        TextSpan(
                          text: '  ${tr(LocaleKeys.bottomBanner_message)} ',
                        ),
                        TextSpan(
                          text: tr(LocaleKeys.bottomBanner_displayLink),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: foreground,
                            decorationThickness: _isLinkHovered ? 2 : 1,
                          ),
                          mouseCursor: SystemMouseCursors.click,
                          recognizer: _linkRecognizer,
                          onEnter: (_) => _setLinkHovered(true),
                          onExit: (_) => _setLinkHovered(false),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _buildLinkArrow(foreground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tinted to [foreground] rather than Flutter blue, so it sits on the
  /// secondary background in both themes. Drop the [ColorFilter] for brand
  /// colours instead.
  Widget _buildLogo(Color foreground) {
    return ExcludeSemantics(
      child: SvgPicture.asset(
        _flutterLogoAsset,
        height: _iconSize,
        colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
      ),
    );
  }

  /// Nudges outward on hover, the way an external-link arrow should.
  Widget _buildLinkArrow(Color foreground) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        offset: _isLinkHovered ? const Offset(0.15, -0.15) : Offset.zero,
        child: Icon(
          Icons.arrow_outward,
          size: _iconSize - 2,
          color: foreground,
        ),
      ),
    );
  }
}
