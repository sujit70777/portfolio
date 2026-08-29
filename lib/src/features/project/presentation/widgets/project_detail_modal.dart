import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/technology_wrap_chips.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/empty_project_placeholder.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_status_badge.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Opens the full project detail modal — image gallery, status, full
/// description, tech chips, role, and a "visit project" CTA. Used by both
/// the featured grid cards and the "more shipped work" rows so every
/// project (shipped or in development, with or without a live URL) has the
/// same place to be seen in full rather than jumping straight offsite.
Future<void> showProjectDetailModal(BuildContext context,
    {required Project project}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black87,
    transitionDuration:
        reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ProjectDetailModal(project: project);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class ProjectDetailModal extends ConsumerStatefulWidget {
  const ProjectDetailModal({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<ProjectDetailModal> createState() => _ProjectDetailModalState();
}

class _ProjectDetailModalState extends ConsumerState<ProjectDetailModal> {
  final _focusNode = FocusNode();
  int _currentIndex = 0;
  List<String> _images = const [];

  // Populated lazily per image so the gallery box can match each
  // screenshot's real proportions instead of forcing every image (most of
  // which are portrait phone screenshots) into one fixed landscape box and
  // cropping them.
  final Map<int, double> _aspectRatios = {};
  final Set<int> _resolvingIndices = {};

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _resolveAspectRatio(int index) {
    if (index < 0 ||
        index >= _images.length ||
        _aspectRatios.containsKey(index) ||
        !_resolvingIndices.add(index)) {
      return;
    }
    final stream = AssetImage(_images[index]).resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener((info, _) {
      stream.removeListener(listener);
      if (!mounted) return;
      final width = info.image.width;
      final height = info.image.height;
      if (height > 0) {
        setState(() => _aspectRatios[index] = width / height);
      }
    }, onError: (_, __) => stream.removeListener(listener));
    stream.addListener(listener);
  }

  void _prefetchNeighbors(int index) {
    if (_images.length < 2) return;
    final total = _images.length;
    final next = (index + 1) % total;
    final previous = (index - 1 + total) % total;
    for (final i in {next, previous}) {
      precacheImage(AssetImage(_images[i]), context);
      _resolveAspectRatio(i);
    }
  }

  // Index-based cross-fade rather than a PageView slide — swipe still
  // navigates (via the gallery's drag detector), it just triggers this same
  // fade instead of a physical drag-following page turn.
  void _goTo(int index) {
    final total = _images.length;
    if (total == 0) return;
    final next = (index + total) % total;
    setState(() => _currentIndex = next);
    _resolveAspectRatio(next);
    _prefetchNeighbors(next);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        if (_images.length > 1) _goTo(_currentIndex + 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        if (_images.length > 1) _goTo(_currentIndex - 1);
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
    final project = widget.project;
    final projectName = project.name ?? '';
    _images = project.screenshotPath != null
        ? [project.screenshotPath!]
        : ref.watch(projectImagesProvider(projectName)).maybeWhen(
              data: (value) => value,
              orElse: () => const <String>[],
            );
    if (_images.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _resolveAspectRatio(_currentIndex);
      });
    }

    final isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);

    final content = Material(
      color: theme.colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      borderRadius: isDesktop ? BorderRadius.circular(20) : BorderRadius.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(project: project, onClose: () => Navigator.of(context).pop()),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_images.isNotEmpty)
                    _Gallery(
                      images: _images,
                      currentIndex: _currentIndex,
                      aspectRatio: _aspectRatios[_currentIndex],
                      onNavigate: _goTo,
                      placeholder: EmptyProjectPlaceholder(project: project),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.description ?? '',
                            style: theme.textTheme.bodyLarge),
                        if (project.role != null) ...[
                          gapH16,
                          Text(
                            'My role',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(160),
                            ),
                          ),
                          gapH4,
                          Text(project.role!,
                              style: theme.textTheme.bodyMedium),
                        ],
                        if (project.technologies?.isNotEmpty == true) ...[
                          gapH16,
                          TechnologyWrapChips(
                              technologies: project.technologies!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ActionBar(
              url: project.url, onClose: () => Navigator.of(context).pop()),
        ],
      ),
    );

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: isDesktop
              ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 860,
                      maxHeight: MediaQuery.sizeOf(context).height * 0.88,
                    ),
                    child: content,
                  ),
                )
              : content,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.project, required this.onClose});

  final Project project;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  project.name ?? '',
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                gapH4,
                ProjectStatusBadge(status: project.status),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.images,
    required this.currentIndex,
    required this.aspectRatio,
    required this.onNavigate,
    required this.placeholder,
  });

  final List<String> images;
  final int currentIndex;
  // The current image's real width/height, once resolved. Falls back to a
  // portrait phone ratio (most of this site's screenshots) so the box
  // doesn't flash as a wide landscape shape before that resolves.
  final double? aspectRatio;
  final ValueChanged<int> onNavigate;
  final Widget placeholder;

  static const _fallbackAspectRatio = 9 / 19.5;
  // A generous, fixed "standard" height so a screenshot's UI is actually
  // legible rather than shrunk to fit a small box — clamped down only on
  // short viewports.
  static const _standardHeight = 620.0;
  static const _swipeVelocityThreshold = 200.0;

  bool get _hasMultiple => images.length > 1;

  @override
  Widget build(BuildContext context) {
    final galleryHeight = (MediaQuery.sizeOf(context).height * 0.68)
        .clamp(320.0, _standardHeight);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    // The dark backdrop spans the gallery's full width and a fixed height;
    // the image itself is centered inside at its own aspect ratio. Nav
    // buttons are positioned against this full-width frame, not the
    // (often much narrower, portrait) image, so they sit in open space
    // beside it instead of covering the screenshot's own UI.
    return SizedBox(
      height: galleryHeight,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: _hasMultiple
                  ? (details) {
                      final velocity = details.primaryVelocity ?? 0;
                      if (velocity <= -_swipeVelocityThreshold) {
                        onNavigate(currentIndex + 1);
                      } else if (velocity >= _swipeVelocityThreshold) {
                        onNavigate(currentIndex - 1);
                      }
                    }
                  : null,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio ?? _fallbackAspectRatio,
                  // Only the current image (plus whatever the modal state
                  // has already precached for its immediate neighbors) is
                  // ever built here, so the rest of a project's screenshots
                  // never decode until the visitor navigates to them.
                  child: AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    child: Image.asset(
                      images[currentIndex],
                      key: ValueKey(currentIndex),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => placeholder,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: frame != null
                              ? child
                              : const _GalleryShimmer(key: ValueKey('loading')),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (_hasMultiple) ...[
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.chevron_left,
                    tooltip: 'Previous image',
                    onPressed: () => onNavigate(currentIndex - 1),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.chevron_right,
                    tooltip: 'Next image',
                    onPressed: () => onNavigate(currentIndex + 1),
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    final isActive = index == currentIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox.square(
                        dimension: isActive ? 8 : 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(isActive ? 255 : 120),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A moving highlight sweeping across a dark box while a gallery image
/// decodes — reads as "this is loading", not as blank empty space. Freezes
/// to a static mid-tone box under `prefers-reduced-motion`.
class _GalleryShimmer extends StatefulWidget {
  const _GalleryShimmer({super.key});

  @override
  State<_GalleryShimmer> createState() => _GalleryShimmerState();
}

class _GalleryShimmerState extends State<_GalleryShimmer>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400));

  // See HeroBackground's identical guard: an infinitely-repeating ticker
  // never lets pumpAndSettle() settle, so it must not start under the test
  // binding.
  static bool get _isTestBinding => WidgetsBinding.instance.runtimeType
      .toString()
      .contains('TestWidgetsFlutterBinding');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) || _isTestBinding) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ShaderMask(
            shaderCallback: (bounds) {
              final t = _controller.value;
              return LinearGradient(
                begin: Alignment(-1 - t * 2, 0),
                end: Alignment(1 - t * 2, 0),
                colors: const [
                  Color(0xFF2A2A2A),
                  Color(0xFF454545),
                  Color(0xFF2A2A2A)
                ],
                stops: const [0.35, 0.5, 0.65],
              ).createShader(bounds);
            },
            child: const ColoredBox(color: Color(0xFF2A2A2A)),
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton(
      {required this.icon, required this.tooltip, required this.onPressed});

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
              shape: BoxShape.circle, color: Colors.black.withAlpha(130)),
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

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.url, required this.onClose});

  final String? url;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: theme.colorScheme.onSurface.withAlpha(20))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                foregroundColor:
                    WidgetStatePropertyAll(theme.colorScheme.onSurface),
                side: WidgetStatePropertyAll(
                  BorderSide(color: theme.colorScheme.onSurface.withAlpha(60)),
                ),
              ),
              onPressed: onClose,
              child: const Text('Close'),
            ),
            if (url != null) ...[
              gapW12,
              FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(theme.colorScheme.tertiary),
                  foregroundColor:
                      WidgetStatePropertyAll(theme.colorScheme.secondary),
                ),
                onPressed: () => _visit(context, url!),
                child: Text(_ctaLabel(url!)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _visit(BuildContext context, String url) async {
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }

  String _ctaLabel(String url) {
    final host = Uri.tryParse(url)?.host ?? '';
    if (host.contains('apps.apple.com')) return 'View on App Store';
    if (host.contains('play.google.com')) return 'View on Google Play';
    if (host.contains('pub.dev')) return 'View on pub.dev';
    if (host.contains('github.com')) return 'View on GitHub';
    return 'Visit project';
  }
}
