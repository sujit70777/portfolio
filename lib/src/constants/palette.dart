import 'package:flutter/material.dart';

/// The site's colour system beyond the base [ColorScheme]: the "aurora"
/// gradient that marks the signature moments (the name, the primary CTA,
/// the flagship card, the reading-progress bar), and a family of hues that
/// gives each skill category, role and featured project its own identity.
///
/// The brand is the OG card's (web/og-preview.jpg): forest green with a
/// green-to-gold ring. The aurora is that ring, and gold leads the hues.
/// Every value has a light-theme twin deepened for contrast: the dark-theme
/// hues are all light enough to be text on the near-black greens, and the
/// light-theme ones clear WCAG AA (≥4.5:1) as text on white and on the
/// #eef0f2 page chrome.
@immutable
class Palette {
  const Palette._({
    required this.aurora,
    required this.hues,
    required this.button,
    required this.onAurora,
    required this.glowAlpha,
    required this.findMatch,
    required this.findCurrent,
    required this.onFind,
  });

  /// Emerald → mint → gold.
  final List<Color> aurora;

  /// Gold, emerald, cyan, coral, violet, pink, mint.
  final List<Color> hues;

  /// The two-stop fill behind primary buttons: gold into amber under dark
  /// text on the dark theme, like the card's gold stat boxes; the two
  /// deepest greens under white text on the light theme, AA across both.
  final List<Color> button;

  /// Text/icon colour that reads on top of an [aurora] or [button] fill.
  final Color onAurora;

  /// How strong ambient glows (hero backdrop, hover shadows) should be —
  /// lower on the light theme, where the same alpha reads as a stain.
  final int glowAlpha;

  /// Find-on-page (Cmd/Ctrl+F) highlights: every match, the one the
  /// visitor is on, and the text colour that reads on top of either. Warm
  /// and solid, like a browser's own find highlight, so a match is the
  /// loudest thing on the page whichever section it lands in.
  final Color findMatch;
  final Color findCurrent;
  final Color onFind;

  static const _dark = Palette._(
    aurora: [Color(0xff3ecf8e), Color(0xff8fe3b8), Color(0xfffbc771)],
    hues: [
      Color(0xfffbc771), // gold — the signal (dark tertiary)
      Color(0xff4ade80), // emerald
      Color(0xff5ee7ff), // cyan
      Color(0xffff9b7a), // coral
      Color(0xffc4b5fd), // violet
      Color(0xffff8cc6), // pink
      Color(0xff6ee7b7), // mint
    ],
    button: [Color(0xfffbc771), Color(0xfff0a93b)],
    onAurora: Color(0xff06150f),
    glowAlpha: 70,
    findMatch: Color(0xfffbc771),
    findCurrent: Color(0xffff9447),
    onFind: Color(0xff06150f),
  );

  static const _light = Palette._(
    aurora: [Color(0xff15803d), Color(0xff0f766e), Color(0xff8a5a00)],
    hues: [
      Color(0xff8a5a00), // gold, deepened
      Color(0xff15803d), // emerald
      Color(0xff0e7490), // cyan
      Color(0xffc2410c), // coral
      Color(0xff6d28d9), // violet
      Color(0xffbe185d), // pink
      Color(0xff047857), // mint
    ],
    button: [Color(0xff166534), Color(0xff0f766e)],
    onAurora: Color(0xffffffff),
    glowAlpha: 40,
    findMatch: Color(0xffffe08a),
    findCurrent: Color(0xffffa53d),
    onFind: Color(0xff1c1400),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;

  /// A stable hue for the [index]-th item in a list — wraps, so any list
  /// length works.
  Color hue(int index) => hues[index % hues.length];

  /// The hue for the [index]-th role in Experience, newest first — shared
  /// by the experience cards and the desktop version rail so a role's tag,
  /// rail dot and card always match. Starts at emerald, leaving gold to the
  /// signal elements around it.
  Color roleHue(int index) => hue(index + 1);

  /// The [aurora] as a left-to-right gradient.
  LinearGradient get auroraGradient => LinearGradient(colors: aurora);

  LinearGradient get buttonGradient => LinearGradient(colors: button);
}
