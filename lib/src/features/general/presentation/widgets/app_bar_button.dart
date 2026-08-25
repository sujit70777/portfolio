import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarButton extends ConsumerStatefulWidget {
  const AppBarButton({super.key, this.onPressed, required this.title});

  final VoidCallback? onPressed;
  final String title;

  @override
  ConsumerState<AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends ConsumerState<AppBarButton> {
  bool _isHovered = false;
  void _hoverOn() => setState(() => _isHovered = true);
  void _hoverOff() => setState(() => _isHovered = false);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.tertiary;
    return MouseRegion(
      onEnter: (_) => _hoverOn(),
      onExit: (_) => _hoverOff(),
      child: MaterialButton(
        hoverColor: Colors.transparent,
        splashColor: accentColor.withAlpha(40),
        shape: const Border(),
        onPressed: widget.onPressed,
        child: SizedBox(
          height: kToolbarHeight,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: _isHovered
                            ? accentColor
                            : Theme.of(context).textTheme.titleMedium?.color,
                      ),
                  child: Text(widget.title),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  height: 2,
                  width: _isHovered ? 20 : 0,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
