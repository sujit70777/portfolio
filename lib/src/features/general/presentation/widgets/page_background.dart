import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/ambient_loop.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/features/general/provider/scroll_controller.dart';

/// Every tunable value of [PageBackground]. The constructor's defaults are
/// the desktop look; [tablet] and [mobile] start from those same defaults
/// and override only what a smaller, slower screen needs, so editing a
/// default here changes all three unless a preset overrides it. Sizes are
/// logical pixels, times are durations, and the "intensity"/"brightness"
/// values are multipliers, so 1.0 is the default and 0 hides that part.
@immutable
class PageBackgroundSettings {
  const PageBackgroundSettings({
    // Whole effect
    this.enabled = true,
    this.frameRate = 30,
    this.fadeInDuration = const Duration(milliseconds: 1600),
    // Glows
    this.showGlows = true,
    this.glowPeriod = const Duration(seconds: 40),
    this.glowSize = 3.0,
    this.glowMinRadius = 240,
    this.glowMaxRadius = 720,
    this.glowIntensity = 1.0,
    this.glowDrift = 1.0,
    this.glowParallax = 0.3,
    this.glowTileHeight = 1.6,
    // Motes
    this.showMotes = true,
    this.moteAreaPerMote = 22000,
    this.moteMinCount = 300,
    this.moteMaxCount = 400,
    this.moteMinRadius = 0.7,
    this.moteMaxRadius = 1.9,
    this.moteMinRiseSpeed = 10,
    this.moteMaxRiseSpeed = 14,
    this.moteSway = 14,
    this.moteSwayPeriod = const Duration(seconds: 21),
    this.twinklePeriod = const Duration(seconds: 8),
    this.moteBrightness = 2.0,
    this.moteParallax = 1.0,
    // Links between motes
    this.showLinks = true,
    this.linkDistance = 120,
    this.linkWidth = 0.7,
    this.linkIntensity = 1.0,
    // Cursor light (desktop)
    this.showPointerLight = true,
    this.pointerRadius = 260,
    this.pointerReach = 170,
    this.pointerIntensity = 1.0,
    this.pointerFollowSpeed = 6,
    this.pointerFadeSpeed = 3,
  }) : assert(frameRate > 0),
       assert(glowMinRadius <= glowMaxRadius),
       assert(moteMinCount <= moteMaxCount),
       assert(moteMinRadius <= moteMaxRadius),
       assert(moteMinRiseSpeed <= moteMaxRiseSpeed),
       assert(glowTileHeight > 0 && moteAreaPerMote > 0);

  /// Off switch for the whole effect: only [PageBackground.color] is
  /// painted.
  final bool enabled;

  /// Repaints per second, at most. The motion is slow drift, so 30 reads
  /// the same as 60 at half the cost; 60 or more means "every frame".
  final int frameRate;

  /// How long the effect takes to fade in when the app starts.
  final Duration fadeInDuration;

  final bool showGlows;

  /// One full orbit of the drifting glows. Shorter is faster.
  final Duration glowPeriod;

  /// Multiplier on each glow's radius (which is a fraction of the larger
  /// screen side), before [glowMinRadius]/[glowMaxRadius] clamp it.
  final double glowSize;
  final double glowMinRadius;
  final double glowMaxRadius;

  /// Multiplier on glow opacity. 1.0 is half the hero's glow strength.
  final double glowIntensity;

  /// Multiplier on how far the glows wander on their orbit.
  final double glowDrift;

  /// How fast the glows move when scrolling, as a fraction of the page's
  /// speed: 0 is fixed to the screen, 1 scrolls with the content.
  final double glowParallax;

  /// Height of the repeating glow pattern, in screen heights. Larger spaces
  /// the glows further apart down the page.
  final double glowTileHeight;

  final bool showMotes;

  /// Screen area each mote gets, in square pixels. Lower means more motes.
  final double moteAreaPerMote;

  /// Bounds on the mote count. The count is the screen area divided by
  /// [moteAreaPerMote], clamped to these — so with a large
  /// [moteAreaPerMote], [moteMinCount] is simply the count.
  final int moteMinCount;
  final int moteMaxCount;

  /// Each mote's radius is picked between these.
  final double moteMinRadius;
  final double moteMaxRadius;

  /// Each mote rises at a speed between these, in pixels per second.
  final double moteMinRiseSpeed;
  final double moteMaxRiseSpeed;

  /// How far motes sway side to side, in pixels, and how long one sway
  /// takes.
  final double moteSway;
  final Duration moteSwayPeriod;

  /// How long one twinkle (dim, bright, dim) takes.
  final Duration twinklePeriod;

  /// Multiplier on mote opacity.
  final double moteBrightness;

  /// Multiplier on how much motes shift when scrolling (each has its own
  /// depth, 0.15–0.5 of the page's speed). 0 turns mote parallax off.
  final double moteParallax;

  final bool showLinks;

  /// Motes closer than this are joined by a line, fading with distance.
  final double linkDistance;
  final double linkWidth;

  /// Multiplier on line opacity.
  final double linkIntensity;

  final bool showPointerLight;

  /// Radius of the soft light under the cursor.
  final double pointerRadius;

  /// Motes within this distance of the cursor get a line to it.
  final double pointerReach;

  /// Multiplier on the cursor light's and its lines' opacity.
  final double pointerIntensity;

  /// How quickly the light catches up with the cursor, and fades in/out
  /// when it enters/leaves. Higher is snappier.
  final double pointerFollowSpeed;
  final double pointerFadeSpeed;

  /// Desktop, 1024px wide and up: the constructor's defaults.
  static const desktop = PageBackgroundSettings();

  /// Tablet, 640–1023px wide. The same mote density as the desktop default
  /// (700 on a 1440x900 window): ~420 on a 768x1024 iPad, ~520 at 820x1180.
  static const tablet = PageBackgroundSettings(
    moteMinCount: 220,
    moteMaxCount: 400,
  );

  /// Phone, under 640px wide. A little sparser than desktop density
  /// (~180 at 390x844): a phone has the least headroom, and the same field
  /// on a small screen reads as busier.
  static const mobile = PageBackgroundSettings(
    moteMinCount: 40,
    moteMaxCount: 100,
  );

  Duration get _frameInterval =>
      Duration(microseconds: 1000000 ~/ frameRate - 1000);
}

/// The whole-page backdrop behind [child] (the page's scroll view), over a
/// solid [color]: soft
/// aurora glows that drift and scroll at a slower rate than the content, so
/// the page has depth; a field of slowly rising motes that link up with
/// faint lines when they pass near each other — a quiet nod to sync — and,
/// on desktop, a soft light that trails the cursor and reaches out to the
/// nearest motes.
///
/// Sized to the viewport, not the page, so its cost doesn't grow with the
/// content. It sits in its own [RepaintBoundary], so its frames never
/// repaint the content above it, and it's throttled to
/// [PageBackgroundSettings.frameRate].
/// The browser stops the ticker while the tab is hidden. Under
/// `prefers-reduced-motion` (and in widget tests) nothing moves: no drift,
/// no scroll parallax, no cursor light, just a still frame of the same
/// design.
///
/// Fainter than `HeroBackground`, which paints on top of it at the top of
/// the page; this one only has to keep the rest of the page from going flat.
class PageBackground extends ConsumerStatefulWidget {
  const PageBackground({
    super.key,
    required this.color,
    required this.child,
    this.desktopSettings = PageBackgroundSettings.desktop,
    this.tabletSettings = PageBackgroundSettings.tablet,
    this.mobileSettings = PageBackgroundSettings.mobile,
  });

  final Color color;
  final Widget child;

  /// Picked by window width, at the site's [Responsive] breakpoints.
  final PageBackgroundSettings desktopSettings;
  final PageBackgroundSettings tabletSettings;
  final PageBackgroundSettings mobileSettings;

  @override
  ConsumerState<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends ConsumerState<PageBackground>
    with SingleTickerProviderStateMixin {
  late final _ticker = createTicker(_onTick);
  final _clock = ValueNotifier<double>(0);
  final _pointer = _PointerLight();
  Duration _lastFrame = Duration.zero;
  bool _allowed = false;
  PageBackgroundSettings _settings = PageBackgroundSettings.desktop;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  @override
  void didUpdateWidget(PageBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTicker();
  }

  /// Also re-runs when the window is resized (via the MediaQuery dependency
  /// [Responsive] takes), so crossing a breakpoint swaps the preset.
  void _syncTicker() {
    _settings = Responsive.isMobile(context)
        ? widget.mobileSettings
        : Responsive.isTablet(context)
        ? widget.tabletSettings
        : widget.desktopSettings;
    _allowed = ambientMotionAllowed(context) && _settings.enabled;
    if (_allowed && !_ticker.isActive) {
      _lastFrame = Duration.zero;
      _ticker.start();
    } else if (!_allowed && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _clock.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _lastFrame;
    if (dt < _settings._frameInterval) return;
    _lastFrame = elapsed;
    _pointer.ease(dt.inMicroseconds / 1e6, _settings);
    _clock.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ref.watch(scrollControllerProvider);
    final palette = Palette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = _settings;
    if (!settings.enabled) {
      return ColoredBox(color: widget.color, child: widget.child);
    }

    return ColoredBox(
      color: widget.color,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: TweenAnimationBuilder<double>(
                // Fades in as Flutter takes over from the static HTML hero, so
                // the page visibly comes alive rather than popping.
                tween: Tween(begin: _allowed ? 0 : 1, end: 1),
                duration: settings.fadeInDuration,
                curve: Curves.easeOut,
                builder: (context, fadeIn, child) =>
                    Opacity(opacity: fadeIn, child: child),
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _BackgroundPainter(
                      clock: _clock,
                      pointer: _pointer,
                      scroll: _allowed ? scrollController : null,
                      palette: palette,
                      dark: dark,
                      settings: settings,
                    ),
                  ),
                ),
              ),
            ),
          ),
          MouseRegion(
            opaque: false,
            onHover: _allowed && settings.showPointerLight
                ? (e) => _pointer.target = e.localPosition
                : null,
            onExit: _allowed ? (_) => _pointer.target = null : null,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// The cursor light's position and strength, eased towards the real cursor
/// every frame so it trails rather than sticks, and fades out when the
/// cursor leaves the page.
class _PointerLight extends ChangeNotifier {
  Offset? target;
  Offset _position = Offset.zero;
  double _strength = 0;

  Offset get position => _position;
  double get strength => _strength;

  void ease(double dt, PageBackgroundSettings settings) {
    final goal = target;
    final follow = 1 - math.exp(-dt * settings.pointerFollowSpeed);
    final fade = 1 - math.exp(-dt * settings.pointerFadeSpeed);
    final before = (_position, _strength);
    if (goal != null) {
      // Jump straight there on first entry instead of sweeping in from 0,0.
      _position = _strength < 0.01
          ? goal
          : Offset.lerp(_position, goal, follow)!;
    }
    _strength += ((goal != null ? 1.0 : 0.0) - _strength) * fade;
    if (before != (_position, _strength)) notifyListeners();
  }
}

/// A mote's fixed traits: where it starts (fractions of the viewport), where
/// its rise speed and size fall between the settings' min and max (0–1),
/// its twinkle phase, and how strongly it reacts to scrolling (its depth).
typedef _Mote = ({
  double x,
  double y,
  double rise,
  double radius,
  double phase,
  double depth,
});

/// Seeded, so the field is the same on every visit, and grown on demand so
/// raising [PageBackgroundSettings.moteMaxCount] only adds motes.
final _moteRandom = math.Random(7);
final _motes = <_Mote>[];

List<_Mote> _motePool(int count) {
  while (_motes.length < count) {
    _motes.add((
      x: _moteRandom.nextDouble(),
      y: _moteRandom.nextDouble(),
      rise: _moteRandom.nextDouble(),
      radius: _moteRandom.nextDouble(),
      phase: _moteRandom.nextDouble() * 2 * math.pi,
      depth: 0.15 + _moteRandom.nextDouble() * 0.35,
    ));
  }
  return _motes;
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    required this.clock,
    required this.pointer,
    required this.scroll,
    required this.palette,
    required this.dark,
    required this.settings,
  }) : super(repaint: Listenable.merge([clock, pointer, ?scroll]));

  final ValueNotifier<double> clock;
  final _PointerLight pointer;

  /// Null when motion is reduced: no scroll parallax either.
  final ScrollController? scroll;
  final Palette palette;
  final bool dark;
  final PageBackgroundSettings settings;

  double get _scrollOffset {
    final positions = scroll?.positions;
    if (positions == null || positions.isEmpty) return 0;
    return positions.first.pixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final time = clock.value;
    final offset = _scrollOffset;
    final pointerStrength = settings.showPointerLight
        ? pointer.strength * settings.pointerIntensity
        : 0.0;

    if (settings.showGlows) _paintGlows(canvas, size, time, offset);
    if (pointerStrength > 0.01) {
      _paintPointerGlow(canvas, pointer.position, pointerStrength);
    }

    if (!settings.showMotes) return;
    final motes = _motePositions(size, time, offset);
    _paintLinks(canvas, size, motes, pointerStrength);
    _paintMotes(canvas, motes, time);
  }

  /// Big, faint aurora washes laid out on a tile `glowTileHeight` screens
  /// tall that scrolls at `glowParallax` of the page's speed and repeats, so
  /// there's always light somewhere on screen however far down the visitor
  /// is.
  void _paintGlows(Canvas canvas, Size size, double time, double offset) {
    final tile = size.height * settings.glowTileHeight;
    final base = math.max(size.width, size.height);
    final alpha = (palette.glowAlpha * 0.5 * settings.glowIntensity).clamp(
      0.0,
      255.0,
    );
    final drift = settings.glowDrift;
    final a = time / _seconds(settings.glowPeriod) * 2 * math.pi;
    final glows = <(double, double, Color, double, double)>[
      (0.06, 0.12, palette.aurora[0], 0.5, 0.0),
      (0.94, 0.42, palette.aurora[2], 0.42, 1.9),
      (0.28, 0.78, palette.hue(2), 0.4, 3.4),
      (0.72, 0.98, palette.aurora[1], 0.36, 5.0),
    ];
    for (final (fx, fy, color, scale, phase) in glows) {
      final radius = (base * scale * settings.glowSize).clamp(
        settings.glowMinRadius,
        settings.glowMaxRadius,
      );
      final x =
          fx * size.width + math.sin(a + phase) * size.width * 0.05 * drift;
      final y = _wrap(
        fy * tile +
            math.cos(a + phase) * tile * 0.04 * drift -
            offset * settings.glowParallax,
        tile,
      );
      for (final copy in [y - tile, y, y + tile]) {
        if (copy + radius < 0 || copy - radius > size.height) continue;
        final center = Offset(x, copy);
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..shader = RadialGradient(
              colors: [
                color.withAlpha(alpha.round()),
                color.withAlpha((alpha * 0.4).round()),
                color.withAlpha(0),
              ],
              stops: const [0, 0.4, 1],
            ).createShader(Rect.fromCircle(center: center, radius: radius)),
        );
      }
    }
  }

  void _paintPointerGlow(Canvas canvas, Offset center, double strength) {
    final radius = settings.pointerRadius;
    final alpha = (palette.glowAlpha * 0.55 * strength).clamp(0.0, 255.0);
    final color = palette.aurora[1];
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withAlpha(alpha.round()), color.withAlpha(0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  /// Fewer motes on small screens: density, not count, is what should stay
  /// constant, and a phone has the least headroom.
  List<Offset> _motePositions(Size size, double time, double offset) {
    final count = (size.width * size.height / settings.moteAreaPerMote)
        .round()
        .clamp(settings.moteMinCount, settings.moteMaxCount);
    final pool = _motePool(count);
    final margin = settings.moteMaxRadius + 18;
    final span = size.height + margin * 2;
    final sway = 2 * math.pi / _seconds(settings.moteSwayPeriod);
    final minRise = settings.moteMinRiseSpeed;
    final riseRange = settings.moteMaxRiseSpeed - minRise;
    return [
      for (final mote in pool.take(count))
        Offset(
          mote.x * size.width +
              math.sin(time * sway + mote.phase) * settings.moteSway,
          _wrap(
                mote.y * span -
                    time * (minRise + mote.rise * riseRange) -
                    offset * mote.depth * settings.moteParallax,
                span,
              ) -
              margin,
        ),
    ];
  }

  /// Opacity steps that lines and motes are batched into. Hundreds of
  /// motes mean thousands of lines a frame; drawn one call each, the calls
  /// themselves are the cost. Bucketed, it's a few dozen calls, and steps
  /// this fine are invisible at these opacities.
  static const _alphaSteps = 10;

  /// Size steps motes are batched into, for the same reason.
  static const _radiusSteps = 3;

  /// Joins motes closer than `linkDistance`. Motes are binned into a grid of
  /// `linkDistance`-sized cells first, so each is only compared with the
  /// motes in its own and adjacent cells — not with every other mote, which
  /// at 700 motes would be ~245,000 checks a frame.
  void _paintLinks(
    Canvas canvas,
    Size size,
    List<Offset> motes,
    double pointerStrength,
  ) {
    final paint = Paint()..strokeWidth = settings.linkWidth;
    final linkDistance = settings.linkDistance;
    if (settings.showLinks && linkDistance > 0 && motes.length > 1) {
      final limit = linkDistance * linkDistance;
      // One spare column/row each side for motes swaying or wrapping just
      // off screen.
      final cols = (size.width / linkDistance).ceil() + 2;
      final rows = (size.height / linkDistance).ceil() + 2;
      final grid = List.generate(cols * rows, (_) => <int>[]);
      for (var i = 0; i < motes.length; i++) {
        final cx = (motes[i].dx / linkDistance).floor() + 1;
        final cy = (motes[i].dy / linkDistance).floor() + 1;
        grid[cy.clamp(0, rows - 1) * cols + cx.clamp(0, cols - 1)].add(i);
      }

      final buckets = List.generate(_alphaSteps, (_) => <double>[]);
      // Own cell plus the four "forward" neighbours, so each pair is seen
      // exactly once.
      const neighbours = [(0, 0), (1, 0), (-1, 1), (0, 1), (1, 1)];
      for (var cy = 0; cy < rows; cy++) {
        for (var cx = 0; cx < cols; cx++) {
          final cell = grid[cy * cols + cx];
          for (final (dx, dy) in neighbours) {
            final nx = cx + dx, ny = cy + dy;
            if (nx < 0 || nx >= cols || ny >= rows) continue;
            final other = grid[ny * cols + nx];
            final sameCell = dx == 0 && dy == 0;
            for (var a = 0; a < cell.length; a++) {
              final p = motes[cell[a]];
              for (var b = sameCell ? a + 1 : 0; b < other.length; b++) {
                final q = motes[other[b]];
                final ddx = p.dx - q.dx, ddy = p.dy - q.dy;
                final d2 = ddx * ddx + ddy * ddy;
                if (d2 >= limit) continue;
                final closeness = 1 - math.sqrt(d2) / linkDistance;
                buckets[(closeness * _alphaSteps).floor().clamp(
                      0,
                      _alphaSteps - 1,
                    )]
                    .addAll([p.dx, p.dy, q.dx, q.dy]);
              }
            }
          }
        }
      }

      final color = palette.aurora[1];
      final maxAlpha = (dark ? 34.0 : 22.0) * settings.linkIntensity;
      for (var k = 0; k < _alphaSteps; k++) {
        if (buckets[k].isEmpty) continue;
        paint.color = color.withAlpha(
          ((k + 0.5) / _alphaSteps * maxAlpha).round().clamp(0, 255),
        );
        canvas.drawRawPoints(
          PointMode.lines,
          Float32List.fromList(buckets[k]),
          paint,
        );
      }
    }

    // Cursor lines: only the motes within reach, so a handful — drawn
    // directly.
    if (pointerStrength <= 0.01) return;
    final cursor = pointer.position;
    final reach = settings.pointerReach;
    final reachAlpha = (dark ? 70.0 : 40.0) * pointerStrength;
    for (final mote in motes) {
      final distance = (mote - cursor).distance;
      if (distance >= reach) continue;
      paint.color = palette.aurora[2].withAlpha(
        ((1 - distance / reach) * reachAlpha).round().clamp(0, 255),
      );
      canvas.drawLine(cursor, mote, paint);
    }
  }

  /// Drawn as round points, batched by colour, size and twinkle step — one
  /// call per batch instead of one per mote.
  void _paintMotes(Canvas canvas, List<Offset> motes, double time) {
    // Toned right down on the light theme, where bright specks read as dirt.
    final base = (dark ? 70.0 : 30.0) * settings.moteBrightness;
    final range = (dark ? 130.0 : 50.0) * settings.moteBrightness;
    final twinkleSpeed = 2 * math.pi / _seconds(settings.twinklePeriod);
    final minRadius = settings.moteMinRadius;
    final radiusRange = settings.moteMaxRadius - minRadius;
    // Every third mote gold, the rest mint — the aurora's two ends.
    final colors = [palette.aurora[1], palette.aurora[2]];

    final batches = List.generate(
      colors.length * _radiusSteps * _alphaSteps,
      (_) => <double>[],
    );
    for (var i = 0; i < motes.length; i++) {
      final mote = _motes[i];
      final twinkle = 0.5 + 0.5 * math.sin(time * twinkleSpeed + mote.phase);
      final c = i % 3 == 0 ? 1 : 0;
      final r = (mote.radius * _radiusSteps).floor().clamp(0, _radiusSteps - 1);
      final t = (twinkle * _alphaSteps).floor().clamp(0, _alphaSteps - 1);
      batches[(c * _radiusSteps + r) * _alphaSteps + t].addAll([
        motes[i].dx,
        motes[i].dy,
      ]);
    }

    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var c = 0; c < colors.length; c++) {
      for (var r = 0; r < _radiusSteps; r++) {
        final radius = minRadius + (r + 0.5) / _radiusSteps * radiusRange;
        paint.strokeWidth = radius * 2;
        for (var t = 0; t < _alphaSteps; t++) {
          final points = batches[(c * _radiusSteps + r) * _alphaSteps + t];
          if (points.isEmpty) continue;
          final twinkle = (t + 0.5) / _alphaSteps;
          paint.color = colors[c].withAlpha(
            (base + range * twinkle).round().clamp(0, 255),
          );
          canvas.drawRawPoints(
            PointMode.points,
            Float32List.fromList(points),
            paint,
          );
        }
      }
    }
  }

  static double _wrap(double value, double span) =>
      ((value % span) + span) % span;

  /// Never zero, so a zero-length period can't divide by zero.
  static double _seconds(Duration d) => math.max(d.inMicroseconds, 1000) / 1e6;

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) =>
      old.palette != palette ||
      old.dark != dark ||
      old.settings != settings ||
      old.scroll != scroll ||
      old.clock != clock ||
      old.pointer != pointer;
}
