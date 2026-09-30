import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Made for FlexColorScheme version 7.0.0. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
//
// Color roles in this app (see general_section_desktop.dart, project_card.dart,
// experience_card.dart, app_bar.dart): `secondary` is the outer page/chrome
// background, `primary` is the content-pane/card surface (kept a touch lighter
// than `secondary` in dark mode / distinct in light mode for elevation without
// borders), and `tertiary` is the signal accent (design brief 2's "Signal") —
// gold on the dark theme, forest green on the light one — for links, status
// and the availability dot.
//
// Colour beyond that lives in constants/palette.dart: the emerald → mint →
// gold "aurora" for the signature moments (name, primary CTAs, the
// flagship card, the progress bar) and a family of hues giving each skill
// category, role and featured project its own identity. Add colour there,
// not as one-off literals, so light/dark pairs and contrast stay in one place.

// The three families below are referenced by the family names declared in
// pubspec.yaml `fonts:`, rather than through the google_fonts package. Both
// routes end up at the same .ttf in assets/fonts/, but the package re-reads
// those bytes through its own loader and registers a second FontFace for
// them, so every one of these faces was downloaded and decoded twice on
// first paint. Naming the bundled family directly renders identically for
// half the font bytes, and drops the dependency altogether.
//
// Display/headline/title all use a single Archivo weight (ExtraBold/800) —
// that's the only static instance bundled, so every heading-tier style below
// must request exactly FontWeight.w800 to get a match.
TextStyle _display({required double fontSize, double? height, double? letterSpacing}) {
  return TextStyle(
    fontFamily: 'Archivo',
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
  return TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacing,
    color: color,
  );
}

/// Secondary/muted text — eyebrows, location line, stat labels, captions.
/// Alpha 215 keeps it visibly quieter than body text while clearing WCAG AAA
/// (7:1) on every page/card/container background in both themes — ≥8:1
/// computed against the resolved onSurface values, not eyeballed. The
/// previous alpha 180 measured ~6.0:1 in light mode and failed AAA.
Color mutedTextColor(ColorScheme scheme) => scheme.onSurface.withAlpha(215);

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
  bodyLarge: TextStyle(fontFamily: 'PublicSans', fontSize: 18, height: 1.55),
  bodyMedium: TextStyle(fontFamily: 'PublicSans', fontSize: 16, height: 1.55),
  bodySmall: TextStyle(fontFamily: 'PublicSans', fontSize: 14, height: 1.5),
  labelLarge: TextStyle(fontFamily: 'PublicSans', fontSize: 16, fontWeight: FontWeight.w600),
  labelMedium: TextStyle(fontFamily: 'PublicSans', fontSize: 14, fontWeight: FontWeight.w600),
  labelSmall: TextStyle(fontFamily: 'PublicSans', fontSize: 12, fontWeight: FontWeight.w600),
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
    // Signal — the brand's forest green, deep enough for AA text/icon
    // contrast on both light backgrounds (~7:1 on white, ~6.3:1 on the
    // #eef0f2 chrome). The dark theme's gold only works on dark surfaces.
    tertiary: Color(0xff166534),
    tertiaryContainer: Color(0xffd6f0df),
    appBarColor: Color(0xffeef0f2),
    error: Color(0xffb00020),
  ),
  textTheme: _textTheme,
  // Anything that renders text without picking a family off the TextTheme —
  // Material internals like tooltips and dialogs, and any bare TextStyle —
  // otherwise falls through to Flutter's default family, Roboto, which isn't
  // bundled. On the web that means CanvasKit fetching Roboto from
  // fonts.gstatic.com at runtime: a cross-origin round trip for a face that
  // was never meant to appear in this design. Pointing the default at a
  // bundled family keeps every glyph local.
  fontFamily: 'PublicSans',
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
    // The brand's forest green, sampled from the OG card (web/og-preview.jpg)
    // and profile photo, so the site a visitor lands on is the card they
    // clicked. Content-pane / card surface — a touch lighter than the page
    // chrome for elevation, without relying on borders.
    primary: Color(0xff0d261c),
    primaryContainer: Color(0xff143326),
    // Outer page / chrome background — the card's near-black edge green.
    secondary: Color(0xff06150f),
    secondaryContainer: Color(0xff10291f),
    // Signal — the card's warm gold. Bright enough to be text/icon colour
    // on these near-black greens (~11:1).
    tertiary: Color(0xfffbc771),
    tertiaryContainer: Color(0xff3f3113),
    appBarColor: Color(0xff06150f),
    error: Color(0xffcf6679),
  ),
  textTheme: _textTheme,
  // Anything that renders text without picking a family off the TextTheme —
  // Material internals like tooltips and dialogs, and any bare TextStyle —
  // otherwise falls through to Flutter's default family, Roboto, which isn't
  // bundled. On the web that means CanvasKit fetching Roboto from
  // fonts.gstatic.com at runtime: a cross-origin round trip for a face that
  // was never meant to appear in this design. Pointing the default at a
  // bundled family keeps every glyph local.
  fontFamily: 'PublicSans',
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
