import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/common/domain/technology.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';

const _alpha = Project(
  name: 'Alpha App',
  description: 'First case study',
  featured: true,
  technologies: [Technology(name: 'Flutter')],
  links: [
    Link(url: 'https://apps.apple.com/app/a', platform: LinkPlatform.ios),
  ],
);

const _beta = Project(
  name: 'Beta App',
  description: 'Second case study',
  featured: true,
  technologies: [Technology(name: 'Kotlin')],
  links: [
    Link(
      url: 'https://play.google.com/store/apps/details?id=b',
      platform: LinkPlatform.android,
    ),
  ],
);

const _gamma = Project(
  name: 'Gamma Package',
  description: 'Long-tail package',
  featured: false,
  technologies: [Technology(name: 'Flutter')],
  url: 'https://pub.dev/packages/gamma',
);

Future<void> _pumpModal(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Scaffold(
            body: ProjectDetailModal(
              project: _alpha,
              allProjects: const [_alpha, _beta, _gamma],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _listRow(String name) => find.descendant(
      of: find.byType(ListView),
      matching: find.text(name),
    );

void main() {
  testWidgets('switching list rows updates the detail title', (tester) async {
    await _pumpModal(tester);

    expect(find.text('Alpha App'), findsWidgets);

    await tester.tap(_listRow('Beta App'));
    await tester.pumpAndSettle();

    expect(find.text('Second case study'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(ProjectDetailModal),
        matching: find.text('Beta App'),
      ),
      findsWidgets,
    );
  });

  testWidgets('technology filter narrows the switcher list and swaps selection',
      (tester) async {
    await _pumpModal(tester);

    expect(_listRow('Alpha App'), findsOneWidget);
    expect(_listRow('Beta App'), findsOneWidget);
    expect(_listRow('Gamma Package'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('technology-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kotlin').last);
    await tester.pumpAndSettle();

    expect(_listRow('Beta App'), findsOneWidget);
    expect(_listRow('Alpha App'), findsNothing);
    expect(_listRow('Gamma Package'), findsNothing);
    expect(find.text('Second case study'), findsWidgets);
  });
}
