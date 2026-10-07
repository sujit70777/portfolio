import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/src/common/utils/fluid_size.dart';
import 'package:portfolio/src/common/widgets/first_paint_entrance.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// The evidence card anchored to the hero — rating, apps, users, years in
/// one composed plaque rather than three flat stat boxes. Design brief 2,
/// content problem #1: make the numbers credible by showing them as one
/// real object, not a landing-page template pattern.
///
/// [columns] is 4 (one row, tablet/desktop) or 2 (a 2×2 grid, mobile — four
/// across becomes unreadable at phone width). [fullWidth] stretches the
/// plaque to fill its parent instead of sizing to its own content.
///
/// Rating star is a local SVG (not U+2605) so CanvasKit never downloads
/// Noto Sans Symbols 2 for a single hero glyph.
const _starAsset = 'assets/icons/other/star.svg';

class HeroStatPlaque extends StatelessWidget {
  const HeroStatPlaque({super.key, this.columns = 4, this.fullWidth = false});

  final int columns;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The single fastest credibility signal on the page — sized to read at
    // a glance rather than the smallest text in the hero.
    final numberSize = fluidSize(
      context,
      min: 20,
      preferredVwPercent: 2.5,
      max: 32,
    );

    // One hue per figure, so the four read as four separate facts at a
    // glance: gold for the star rating, then emerald, cyan, mint.
    // web/index.html colours `.pl-stat b` the same way, in the same order.
    final palette = Palette.of(context);
    final stats = [
      _StatData(
        leadingAsset: _starAsset,
        rawValue: tr(LocaleKeys.stats_rating),
        label: tr(LocaleKeys.stats_ratingLabel),
        color: palette.hues[0],
      ),
      _StatData(
        rawValue: tr(LocaleKeys.stats_apps),
        label: tr(LocaleKeys.stats_appsLabel),
        color: palette.hues[1],
      ),
      _StatData(
        rawValue: tr(LocaleKeys.stats_users),
        label: tr(LocaleKeys.stats_usersLabel),
        color: palette.hues[2],
      ),
      _StatData(
        rawValue: '${tr(LocaleKeys.stats_years)}yr',
        label: tr(LocaleKeys.stats_yearsLabel),
        color: palette.hues[6],
      ),
    ];

    Widget stat(_StatData data) {
      return _Stat(data: data, numberSize: numberSize);
    }

    final Widget content;
    if (columns == 2) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: stat(stats[0])),
              _divider(theme),
              Expanded(child: stat(stats[1])),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: stat(stats[2])),
              _divider(theme),
              Expanded(child: stat(stats[3])),
            ],
          ),
        ],
      );
    } else {
      content = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final (index, data) in stats.indexed) ...[
            fullWidth ? Expanded(child: stat(data)) : stat(data),
            if (index != stats.length - 1) _divider(theme),
          ],
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(90),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: content,
            ),
            // An aurora rule along the top edge, like a lit bezel.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: palette.auroraGradient),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        width: 1,
        height: 24,
        child: ColoredBox(color: theme.colorScheme.onSurface.withAlpha(24)),
      ),
    );
  }
}

class _StatData {
  const _StatData({
    this.leadingAsset,
    required this.rawValue,
    required this.label,
    required this.color,
  });

  final String? leadingAsset;
  final String rawValue;
  final String label;
  final Color color;
}

class _Stat extends StatelessWidget {
  const _Stat({required this.data, required this.numberSize});

  final _StatData data;
  final double numberSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // scaleDown keeps "100K+" (+ star) inside narrow Expanded cells
        // without clipping; no-op when the row already fits.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (data.leadingAsset != null) ...[
                SvgPicture.asset(
                  data.leadingAsset!,
                  width: numberSize * 0.72,
                  height: numberSize * 0.72,
                  colorFilter: ColorFilter.mode(data.color, BlendMode.srcIn),
                ),
                SizedBox(width: numberSize * 0.12),
              ],
              _CountUpValue(
                rawValue: data.rawValue,
                style: monoLabelStyle(fontSize: numberSize, color: data.color),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        SearchableText(
          data.label.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            letterSpacing: 0.04,
            color: mutedTextColor(theme.colorScheme),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

/// Counts up from zero to the numeric lead of [rawValue] once, on first
/// build — e.g. "50+" counts 0→50 then appends the static "+"; "4.7" counts
/// with one decimal place preserved throughout. Runs once only (no repeat
/// on rebuild) and jumps straight to the final value under
/// `prefers-reduced-motion`.
class _CountUpValue extends StatefulWidget {
  const _CountUpValue({required this.rawValue, this.style});

  final String rawValue;
  final TextStyle? style;

  @override
  State<_CountUpValue> createState() => _CountUpValueState();
}

class _CountUpValueState extends State<_CountUpValue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;
  late final double _target;
  late final int _decimals;
  late final String _suffix;

  @override
  void initState() {
    super.initState();
    final match = RegExp(r'^(\d+(\.\d+)?)').firstMatch(widget.rawValue);
    final numStr = match?.group(1) ?? '0';
    _decimals = numStr.contains('.') ? numStr.split('.').last.length : 0;
    _target = double.tryParse(numStr) ?? 0;
    _suffix = widget.rawValue.substring(match?.end ?? 0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAnimating && _controller.value == 0) {
      // Two separate reasons to skip the count and land on the number: the
      // visitor asked for less motion, or the pre-Flutter hero has already
      // shown them these figures. On the phone layout that markup draws this
      // plaque (see web/index.html), so counting up from zero here would take
      // "4.7" the visitor was already reading and wind it back to "0.1".
      if (MediaQuery.disableAnimationsOf(context) ||
          !kAnimateFirstPaintEntrance) {
        _controller.value = 1;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final value = _target * _curve.value;
        return Text(
          '${value.toStringAsFixed(_decimals)}$_suffix',
          style: widget.style,
        );
      },
    );
  }
}
