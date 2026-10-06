import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/page_search/presentation/page_search_scope.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

Widget _page() {
  return MaterialApp(
    home: Scaffold(
      body: PageSearchScope(
        // Not a lazy ListView: like the real page, every section is built,
        // so text far below the fold is still there to be found.
        child: SingleChildScrollView(
          child: Column(
            children: const [
              // Where the real page has its app bar.
              SizedBox(height: kToolbarHeight + 24),
              SearchableText('Senior Flutter engineer'),
              SizedBox(height: 1500),
              SearchableText('Swift, React Native and flutter_crdt_sync'),
              SizedBox(height: 1500),
              SearchableText('FLUTTER · DART'),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _pressEnter(WidgetTester tester, {bool shift = false}) async {
  if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.pumpAndSettle();
}

Future<void> _pressCtrlF(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Ctrl+F opens the bar and counts matches case-insensitively',
      (tester) async {
    await tester.pumpWidget(_page());
    expect(find.byType(TextField), findsNothing);

    await _pressCtrlF(tester);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('Enter steps through matches and wraps around', (tester) async {
    await tester.pumpWidget(_page());
    await _pressCtrlF(tester);
    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();

    await _pressEnter(tester);
    expect(find.text('2 / 3'), findsOneWidget);

    await _pressEnter(tester);
    expect(find.text('3 / 3'), findsOneWidget);
    // The last match is far down the list: stepping to it scrolled there.
    expect(
      tester.getTopLeft(find.textContaining('DART')).dy,
      lessThan(tester.view.physicalSize.height / tester.view.devicePixelRatio),
    );

    await _pressEnter(tester);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('Shift+Enter goes back, and Enter keeps working after an '
      'arrow is clicked', (tester) async {
    await tester.pumpWidget(_page());
    await _pressCtrlF(tester);
    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();

    await _pressEnter(tester, shift: true);
    expect(find.text('3 / 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);

    // The click left focus in the field, so the keys still drive search.
    await _pressEnter(tester);
    expect(find.text('3 / 3'), findsOneWidget);
    await _pressEnter(tester, shift: true);
    expect(find.text('2 / 3'), findsOneWidget);

    for (var i = 0; i < 6; i++) {
      await _pressEnter(tester);
    }
    expect(find.text('2 / 3'), findsOneWidget);
  });

  testWidgets('a query with no matches says so, and Esc closes the bar',
      (tester) async {
    await tester.pumpWidget(_page());
    await _pressCtrlF(tester);
    await tester.enterText(find.byType(TextField), 'kotlin');
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });
}
