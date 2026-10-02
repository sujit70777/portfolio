import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/themes.dart' as themes;
import 'package:portfolio/src/features/general/presentation/general_section.dart';
import 'package:portfolio/src/features/general/provider/dark_mode_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) => tr(LocaleKeys.name),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: themes.lightTheme,
      darkTheme: themes.darkTheme,
      themeMode: ref.watch(darkModeProvider).maybeWhen(
            data: (darkMode) => darkMode ? ThemeMode.dark : ThemeMode.light,
            orElse: () => ThemeMode.dark,
          ),
      // MaterialApp already cross-fades between `theme` and `darkTheme` when
      // themeMode changes; these two lines are that animation, configured.
      //
      // This used to be an AnimatedTheme wrapped around `child` in `builder`,
      // which looked like the same thing and wasn't. That widget samples
      // Theme.of(context) and animates towards it, but it sits *inside* the
      // animation MaterialApp is already running, so it chased a moving
      // target and settled on a stale one — leaving the app painted in the
      // previous theme while every provider, and the toggle itself, had
      // already moved on. That is the "I can't switch back" bug.
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeOutCubic,
      home: const GeneralSection(),
    );
  }
}
