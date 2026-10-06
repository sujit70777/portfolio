import 'dart:ui' show Offset, TextRange;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' show FocusNode;

/// A piece of on-page text that find-on-page can search — implemented by
/// `SearchableText`'s state, which registers itself with the nearest
/// [PageSearchController] while it is mounted.
abstract interface class PageSearchTarget {
  /// The text exactly as it is laid out, so a match's offsets are offsets
  /// into the rendered paragraph.
  String get searchText;

  /// Where [range] starts on screen, or null when it isn't currently laid
  /// out or drawn (cut off by `maxLines`, say) — such a match isn't counted,
  /// the same as a browser skipping text it can't show.
  Offset? globalOffsetOf(TextRange range);

  /// Scrolls [range] into view unless it is comfortably visible already.
  void reveal(TextRange range);
}

/// One match: [range] inside [target]'s text.
@immutable
class PageSearchMatch {
  const PageSearchMatch(this.target, this.range);

  final PageSearchTarget target;
  final TextRange range;

  bool isSameAs(PageSearchMatch other) =>
      identical(target, other.target) && range == other.range;
}

/// Find-on-page state: whether the bar is open, the query, every match in
/// reading order and which one is current.
///
/// Flutter paints the page onto a canvas, so the browser's own Cmd/Ctrl+F
/// can't see or highlight anything on it; this is the in-app replacement.
/// Each `SearchableText` highlights its own matches as it rebuilds; this
/// collects them across the page, after layout, so they can be counted,
/// ordered top-to-bottom and stepped through.
class PageSearchController extends ChangeNotifier {
  /// How much of the top of the window the app bar covers — a match under
  /// it doesn't count as "on screen" when picking where to start.
  static const _topChrome = 56.0;

  final _targets = <PageSearchTarget>{};

  /// The search field's focus. Owned here so PageSearchScope's key handler
  /// can tell when Enter is meant for the search.
  final inputFocus = FocusNode(debugLabel: 'Find on page');

  bool _isOpen = false;
  String _query = '';
  String _needle = '';
  List<_PlacedMatch> _matches = const [];
  int _currentIndex = -1;
  int _focusRequest = 0;
  int _currentSerial = 0;
  bool _refreshScheduled = false;
  bool _jumpOnRefresh = false;
  bool _disposed = false;

  bool get isOpen => _isOpen;
  String get query => _query;
  int get matchCount => _matches.length;

  /// Zero-based index of the current match, or -1 when there is none.
  int get currentIndex => _currentIndex;

  PageSearchMatch? get current =>
      _currentIndex < 0 ? null : _matches[_currentIndex].match;

  /// Bumped whenever the bar should take focus and select its text — on
  /// every Cmd/Ctrl+F, including while it is already open.
  int get focusRequest => _focusRequest;

  /// Bumped every time a match is made current, even the same one again,
  /// so it can replay its "you are here" pulse.
  int get currentSerial => _currentSerial;

  void open() {
    _isOpen = true;
    _focusRequest++;
    notifyListeners();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    _setQuery('');
    _matches = const [];
    _currentIndex = -1;
    notifyListeners();
  }

  void updateQuery(String query) {
    if (query == _query) return;
    _setQuery(query);
    _jumpOnRefresh = true;
    notifyListeners();
    _scheduleRefresh();
  }

  void next() => _step(1);

  void previous() => _step(-1);

  void _setQuery(String query) {
    _query = query;
    _needle = query.toLowerCase();
  }

  /// Case-insensitive, non-overlapping matches of the query in [text].
  List<TextRange> rangesIn(String text) {
    if (_needle.isEmpty || text.isEmpty) return const [];
    final lower = text.toLowerCase();
    // A few characters change length when lower-cased ("İ" → "i̇"), which
    // would shift every offset after them; search the original then.
    final haystack = lower.length == text.length ? lower : text;
    final ranges = <TextRange>[];
    var start = haystack.indexOf(_needle);
    while (start >= 0) {
      ranges.add(TextRange(start: start, end: start + _needle.length));
      start = haystack.indexOf(_needle, start + _needle.length);
    }
    return ranges;
  }

  /// Whether [text] contains the query — for content that isn't on screen
  /// yet (a collapsed list) deciding whether to show itself.
  bool matchesText(String? text) =>
      _needle.isNotEmpty &&
      text != null &&
      text.toLowerCase().contains(_needle);

  void attach(PageSearchTarget target) {
    _targets.add(target);
    _scheduleRefresh();
  }

  void detach(PageSearchTarget target) {
    _targets.remove(target);
    _scheduleRefresh();
  }

  /// [target]'s text or layout may have changed.
  void targetChanged(PageSearchTarget target) => _scheduleRefresh();

  void _step(int delta) {
    if (_matches.isEmpty) return;
    // Layout may have moved since the last refresh (a resize, a list that
    // expanded); re-read the order so "next" means the next one down.
    _refresh(notify: false);
    if (_matches.isEmpty) {
      notifyListeners();
      return;
    }
    _currentIndex = (_currentIndex + delta) % _matches.length;
    _currentSerial++;
    notifyListeners();
    final match = _matches[_currentIndex].match;
    match.target.reveal(match.range);
  }

  void _scheduleRefresh() {
    if (_disposed || _refreshScheduled) return;
    if (_needle.isEmpty && _matches.isEmpty) return;
    _refreshScheduled = true;
    // After layout, so every target can say where its matches are.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshScheduled = false;
      if (!_disposed) _refresh();
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _refresh({bool notify = true}) {
    final previous = current;
    final found = <_PlacedMatch>[];
    if (_needle.isNotEmpty) {
      for (final target in _targets) {
        for (final range in rangesIn(target.searchText)) {
          final at = target.globalOffsetOf(range);
          if (at != null) {
            found.add(_PlacedMatch(PageSearchMatch(target, range), at));
          }
        }
      }
    }
    found.sort(_readingOrder);

    final jump = _jumpOnRefresh;
    _jumpOnRefresh = false;
    var index = -1;
    if (found.isNotEmpty) {
      if (jump || previous == null) {
        // Like a browser: start from the first match at or below the top
        // of what's on screen, not from the top of the page.
        index = found.indexWhere((m) => m.at.dy >= _topChrome);
        if (index < 0) index = 0;
      } else {
        index = found.indexWhere((m) => m.match.isSameAs(previous));
        if (index < 0) index = _currentIndex.clamp(0, found.length - 1);
      }
    }

    final changed = index != _currentIndex || !_sameMatches(found);
    _matches = found;
    _currentIndex = index;
    if (jump && index >= 0) _currentSerial++;
    if (notify && (changed || jump)) notifyListeners();
    if (jump && index >= 0) {
      final match = found[index].match;
      match.target.reveal(match.range);
    }
  }

  bool _sameMatches(List<_PlacedMatch> other) {
    if (other.length != _matches.length) return false;
    for (var i = 0; i < other.length; i++) {
      if (!other[i].match.isSameAs(_matches[i].match)) return false;
    }
    return true;
  }

  /// Top to bottom, then left to right along a line.
  static int _readingOrder(_PlacedMatch a, _PlacedMatch b) {
    final dy = a.at.dy - b.at.dy;
    if (dy.abs() > 4) return dy < 0 ? -1 : 1;
    return a.at.dx.compareTo(b.at.dx);
  }

  @override
  void dispose() {
    _disposed = true;
    _targets.clear();
    inputFocus.dispose();
    super.dispose();
  }
}

class _PlacedMatch {
  const _PlacedMatch(this.match, this.at);

  final PageSearchMatch match;
  final Offset at;
}
