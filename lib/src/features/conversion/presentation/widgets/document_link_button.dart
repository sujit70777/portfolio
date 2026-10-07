import 'package:flutter/material.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// Text or outlined link that opens a document/URL and tracks an analytics event.
class DocumentLinkButton extends StatelessWidget {
  const DocumentLinkButton({
    super.key,
    required this.label,
    required this.url,
    required this.analyticsEvent,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final String url;
  final String analyticsEvent;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 6),
              Text(label),
            ],
          );

    Future<void> onTap() async {
      Analytics.track(analyticsEvent);
      try {
        await LaunchUrlHelper.launchURL(url, openInNewTab: true);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
        }
      }
    }

    if (outlined) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.colorScheme.tertiary.withAlpha(160)),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: theme.textTheme.labelMedium,
        ),
        child: child,
      );
    }

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.tertiary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        textStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: theme.colorScheme.tertiary.withAlpha(120),
        ),
      ),
      child: child,
    );
  }
}
