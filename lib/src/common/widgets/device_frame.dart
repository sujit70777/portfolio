import 'package:flutter/material.dart';

/// A quiet phone-silhouette frame around [screen] — design brief 2's
/// signature device-frame motif, reused at hero scale and at
/// featured-project card scale. Deliberately plain: a rounded bezel and a
/// notch, no glass/glow/3D — the screenshot inside carries the visual
/// weight, not the frame around it.
///
/// [screen] gets a subtle dark scrim regardless of its own colors — a
/// prototype pass surfaced that an arbitrary screenshot's own brand colors
/// (a client's app, not this site's) can otherwise compete with the
/// Signal accent right next to it. The scrim reads any screenshot as "the
/// app's own UI, recessed behind this page's chrome" rather than a color
/// clash, without needing to hand-tune per-screenshot.
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
          padding: EdgeInsets.all(bezelWidth * 2.4),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(screenRadius),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(90),
                        Colors.black.withAlpha(35),
                        Colors.black.withAlpha(130),
                      ],
                    ),
                  ),
                  child: SizedBox.expand(child: screen),
                ),
              ),
              Positioned(
                top: width * 0.02,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: width * 0.32,
                    height: width * 0.045,
                    decoration: BoxDecoration(
                      color: _caseColor,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
