import 'package:flutter/material.dart';

/// A quiet phone-silhouette frame around [screen] — design brief 2's
/// signature device-frame motif, reused at hero scale and at
/// featured-project card scale. Deliberately plain: a rounded bezel, no
/// glass/glow/3D/scrim — the screenshot inside carries the visual weight,
/// not the frame around it.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.width, required this.screen});

  final double width;
  final Widget screen;

  /// Real screenshots are portrait ~9:19.5 — see
  /// assets/projectimage/tanto/ (414x896). Every device-framed screen uses
  /// that ratio so featured cards line up consistently regardless of a
  /// given screenshot's actual source resolution (screenshots are
  /// cover-fit inside).
  static const aspectRatio = 414 / 896;

  static const _bezelColor = Color(0xFF332C3D);
  static const _caseColor = Color(0xFF0A0810);

  @override
  Widget build(BuildContext context) {
    final height = width / aspectRatio;
    final bezelWidth = width * 0.032;
    final cornerRadius = width * 0.15;
    final screenRadius = cornerRadius - bezelWidth;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _caseColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          border: Border.all(color: _bezelColor, width: bezelWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(140),
              blurRadius: width * 0.36,
              offset: Offset(0, width * 0.18),
              spreadRadius: -width * 0.09,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(bezelWidth * 0.7),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenRadius),
            child: SizedBox.expand(child: screen),
          ),
        ),
      ),
    );
  }
}
