import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Made for FlexColorScheme version 7.0.0. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
//
// Color roles in this app (see general_section_desktop.dart, project_card.dart,
// experience_card.dart, app_bar.dart): `secondary` is the outer page/chrome
// background, `primary` is the content-pane/card surface (kept a touch lighter
// than `secondary` in dark mode / distinct in light mode for elevation without
// borders), and `tertiary` is the single accent (design brief 2's "Signal") —
// a saturated chartreuse, used sparingly: CTAs, links, version/rating tags.
// Never a gradient or a glow, always a flat fill or text color.

// Display/headline/title all use a single Archivo weight (ExtraBold/800) —
// that's the only static instance bundled (see pubspec.yaml `fonts:` and
// assets/fonts/), so every heading-tier style below must request exactly
// FontWeight.w800 or google_fonts won't find a local match for it.
TextStyle _display({required double fontSize, double? height, double? letterSpacing}) {
  return GoogleFonts.archivo(
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// The utility/data face (JetBrains Mono) — version tags, stat numbers,
/// section eyebrows, availability line, tech-stack pills. Never body prose.
TextStyle monoLabelStyle({
  double fontSize = 13,
  Color? color,
  double letterSpacing = 0.02,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacing,
    color: color,
  );
}

final _textTheme = TextTheme(
  displayLarge: _display(fontSize: 64, height: 1.02, letterSpacing: -0.5),
  displayMedium: _display(fontSize: 40, height: 1.05, letterSpacing: -0.3),
  displaySmall: _display(fontSize: 32, height: 1.1),
  headlineLarge: _display(fontSize: 32, height: 1.1),
  headlineMedium: _display(fontSize: 28, height: 1.15),
  headlineSmall: _display(fontSize: 24, height: 1.15),
  titleLarge: _display(fontSize: 22, height: 1.2),
  titleMedium: _display(fontSize: 18, height: 1.2),
  titleSmall: _display(fontSize: 16, height: 1.2),
  bodyLarge: GoogleFonts.publicSans(fontSize: 18, height: 1.55),
  bodyMedium: GoogleFonts.publicSans(fontSize: 16, height: 1.55),
  bodySmall: GoogleFonts.publicSans(fontSize: 14, height: 1.5),
  labelLarge: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w600),
  labelMedium: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w600),
  labelSmall: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600),
);

const _subThemesData = FlexSubThemesData(
  interactionEffects: false,
  tintedDisabledControls: false,
  inputDecoratorBorderType: FlexInputBorderType.underline,
  inputDecoratorUnfocusedBorderIsColored: false,
  chipRadius: 20.0,
  tooltipRadius: 4.0,
  tooltipSchemeColor: SchemeColor.inverseSurface,
  tooltipOpacity: 0.9,
  snackBarElevation: 6.0,
  snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
  navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
  navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
  navigationBarMutedUnselectedLabel: false,
  navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
  navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
  navigationBarMutedUnselectedIcon: false,
  navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
  navigationBarIndicatorOpacity: 1.00,
  navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
  navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
  navigationRailMutedUnselectedLabel: false,
  navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
  navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
  navigationRailMutedUnselectedIcon: false,
  navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
  navigationRailIndicatorOpacity: 1.00,
  navigationRailBackgroundSchemeColor: SchemeColor.surface,
  navigationRailLabelType: NavigationRailLabelType.none,
);

final lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    // Content-pane / card surface — clean white lift above the page bg.
    primary: Color(0xffffffff),
    primaryContainer: Color(0xfff3f4ef),
    // Outer page / chrome background — cool, neutral off-white (not warm
    // cream — deliberately not the "cream + terracotta" default look).
    secondary: Color(0xffeef0f2),
    secondaryContainer: Color(0xffe2e5e4),
    // Signal — chartreuse, deepened for AA text/icon contrast on light
    // backgrounds (5.5:1 on secondary, 6.3:1 on white — verified, not
    // eyeballed). The bright value only ever appears as a fill (see dark
    // tertiary below and tertiaryContainer), never as light-mode text.
    tertiary: Color(0xff4e6810),
    tertiaryContainer: Color(0xffe3f2b0),
    appBarColor: Color(0xffeef0f2),
    error: Color(0xffb00020),
  ),
  textTheme: _textTheme,
  subThemesData: _subThemesData,
  keyColors: const FlexKeyColors(
    useSecondary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
    keepSecondaryContainer: true,
    keepTertiaryContainer: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);

final darkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    // Content-pane / card surface — a touch lighter than the page bg for
    // elevation, without relying on borders. Warm plum-charcoal, not a cool
    // blue-black — deliberately not the near-black-plus-teal default look.
    primary: Color(0xff1e1922),
    primaryContainer: Color(0xff2a2430),
    // Outer page / chrome background.
    secondary: Color(0xff15121a),
    secondaryContainer: Color(0xff241f2b),
    // Signal — bright chartreuse. Full brightness is safe as text/icon
    // color here since the background is near-black (very high contrast).
    tertiary: Color(0xffd7ff3b),
    tertiaryContainer: Color(0xff3a4014),
    appBarColor: Color(0xff15121a),
    error: Color(0xffcf6679),
  ),
  textTheme: _textTheme,
  subThemesData: _subThemesData,
  keyColors: const FlexKeyColors(
    useSecondary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
    keepSecondaryContainer: true,
    keepTertiaryContainer: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);
