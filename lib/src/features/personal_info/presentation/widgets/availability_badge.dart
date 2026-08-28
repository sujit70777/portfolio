import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final signal = Theme.of(context).colorScheme.tertiary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: signal,
            boxShadow: [
              BoxShadow(
                color: signal.withAlpha(60),
                blurRadius: 6,
                spreadRadius: 3,
              ),
            ],
          ),
        ),
        gapW8,
        Text(
          tr(LocaleKeys.availabilityBadge).toUpperCase(),
          style: monoLabelStyle(
            fontSize: 12,
            letterSpacing: 0.06,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
          ),
        ),
      ],
    );
  }
}
