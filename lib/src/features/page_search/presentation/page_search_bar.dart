import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/page_search/application/page_search_controller.dart';

/// The find-on-page bar: a frosted panel edged in the aurora, with the
/// query, an "n / total" count, previous/next and close — and, on wide
/// screens, a row of key hints, since the people using this are the ones
/// who never take their hands off the keyboard.
///
/// The keys — Enter / Shift+Enter in the field, and Cmd/Ctrl+G, F3 and
/// Esc anywhere — are all handled by PageSearchScope.
class PageSearchBar extends StatefulWidget {
  const PageSearchBar({
    super.key,
    required this.controller,
    this.showKeyHints = true,
  });

  final PageSearchController controller;
  final bool showKeyHints;

  @override
  State<PageSearchBar> createState() => _PageSearchBarState();
}

class _PageSearchBarState extends State<PageSearchBar>
    with SingleTickerProviderStateMixin {
  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 150),
  );
  late final _curve = CurvedAnimation(
    parent: _animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  final _text = TextEditingController();
  int _seenFocusRequest = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    _animation.addStatusListener((_) => setState(() {}));
  }

  @override
  void didUpdateWidget(PageSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller.removeListener(_onSearchChanged);
      widget.controller.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    _animation.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final controller = widget.controller;
    final opening = controller.isOpen;
    final shown =
        _animation.status == AnimationStatus.forward ||
        _animation.status == AnimationStatus.completed;

    if (opening && !shown) {
      if (MediaQuery.disableAnimationsOf(context)) {
        _animation.value = 1;
      } else {
        _animation.forward();
      }
    } else if (!opening && shown) {
      controller.inputFocus.unfocus();
      if (MediaQuery.disableAnimationsOf(context)) {
        _animation.value = 0;
      } else {
        _animation.reverse();
      }
    }

    if (controller.focusRequest != _seenFocusRequest) {
      _seenFocusRequest = controller.focusRequest;
      // After the frame that builds the field. Like a browser, reopening
      // brings back the last query, selected, so typing replaces it and
      // Enter searches it again.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !controller.isOpen) return;
        controller.inputFocus.requestFocus();
        _text.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _text.text.length,
        );
        controller.updateQuery(_text.text);
      });
    }
    setState(() {});
  }

  /// A click on an arrow leaves the typing focus in the field, so the next
  /// Enter keeps searching.
  void _stepAndRefocus(VoidCallback step) {
    step();
    widget.controller.inputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation.isDismissed) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = Palette.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = widget.controller;
    final muted = mutedTextColor(scheme);

    final hasQuery = controller.query.isNotEmpty;
    final count = controller.matchCount;
    final noMatches = hasQuery && count == 0;
    final coral = palette.hue(3);
    final accent = noMatches ? coral : scheme.tertiary;

    final countLabel = !hasQuery
        ? ''
        : noMatches
        ? 'No matches'
        : '${controller.currentIndex + 1} / $count';

    final field = TextField(
      controller: _text,
      focusNode: controller.inputFocus,
      onChanged: controller.updateQuery,
      // Enter steps through matches (see PageSearchScope); this is here only
      // so the browser's "submit" that comes with it doesn't unfocus the
      // field.
      onEditingComplete: () {},
      textInputAction: TextInputAction.search,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: accent,
      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      decoration: InputDecoration(
        isCollapsed: true,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        hintText: 'Find on this page',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withAlpha(120),
        ),
      ),
    );

    final searchRow = Row(
      children: [
        const SizedBox(width: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            noMatches ? Icons.search_off_rounded : Icons.search_rounded,
            key: ValueKey(noMatches),
            size: 20,
            color: accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: field),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 140),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            countLabel,
            key: ValueKey(countLabel),
            style: monoLabelStyle(
              fontSize: 12,
              color: noMatches ? coral : muted,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 1, height: 22, color: scheme.onSurface.withAlpha(30)),
        const SizedBox(width: 4),
        _BarButton(
          icon: Icons.keyboard_arrow_up_rounded,
          tooltip: 'Previous match (Shift+Enter)',
          onPressed: count > 0
              ? () => _stepAndRefocus(controller.previous)
              : null,
        ),
        _BarButton(
          icon: Icons.keyboard_arrow_down_rounded,
          tooltip: 'Next match (Enter)',
          onPressed: count > 0 ? () => _stepAndRefocus(controller.next) : null,
        ),
        _BarButton(
          icon: Icons.close_rounded,
          tooltip: 'Close (Esc)',
          onPressed: controller.close,
        ),
        const SizedBox(width: 6),
      ],
    );

    final hints = Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 9),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.onSurface.withAlpha(20))),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        children: const [
          _KeyHint(keys: ['Enter'], action: 'next'),
          _KeyHint(keys: ['Shift', 'Enter'], action: 'previous'),
          _KeyHint(keys: ['Esc'], action: 'close'),
        ],
      ),
    );

    final panel = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      // The 1.2px of padding is the border: the gradient showing through
      // around the frosted panel.
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: noMatches
              ? [coral, coral.withAlpha(110)]
              : [for (final c in palette.aurora) c.withAlpha(210)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 130 : 38),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: accent.withAlpha(palette.glowAlpha ~/ 2),
            blurRadius: 28,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: ColoredBox(
            color: scheme.primary.withAlpha(isDark ? 225 : 238),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [searchRow, if (widget.showKeyHints) hints],
            ),
          ),
        ),
      ),
    );

    return ExcludeFocus(
      excluding: !controller.isOpen,
      child: IgnorePointer(
        ignoring: !controller.isOpen,
        child: FadeTransition(
          opacity: _curve,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, -0.18),
              end: Offset.zero,
            ).animate(_curve),
            child: ScaleTransition(
              scale: Tween(begin: 0.97, end: 1.0).animate(_curve),
              alignment: Alignment.topRight,
              child: Semantics(
                container: true,
                label: 'Find on this page',
                child: Material(type: MaterialType.transparency, child: panel),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Never takes keyboard focus: a clicked button that kept it would
    // swallow the next Enter as a press of itself, and Shift+Enter could
    // then only ever repeat that button.
    return ExcludeFocus(child: _button(scheme));
  }

  Widget _button(ColorScheme scheme) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 22,
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      color: scheme.onSurface,
      disabledColor: scheme.onSurface.withAlpha(70),
      style: IconButton.styleFrom(
        hoverColor: scheme.tertiary.withAlpha(30),
        highlightColor: scheme.tertiary.withAlpha(45),
      ),
    );
  }
}

/// "[Shift] [Enter] previous" — keycaps in the mono face, then what they do.
class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.keys, required this.action});

  final List<String> keys;
  final String action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = mutedTextColor(scheme);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final key in keys) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.onSurface.withAlpha(14),
              borderRadius: BorderRadius.circular(5),
              // A heavier bottom edge, like a physical key. One colour all
              // round: Flutter only rounds borders whose sides match.
              border: Border(
                top: BorderSide(color: scheme.onSurface.withAlpha(50)),
                left: BorderSide(color: scheme.onSurface.withAlpha(50)),
                right: BorderSide(color: scheme.onSurface.withAlpha(50)),
                bottom: BorderSide(
                  color: scheme.onSurface.withAlpha(50),
                  width: 2,
                ),
              ),
            ),
            child: Text(key, style: monoLabelStyle(fontSize: 10, color: muted)),
          ),
          const SizedBox(width: 4),
        ],
        const SizedBox(width: 2),
        Text(action, style: monoLabelStyle(fontSize: 11, color: muted)),
      ],
    );
  }
}
