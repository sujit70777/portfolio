import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// The evidence card anchored to the hero's [DeviceFrame] — rating, apps,
/// users, years in one composed plaque rather than three flat stat boxes.
/// Design brief 2, content problem #1: make the numbers credible by
/// showing them as one real object, not a landing-page template pattern.
class HeroStatPlaque extends StatelessWidget {
  const HeroStatPlaque({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Stat(
              leadingPrefix: '★',
              rawValue: tr(LocaleKeys.stats_rating),
              label: tr(LocaleKeys.stats_ratingLabel),
            ),
            _divider(theme),
            _Stat(
              rawValue: tr(LocaleKeys.stats_apps),
              label: tr(LocaleKeys.stats_appsLabel),
            ),
            _divider(theme),
            _Stat(
              rawValue: tr(LocaleKeys.stats_users),
              label: tr(LocaleKeys.stats_usersLabel),
            ),
            _divider(theme),
            _Stat(
              rawValue: '${tr(LocaleKeys.stats_years)}yr',
              label: tr(LocaleKeys.stats_yearsLabel),
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

class _Stat extends StatelessWidget {
  const _Stat({this.leadingPrefix = '', required this.rawValue, required this.label});

  final String leadingPrefix;
  final String rawValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CountUpValue(
          leadingPrefix: leadingPrefix,
          rawValue: rawValue,
          style: monoLabelStyle(fontSize: 16, color: theme.colorScheme.tertiary),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            letterSpacing: 0.04,
            color: theme.colorScheme.onSurface.withAlpha(180),
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
  const _CountUpValue({this.leadingPrefix = '', required this.rawValue, this.style});

  final String leadingPrefix;
  final String rawValue;
  final TextStyle? style;

  @override
  State<_CountUpValue> createState() => _CountUpValueState();
}

class _CountUpValueState extends State<_CountUpValue> with SingleTickerProviderStateMixin {
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAnimating && _controller.value == 0) {
      if (MediaQuery.disableAnimationsOf(context)) {
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
          '${widget.leadingPrefix}${value.toStringAsFixed(_decimals)}$_suffix',
          style: widget.style,
        );
      },
    );
  }
}
