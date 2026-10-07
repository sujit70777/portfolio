import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/conversion/domain/conversion_models.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/note_reader_dialog.dart';

const _first = Note(
  slug: 'first-note',
  title: 'First note title',
  description: 'About the first note.',
  tags: ['Flutter'],
  body: '**Lead.** Opening paragraph.\n\n- a bullet point',
);

const _second = Note(
  slug: 'second-note',
  title: 'Second note title',
  description: 'About the second note.',
  tags: ['Swift'],
  body: 'Second body text.',
);

Future<void> _pumpReader(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: const Scaffold(
            body: NoteReaderDialog(
              note: _first,
              allNotes: [_first, _second],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the note and steps to the next one', (tester) async {
    await _pumpReader(tester);

    expect(find.text('First note title'), findsOneWidget);
    expect(find.textContaining('a bullet point'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Second note title'), findsOneWidget);
    expect(find.text('First note title'), findsNothing);
  });

  testWidgets('arrow keys move between notes and stop at the ends',
      (tester) async {
    await _pumpReader(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('First note title'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Second note title'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Second note title'), findsOneWidget);
  });
}
