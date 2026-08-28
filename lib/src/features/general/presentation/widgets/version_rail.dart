import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';

/// Desktop-only left-margin index for the Experience/Projects run —
/// design brief 2's version/changelog wayfinding motif, made structural
/// rather than decorative: it doesn't exist at any narrower breakpoint,
/// it's real extra real estate only this width can afford.
///
/// Static, not scroll-synced to the active section — a true sticky,
/// position-tracking rail needs behavior this pass couldn't visually
/// verify (no browser/Flutter runtime available), so it was simplified to
/// a plain marker column rather than shipped as an untested scroll
/// listener. Worth revisiting once it can be seen running.
class VersionRail extends StatelessWidget {
  const VersionRail({super.key, required this.count});

  /// Number of markers to show, current/highest first — e.g. 4 shows
  /// v4 (highlighted, current) down to v1.
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final version = count - index;
        final isCurrent = index == 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent ? theme.colorScheme.tertiary : null,
                  border: isCurrent
                      ? null
                      : Border.all(
                          color: theme.colorScheme.onSurface.withAlpha(90),
                        ),
                ),
              ),
              gapW8,
              Text(
                'v$version',
                style: monoLabelStyle(
                  fontSize: 13,
                  color: isCurrent
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
