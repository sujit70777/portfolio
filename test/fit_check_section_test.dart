import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/fit_check/presentation/fit_check_section.dart';
import 'package:portfolio/src/features/fit_check/presentation/widgets/fit_results.dart';
import 'package:portfolio/src/features/general/presentation/general_section.dart';
import 'package:portfolio/src/features/general/presentation/widgets/deep_link_handler.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/localization/generated/locale_json.g.dart';
import 'package:portfolio/src/utils/slugify.dart';

import 'helpers/pump_portfolio.dart';

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the sample brief produces a linked, honest report', (
    tester,
  ) async {
    final clipboard = await pumpPortfolio(tester);

    await _tapVisible(tester, find.text('Try a sample'));

    expect(find.byType(FitResults), findsOneWidget);
    expect(find.text('required skills evidenced'), findsOneWidget);
    final results = find.byType(FitResults);
    expect(
      find.descendant(of: results, matching: find.text('GraphQL')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: results,
        matching: find.text(
          'Not shown on this site. Happy to talk it through.',
        ),
      ),
      findsWidgets,
    );

    await _tapVisible(tester, find.text('Copy summary'));
    expect(clipboard.single, contains('✗ GraphQL'));
    expect(clipboard.single, contains('https://ehsanur.com/'));
  });

  testWidgets('an evidence chip opens the project it points at', (
    tester,
  ) async {
    await pumpPortfolio(tester);
    await _tapVisible(tester, find.text('Try a sample'));

    final chip = find
        .descendant(
          of: find.byType(FitResults),
          matching: find.text('Hourwise'),
        )
        .first;
    await _tapVisible(tester, chip);

    expect(find.byType(ProjectDetailModal), findsOneWidget);
  });

  testWidgets('too little text asks for more instead of guessing', (
    tester,
  ) async {
    await pumpPortfolio(tester);
    final field = find.descendant(
      of: find.byType(FitCheckSection),
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(field);
    await tester.enterText(field, 'Flutter');
    await _tapVisible(tester, find.text('Check fit'));

    expect(find.byType(FitResults), findsNothing);
    expect(
      find.text('Paste a little more of the description first.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'a shared project link opens that project, and can be re-copied',
    (tester) async {
      final clipboard = await pumpPortfolio(tester);

      // Mounted the way GeneralSection mounts it, with a URL to act on.
      Overlay.of(tester.element(find.byType(GeneralSection))).insert(
        OverlayEntry(
          builder: (_) => DeepLinkHandler(
            uri: Uri.parse('https://ehsanur.com/?project=hourwise'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      final modal = find.byType(ProjectDetailModal);
      expect(modal, findsOneWidget);
      expect(
        find.descendant(of: modal, matching: find.text('Hourwise')),
        findsWidgets,
      );

      await tester.tap(find.text('Copy link'));
      await tester.pump();
      expect(clipboard.single, 'https://ehsanur.com/?project=hourwise');
      expect(find.text('Link copied'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets('the report lays out at phone width', (tester) async {
    // Any RenderFlex overflow fails the test on its own.
    await pumpPortfolio(tester, size: const Size(390, 844));
    await _tapVisible(tester, find.text('Try a sample'));
    expect(find.byType(FitResults), findsOneWidget);
  });

  test('every project has a unique share slug', () {
    // Two projects slugifying alike would make one of them unreachable
    // from a shared link.
    final names = (CodegenLoader.mapLocales['en']!['projects'] as List).map(
      (p) => (p as Map)['name'] as String,
    );
    final slugs = names.map(slugify).toList();
    expect(slugs.toSet().length, slugs.length);
    expect(slugs, everyElement(isNotEmpty));
  });
}
