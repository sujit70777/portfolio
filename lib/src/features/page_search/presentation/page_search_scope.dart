import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/src/features/page_search/application/page_search_controller.dart';
import 'package:portfolio/src/features/page_search/presentation/page_search_bar.dart';

/// Gives the page its own find-on-page: Cmd+F (macOS) / Ctrl+F (elsewhere)
/// opens [PageSearchBar] instead of the browser's find bar, which can't see
/// text Flutter paints onto a canvas. Every `SearchableText` below this
/// registers with it.
///
/// Taking the shortcut works because the web engine calls `preventDefault`
/// on any key event the framework reports as handled, so the browser never
/// sees it. It only applies while the page has keyboard focus — from the
/// address bar, or the browser's Edit menu, the browser's own find opens,
/// and still counts matches through the semantics tree main.dart turns on.
class PageSearchScope extends StatefulWidget {
  const PageSearchScope({super.key, required this.child});

  final Widget child;

  /// The nearest controller, rebuilding [context] whenever the query, the
  /// matches or the current match change.
  static PageSearchController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PageSearchInherited>()
        ?.notifier;
  }

  @override
  State<PageSearchScope> createState() => _PageSearchScopeState();
}

class _PageSearchScopeState extends State<PageSearchScope> {
  final _controller = PageSearchController();

  static const _barWidth = 440.0;
  static const _narrowBreakpoint = _barWidth + 80;

  @override
  void initState() {
    super.initState();
    // A global handler rather than Shortcuts in the tree: it sees the key
    // wherever focus is (or isn't) on the page, including before the
    // visitor has clicked anything.
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    _controller.dispose();
    super.dispose();
  }

  bool get _usesCommandKey => switch (defaultTargetPlatform) {
    TargetPlatform.macOS || TargetPlatform.iOS => true,
    _ => false,
  };

  bool _handleKey(KeyEvent event) {
    if (event is KeyUpEvent || !mounted) return false;
    // A dialog or the drawer is in front of the page: its text isn't
    // searchable here, so leave the key to the browser.
    if (ModalRoute.of(context)?.isCurrent == false) return false;
    if (Scaffold.maybeOf(context)?.isEndDrawerOpen == true) return false;

    final keyboard = HardwareKeyboard.instance;
    final primary = _usesCommandKey
        ? keyboard.isMetaPressed && !keyboard.isControlPressed
        : keyboard.isControlPressed && !keyboard.isMetaPressed;
    final key = event.logicalKey;

    if (primary &&
        !keyboard.isAltPressed &&
        !keyboard.isShiftPressed &&
        key == LogicalKeyboardKey.keyF) {
      _controller.open();
      return true;
    }
    if (!_controller.isOpen) return false;

    // Enter / Shift+Enter in the search field. Handled here, as a key,
    // rather than through the field's onSubmitted: on the web that arrives
    // through the browser's text input instead, separately from the key
    // press, and wasn't reliable — some presses never stepped.
    if ((key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.numpadEnter) &&
        _controller.inputFocus.hasFocus) {
      keyboard.isShiftPressed ? _controller.previous() : _controller.next();
      return true;
    }

    // Find next/previous wherever focus is, the browser way: Cmd/Ctrl+G
    // and F3, with Shift going backwards.
    if ((primary && !keyboard.isAltPressed && key == LogicalKeyboardKey.keyG) ||
        key == LogicalKeyboardKey.f3) {
      keyboard.isShiftPressed ? _controller.previous() : _controller.next();
      return true;
    }
    if (key == LogicalKeyboardKey.escape) {
      _controller.close();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < _narrowBreakpoint;
    return _PageSearchInherited(
      notifier: _controller,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          // Just under the app bar, at the right — where a browser's own
          // find bar sits, so it's where a visitor's eye already goes.
          Positioned(
            top: kToolbarHeight + 12,
            right: narrow ? 12 : 20,
            left: narrow ? 12 : null,
            width: narrow ? null : _barWidth,
            child: PageSearchBar(
              controller: _controller,
              showKeyHints: !narrow,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSearchInherited extends InheritedNotifier<PageSearchController> {
  const _PageSearchInherited({
    required PageSearchController super.notifier,
    required super.child,
  });
}
