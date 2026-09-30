import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/palette.dart';

/// The site's primary call to action: a stadium button filled with the
/// palette's button gradient that lifts and glows on hover.
///
/// Built on [FilledButton] with a transparent fill so it keeps every bit of
/// Material's button behaviour — focus ring, keyboard activation, button
/// semantics, the disabled state — and only the paint underneath changes.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
    this.minimumSize = Size.zero,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final TextStyle? textStyle;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final theme = Theme.of(context);
    final enabled = widget.onPressed != null;
    final lifted = _hovered && enabled;

    final style = ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(palette.onAurora),
      iconColor: WidgetStatePropertyAll(palette.onAurora),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return palette.onAurora.withAlpha(40);
        }
        if (states.contains(WidgetState.focused)) {
          return palette.onAurora.withAlpha(24);
        }
        return Colors.transparent;
      }),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      minimumSize: WidgetStatePropertyAll(widget.minimumSize),
      padding: WidgetStatePropertyAll(widget.padding),
      textStyle:
          WidgetStatePropertyAll(widget.textStyle ?? theme.textTheme.labelLarge),
    );

    final button = widget.icon == null
        ? FilledButton(
            style: style,
            onPressed: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            child: widget.child,
          )
        : FilledButton.icon(
            style: style,
            onPressed: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            icon: widget.icon,
            label: widget.child,
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, lifted ? -2 : 0, 0),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        gradient: LinearGradient(
          colors: palette.button,
          // Hover swings the gradient round so the colours visibly move
          // under the cursor, not just brighten.
          begin: lifted ? Alignment.centerRight : Alignment.centerLeft,
          end: lifted ? Alignment.centerLeft : Alignment.centerRight,
        ),
        shadows: [
          BoxShadow(
            color: palette.button.last.withAlpha(
              lifted ? palette.glowAlpha + 40 : palette.glowAlpha ~/ 2,
            ),
            blurRadius: lifted ? 24 : 12,
            offset: Offset(0, lifted ? 8 : 4),
          ),
        ],
      ),
      child: Opacity(opacity: enabled ? 1 : 0.5, child: button),
    );
  }
}
