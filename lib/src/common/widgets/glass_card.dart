import 'package:flutter/material.dart';

/// The site's card surface (About, Notes; the skills and experience cards
/// draw the same look inline): a wash of [hue] from the top-left corner, a
/// tinted border, and — on hover — a lift and a glow in the same colour.
/// With [accent] set it also gets the experience cards' lit left edge; with
/// [onTap] the whole card is a button.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.hue,
    required this.child,
    this.accent,
    this.onTap,
    this.semanticLabel,
    this.padding = const EdgeInsets.all(20),
    this.hoverLift = true,
  });

  /// Off for a card that holds a form (Fit check): a surface you're typing
  /// into shouldn't rise and glow every time the pointer crosses it.
  final bool hoverLift;

  final Color hue;
  final Widget child;

  /// Colours of the left accent edge, top to bottom; null for no edge.
  final List<Color>? accent;
  final VoidCallback? onTap;

  /// Read by screen readers in place of the card's text when [onTap] is
  /// set, so a card is announced as one button rather than every line.
  final String? semanticLabel;
  final EdgeInsets padding;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  static const _radius = 20.0;
  static const _accentWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hue = widget.hue;
    final accent = widget.accent;
    final padding = accent == null
        ? widget.padding
        : widget.padding.copyWith(left: widget.padding.left + _accentWidth);

    Widget content = Padding(padding: padding, child: widget.child);
    if (widget.onTap != null) {
      content = Semantics(
        button: true,
        label: widget.semanticLabel,
        excludeSemantics: widget.semanticLabel != null,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            splashColor: hue.withAlpha(30),
            highlightColor: hue.withAlpha(20),
            child: content,
          ),
        ),
      );
    }

    final lit = _hovered && widget.hoverLift;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, lit ? -4 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(
                hue.withAlpha(lit ? 34 : 22),
                theme.colorScheme.primary,
              ),
              theme.colorScheme.primary,
            ],
            stops: const [0, 0.7],
          ),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: hue.withAlpha(lit ? 150 : 70),
            width: lit ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: hue.withAlpha(lit ? 40 : 0),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Stack(
            children: [
              content,
              if (accent != null)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: _accentWidth,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: accent,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
