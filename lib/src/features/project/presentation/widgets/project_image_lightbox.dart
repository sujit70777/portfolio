import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Opens a fullscreen gallery for one project's images, starting at
/// [initialIndex]. Backdrop tap, Escape, and the close button all dismiss it;
/// arrow keys / on-screen arrows / swipe all navigate between images.
Future<void> showProjectImageLightbox(
  BuildContext context, {
  required String projectName,
  required List<String> images,
  required int initialIndex,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _ProjectImageLightbox(
        projectName: projectName,
        images: images,
        initialIndex: initialIndex,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class _ProjectImageLightbox extends StatefulWidget {
  const _ProjectImageLightbox({
    required this.projectName,
    required this.images,
    required this.initialIndex,
  });

  final String projectName;
  final List<String> images;
  final int initialIndex;

  @override
  State<_ProjectImageLightbox> createState() => _ProjectImageLightboxState();
}

class _ProjectImageLightboxState extends State<_ProjectImageLightbox> {
  late final _pageController = PageController(initialPage: widget.initialIndex);
  late int _currentIndex = widget.initialIndex;
  final _focusNode = FocusNode();

  bool get _hasMultiple => widget.images.length > 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _prefetchNeighbors(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _prefetchNeighbors(int index) {
    if (!_hasMultiple) return;
    final total = widget.images.length;
    final next = (index + 1) % total;
    final previous = (index - 1 + total) % total;
    for (final i in {next, previous}) {
      precacheImage(AssetImage(widget.images[i]), context);
    }
  }

  void _goTo(int index) {
    final total = widget.images.length;
    _pageController.animateToPage(
      (index + total) % total,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        if (_hasMultiple) _goTo(_currentIndex + 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        if (_hasMultiple) _goTo(_currentIndex - 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 72, 64, 72),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                    _prefetchNeighbors(index);
                  },
                  itemBuilder: (context, index) {
                    return _LightboxImage(path: widget.images[index]);
                  },
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildTopBar(context),
              ),
              if (_hasMultiple) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.chevron_left,
                      tooltip: 'Previous image',
                      onPressed: () => _goTo(_currentIndex - 1),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.chevron_right,
                      tooltip: 'Next image',
                      onPressed: () => _goTo(_currentIndex + 1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _Pill(
                      child: Text(
                        '${_currentIndex + 1} / ${widget.images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Pill(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.projectName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _NavButton(
          icon: Icons.close,
          tooltip: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// A full-size gallery image. Absorbs its own taps (via an empty onTap) so
/// tapping the image doesn't fall through to the barrier and close the
/// lightbox — only the dimmed backdrop around it should do that.
class _LightboxImage extends StatelessWidget {
  const _LightboxImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Center(
        child: Image(
          image: AssetImage(path),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.broken_image_outlined,
            color: Colors.white54,
            size: 48,
          ),
        ),
      ),
    );
  }
}

/// Frosted, theme-independent pill used for lightbox chrome — a photo
/// viewer stays legible over any image regardless of the site's own theme.
class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.alignment = Alignment.center});

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(130),
            borderRadius: BorderRadius.circular(999),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withAlpha(130),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            tooltip: tooltip,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
