import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/features/page_search/application/page_search_controller.dart';
import 'package:portfolio/src/features/page_search/presentation/page_search_scope.dart';

/// A [Text] that find-on-page (Cmd/Ctrl+F) can search: it highlights its
/// own matches, marks the current one, and scrolls it into view when asked.
///
/// Use it for any page copy a visitor might look for — the browser's find
/// can't see text Flutter paints, so text left as a plain [Text] is
/// invisible to search. Outside a [PageSearchScope] it is just a [Text].
class SearchableText extends StatefulWidget {
  const SearchableText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.wrap,
    this.highlightAbove = false,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  /// Wraps the text widget before the highlights go around it — for text
  /// drawn through an effect (AuroraText's gradient mask) that must not
  /// apply to the highlights too.
  final Widget Function(Widget text)? wrap;

  /// Draw highlights as a tint over the text instead of a solid fill
  /// behind it — for text whose colour can't be changed per match, like a
  /// gradient fill, where a solid fill would hide the word.
  final bool highlightAbove;

  @override
  State<SearchableText> createState() => _SearchableTextState();
}

class _SearchableTextState extends State<SearchableText>
    with SingleTickerProviderStateMixin
    implements PageSearchTarget {
  PageSearchController? _controller;
  int _seenSerial = -1;

  /// The ring that ripples out from a match the moment it becomes current.
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
    value: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = PageSearchScope.maybeOf(context);
    if (!identical(controller, _controller)) {
      _controller?.detach(this);
      _controller = controller?..attach(this);
    }
  }

  @override
  void didUpdateWidget(SearchableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.style != widget.style ||
        oldWidget.maxLines != widget.maxLines) {
      _controller?.targetChanged(this);
    }
  }

  @override
  void dispose() {
    _controller?.detach(this);
    _pulse.dispose();
    super.dispose();
  }

  // PageSearchTarget

  @override
  String get searchText => widget.data;

  @override
  Offset? globalOffsetOf(TextRange range) {
    final paragraph = _paragraph;
    if (paragraph == null) return null;
    final boxes = paragraph.getBoxesForSelection(_selection(range));
    if (boxes.isEmpty) return null;
    return paragraph.localToGlobal(Offset(boxes.first.left, boxes.first.top));
  }

  @override
  void reveal(TextRange range) {
    final paragraph = _paragraph;
    final scrollable = Scrollable.maybeOf(context);
    final viewport = paragraph == null
        ? null
        : RenderAbstractViewport.maybeOf(paragraph);
    if (paragraph == null || scrollable == null || viewport == null) return;

    final boxes = paragraph.getBoxesForSelection(_selection(range));
    if (boxes.isEmpty) return;
    final rect = boxes
        .map((box) => box.toRect())
        .reduce((a, b) => a.expandToInclude(b));

    final position = scrollable.position;
    // Scroll offsets that would put the match flush with the top and the
    // bottom of the viewport; anything between them shows it. The margin
    // keeps it out from under the app bar and the search bar itself.
    const margin = 120.0;
    final atTop = viewport.getOffsetToReveal(paragraph, 0, rect: rect).offset;
    final atBottom = viewport
        .getOffsetToReveal(paragraph, 1, rect: rect)
        .offset;
    if (position.pixels <= atTop - margin &&
        position.pixels >= atBottom + margin / 2) {
      return;
    }
    final target = viewport
        .getOffsetToReveal(paragraph, 0.38, rect: rect)
        .offset
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    if (MediaQuery.disableAnimationsOf(context)) {
      position.jumpTo(target);
    } else {
      position.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }
  }

  static TextSelection _selection(TextRange range) =>
      TextSelection(baseOffset: range.start, extentOffset: range.end);

  RenderParagraph? get _paragraph {
    if (!mounted) return null;
    final paragraph = _findParagraph(context.findRenderObject());
    if (paragraph == null || !paragraph.attached || !paragraph.hasSize) {
      return null;
    }
    return paragraph;
  }

  static RenderParagraph? _findParagraph(RenderObject? node) {
    if (node == null || node is RenderParagraph) {
      return node as RenderParagraph?;
    }
    RenderParagraph? found;
    node.visitChildren((child) => found ??= _findParagraph(child));
    return found;
  }

  /// The paragraph and where it sits inside this widget's own box, for the
  /// painter — the two differ only if [SearchableText.wrap] offsets it.
  (RenderParagraph, Offset)? _locate() {
    final paragraph = _paragraph;
    final box = context.findRenderObject();
    if (paragraph == null || box is! RenderBox) return null;
    return (paragraph, paragraph.localToGlobal(Offset.zero, ancestor: box));
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageSearchScope.maybeOf(context);
    final ranges = controller?.rangesIn(widget.data) ?? const <TextRange>[];
    final current = controller?.current;
    final currentRange = current != null && identical(current.target, this)
        ? current.range
        : null;

    if (currentRange != null && controller!.currentSerial != _seenSerial) {
      _seenSerial = controller.currentSerial;
      if (!MediaQuery.disableAnimationsOf(context)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _pulse.forward(from: 0);
        });
      }
    }

    final palette = Palette.of(context);
    final recolor = ranges.isNotEmpty && !widget.highlightAbove;
    // Always a Text, matches or not, so its element — and anything the
    // SelectionArea or an animation is holding on to — survives a search.
    final Widget text = recolor
        ? Text.rich(
            _spans(ranges, TextStyle(color: palette.onFind)),
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            softWrap: widget.softWrap,
          )
        : Text(
            widget.data,
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            softWrap: widget.softWrap,
          );

    final painter = ranges.isEmpty
        ? null
        : _FindHighlightPainter(
            locate: _locate,
            ranges: ranges,
            current: currentRange,
            pulse: _pulse,
            matchColor: palette.findMatch,
            currentColor: palette.findCurrent,
            above: widget.highlightAbove,
          );

    final child = widget.wrap?.call(text) ?? text;
    return CustomPaint(
      painter: widget.highlightAbove ? null : painter,
      foregroundPainter: widget.highlightAbove ? painter : null,
      child: child,
    );
  }

  TextSpan _spans(List<TextRange> ranges, TextStyle matchStyle) {
    final data = widget.data;
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final range in ranges) {
      if (range.start > cursor) {
        spans.add(TextSpan(text: data.substring(cursor, range.start)));
      }
      spans.add(TextSpan(text: range.textInside(data), style: matchStyle));
      cursor = range.end;
    }
    if (cursor < data.length) spans.add(TextSpan(text: data.substring(cursor)));
    return TextSpan(children: spans);
  }
}

/// Rounded highlight pills around each match, the current one in a
/// stronger colour with a soft glow and — as it becomes current — a ring
/// rippling out from it, so the eye lands on it after a scroll.
class _FindHighlightPainter extends CustomPainter {
  _FindHighlightPainter({
    required this.locate,
    required this.ranges,
    required this.current,
    required this.pulse,
    required this.matchColor,
    required this.currentColor,
    required this.above,
  }) : super(repaint: pulse);

  final (RenderParagraph, Offset)? Function() locate;
  final List<TextRange> ranges;
  final TextRange? current;
  final Animation<double> pulse;
  final Color matchColor;
  final Color currentColor;
  final bool above;

  @override
  void paint(Canvas canvas, Size size) {
    final located = locate();
    if (located == null) return;
    final (paragraph, origin) = located;

    for (final range in ranges) {
      final isCurrent = range == current;
      final color = isCurrent ? currentColor : matchColor;
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: range.start, extentOffset: range.end),
      );
      for (final box in boxes) {
        final rect = box.toRect().shift(origin);
        final pill = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            rect.left - 3,
            rect.top - 1,
            rect.right + 3,
            rect.bottom + 1,
          ),
          const Radius.circular(5),
        );

        if (isCurrent) {
          canvas.drawRRect(
            pill.inflate(2),
            Paint()
              ..color = color.withAlpha(120)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
          );
        }

        if (above) {
          canvas.drawRRect(
            pill,
            Paint()..color = color.withAlpha(isCurrent ? 90 : 60),
          );
          canvas.drawRRect(
            pill,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5
              ..color = color,
          );
        } else {
          canvas.drawRRect(pill, Paint()..color = color);
        }

        if (isCurrent && pulse.value < 1) {
          final t = Curves.easeOutCubic.transform(pulse.value);
          canvas.drawRRect(
            pill.inflate(2 + 10 * t),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = color.withAlpha(((1 - t) * 200).round()),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_FindHighlightPainter oldDelegate) {
    return !listEquals(oldDelegate.ranges, ranges) ||
        oldDelegate.current != current ||
        oldDelegate.matchColor != matchColor ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.above != above;
  }
}
