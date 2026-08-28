import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio/src/app.dart';
import 'package:portfolio/src/app_startup.dart';
import 'package:portfolio/src/localization/app_localizations.dart';
import 'package:portfolio/src/localization/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Space Grotesk and Inter are bundled locally (see pubspec.yaml `fonts:`
  // and assets/fonts/) under the exact filenames google_fonts looks for, so
  // GoogleFonts.spaceGrotesk()/inter() in themes.dart resolve from the app
  // bundle. This flag turns a naming mismatch into a hard failure instead of
  // a silent fetch from fonts.gstatic.com that would block first text paint.
  GoogleFonts.config.allowRuntimeFetching = false;
  EasyLocalization.logger.enableBuildModes = [];
  usePathUrlStrategy();
  final supportedLocales = await AppLocalizations.supportedLocales();
  runApp(
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
}
