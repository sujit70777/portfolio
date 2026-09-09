import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/link.dart';

/// Links to the static legal pages required by the Play Store and App
/// Store (privacy-policy, terms, support, data-deletion). These are plain
/// HTML documents under web/, served directly by Apache — not Flutter
/// routes — so they go through [MyLink]'s url_launcher navigation rather
/// than Navigator/GoRouter, which would 404 on paths the app doesn't know.
class LegalLinksBar extends StatelessWidget {
  const LegalLinksBar({super.key});

  static const _links = {
    'Privacy Policy': '/privacy-policy/',
    'Terms of Service': '/terms/',
    'Support': '/support/',
    'Data Deletion': '/data-deletion/',
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.labelSmall,
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: _links.entries
            .map((entry) => MyLink(url: entry.value, displayLink: entry.key))
            .toList(),
      ),
    );
  }
}
