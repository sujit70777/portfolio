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
// borders), and `tertiary` is the single accent used for hover states, links,
// and CTAs.

final _textTheme = TextTheme(
  displayLarge: GoogleFonts.spaceGrotesk(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: -1.0,
  ),
  displayMedium: GoogleFonts.spaceGrotesk(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.1,
  ),
  displaySmall: GoogleFonts.spaceGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.15,
  ),
  headlineLarge: GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  ),
  headlineSmall: GoogleFonts.spaceGrotesk(
    fontSize: 26,
    fontWeight: FontWeight.w600,
  ),
  titleLarge: GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  titleSmall: GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  bodyLarge: GoogleFonts.inter(fontSize: 18, height: 1.5),
  bodyMedium: GoogleFonts.inter(fontSize: 16, height: 1.5),
  bodySmall: GoogleFonts.inter(fontSize: 14, height: 1.4),
  labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
  labelMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
  labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
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
    // Content-pane / card surface — a clean white lift above the page bg.
    primary: Color(0xffffffff),
    primaryContainer: Color(0xffeff3f4),
    // Outer page / chrome background — soft off-white, not stark white.
    secondary: Color(0xfff7f8fa),
    secondaryContainer: Color(0xffe2e8ec),
    // Accent — teal, used for hover states, links and CTAs.
    tertiary: Color(0xff0f766e),
    tertiaryContainer: Color(0xffccfbf1),
    appBarColor: Color(0xfff7f8fa),
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
    // elevation, without relying on borders.
    primary: Color(0xff141a21),
    primaryContainer: Color(0xff1c242d),
    // Outer page / chrome background — near-black, not pure #000.
    secondary: Color(0xff0b0f14),
    secondaryContainer: Color(0xff1b2530),
    // Accent — bright teal, used for hover states, links and CTAs.
    tertiary: Color(0xff2dd4bf),
    tertiaryContainer: Color(0xff0f766e),
    appBarColor: Color(0xff0b0f14),
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
