import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/app.dart';
import 'package:portfolio/src/app_startup.dart';
import 'package:portfolio/src/features/general/presentation/general_section.dart';
import 'package:portfolio/src/localization/app_localizations.dart';
import 'package:portfolio/src/localization/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Boots the whole app the way main.dart does, at a desktop viewport, and
/// returns a list that collects whatever gets written to the clipboard.
Future<List<String>> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1440, 1000),
}) async {
  SharedPreferences.setMockInitialValues({});
  // rootBundle caches each asset's load future. One cached by an earlier
  // test belongs to that test's fake-async zone, whose microtasks nobody
  // flushes any more, so awaiting it here would hang startup forever.
  rootBundle.clear();
  await EasyLocalization.ensureInitialized();
  await _loadFonts();

  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final clipboard = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'Clipboard.setData') {
        clipboard.add((call.arguments as Map)['text'] as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );

  final supportedLocales = await AppLocalizations.supportedLocales();
  await tester.pumpWidget(
    ProviderScope(
      child: AppStartupWidget(
        onLoaded: (context) => Consumer(
          builder: (context, ref, child) {
            return ref
                .watch(localeControllerProvider)
                .when(
                  data: (_) => EasyLocalization(
                    supportedLocales: supportedLocales,
                    path: AppLocalizations.translationsPath,
                    fallbackLocale: supportedLocales.first,
                    child: const MyApp(),
                  ),
                  loading: () => const AppStartupLoadingWidget(),
                  error: (error, _) => Text(error.toString()),
                );
          },
        ),
      ),
    ),
  );
  // Startup loads the translations asset with real I/O, which never
  // completes under the test's fake clock — pumpAndSettle alone returns
  // while the app is still on its (empty) loading screen. Let real time
  // pass until the page itself is mounted.
  for (
    var i = 0;
    i < 100 && find.byType(GeneralSection).evaluate().isEmpty;
    i++
  ) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  expect(
    find.byType(GeneralSection),
    findsOneWidget,
    reason: 'the app never got past startup',
  );
  await tester.pumpAndSettle();
  return clipboard;
}

var _fontsLoaded = false;

/// The real faces, not the test framework's default, whose every glyph is
/// a full-width square: with it, text runs far wider than it does in a
/// browser and rows overflow that never overflow for a visitor.
Future<void> _loadFonts() async {
  if (_fontsLoaded) return;
  _fontsLoaded = true;
  const families = {
    'Archivo': ['assets/fonts/Archivo-ExtraBold.ttf'],
    'PublicSans': [
      'assets/fonts/PublicSans-Regular.ttf',
      'assets/fonts/PublicSans-SemiBold.ttf',
    ],
    'JetBrainsMono': ['assets/fonts/JetBrainsMono-Medium.ttf'],
  };
  for (final MapEntry(key: family, value: files) in families.entries) {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }
}
