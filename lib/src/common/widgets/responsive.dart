import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget desktop;
  final Widget? tablet;
  final Widget? mobile;

  const Responsive({
    super.key,
    required this.desktop,
    this.tablet,
    this.mobile,
  });

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 1024 &&
      MediaQuery.sizeOf(context).width >= 640;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 640;

  /// Minimum width for [GeneralSection]'s side-by-side split-screen desktop
  /// layout. That layout halves the viewport (minus fixed padding) between
  /// the hero and the scrolling content, so it needs meaningfully more room
  /// than the generic [isDesktop] cutoff — below this, devices like an iPad
  /// Pro in portrait (1024 wide) land exactly on that cutoff but only get
  /// ~1024/2 px for the hero column, which is too narrow for the desktop
  /// hero's Row layout and forces the name to wrap character-by-character.
  static bool isSplitScreenDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1280;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width;
    if (maxWidth < 640 && mobile != null) {
      return mobile!;
    } else if (maxWidth < 1024 && tablet != null) {
      return tablet!;
    } else {
      return desktop;
    }
  }
}
