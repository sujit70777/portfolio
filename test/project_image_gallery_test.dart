import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image.dart';

const _project = Project(name: 'Tanto');
const _images = [
  'assets/projectimage/tanto/Frame 1.png',
  'assets/projectimage/tanto/Frame 2.png',
  'assets/projectimage/tanto/Frame 3.png',
  'assets/projectimage/tanto/Frame 4.png',
];

Future<void> _pumpCard(
  WidgetTester tester, {
  VoidCallback? onOuterTap,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        projectImagesProvider('Tanto').overrideWith((ref) async => _images),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: onOuterTap,
              child: const SizedBox(
                width: 300,
                child: ProjectImage(project: _project, isHovered: false),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a +N more badge sized to the remaining image count',
      (tester) async {
    await _pumpCard(tester);
    expect(find.text('+3 more'), findsOneWidget);
  });

  testWidgets('tapping the thumbnail opens the lightbox at image 1 with the project title',
      (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsOneWidget);
    expect(find.text('Tanto'), findsOneWidget);
  });

  testWidgets(
      'opening the gallery thumbnail does not also fire an ancestor tap handler',
      (tester) async {
    var outerTapCount = 0;
    await _pumpCard(tester, onOuterTap: () => outerTapCount++);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsOneWidget);
    expect(outerTapCount, 0);
  });

  testWidgets('right arrow key advances to the next image',
      (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('2 / 4'), findsOneWidget);
  });

  testWidgets('left arrow key wraps back to the last image from the first',
      (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('4 / 4'), findsOneWidget);
  });

  testWidgets('the close button dismisses the lightbox', (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsNothing);
  });

  testWidgets('the Escape key dismisses the lightbox', (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsNothing);
  });

  testWidgets('tapping the dimmed backdrop dismisses the lightbox',
      (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    // Top-left corner: outside the image, top bar, and nav buttons.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsNothing);
  });

  testWidgets('tapping the image itself does not dismiss the lightbox',
      (tester) async {
    await _pumpCard(tester);
    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    final center = tester.getCenter(find.byType(PageView));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    expect(find.text('1 / 4'), findsOneWidget);
  });

  testWidgets('a single-image project shows no badge and no counter',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectImagesProvider('Tanto')
              .overrideWith((ref) async => [_images.first]),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ProjectImage(project: _project, isHovered: false),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('more'), findsNothing);

    await tester.tap(find.byType(ProjectImage));
    await tester.pumpAndSettle();
    expect(find.textContaining('/'), findsNothing);
  });

  testWidgets('a project with no images renders no badge and stays untappable for the gallery',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectImagesProvider('Tanto').overrideWith((ref) async => []),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ProjectImage(project: _project, isHovered: false),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('more'), findsNothing);
    expect(find.byIcon(Icons.code), findsOneWidget);
  });
}
