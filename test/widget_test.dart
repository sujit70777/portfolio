import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portfolio/src/app.dart';
import 'package:portfolio/src/app_startup.dart';
import 'package:portfolio/src/localization/app_localizations.dart';
import 'package:portfolio/src/localization/locale_controller.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('MyApp renders without throwing', (WidgetTester tester) async {
    final supportedLocales = await AppLocalizations.supportedLocales();

    await tester.pumpWidget(
      ProviderScope(
        child: AppStartupWidget(
          onLoaded: (context) {
            return Consumer(
              builder: (context, ref, child) {
                final localeControllerState =
                    ref.watch(localeControllerProvider);
                return localeControllerState.when(
                  data: (_) => EasyLocalization(
                    supportedLocales: supportedLocales,
                    path: AppLocalizations.translationsPath,
                    fallbackLocale: supportedLocales.first,
                    child: const MyApp(),
                  ),
                  loading: () => const AppStartupLoadingWidget(),
                  error: (error, stackTrace) => AppStartupErrorWidget(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(localeControllerProvider),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
