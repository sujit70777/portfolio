import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/icon.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// A pill-shaped contact chip — icon plus label, always visible (not hidden
/// behind a hover-only tooltip) so it reads at a glance. Styled to match
/// [ResumeButton]'s outlined/hover treatment for a consistent CTA language.
/// Hover/pressed state comes from [OutlinedButton]'s own [WidgetStateProperty]
/// resolution — no manual MouseRegion/setState bookkeeping needed.
class ContactIconButton extends StatelessWidget {
  const ContactIconButton({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final contactUrl = contact.url;
    final contactTooltip = contact.tooltip;
    if (contactUrl == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final icon = MyIcon(
      icon: contact.icon,
      size: 18,
      placeholder: const Icon(Icons.link, size: 18),
    );

    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.hovered)
              ? theme.colorScheme.tertiary
              : theme.colorScheme.onSurface;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.hovered)
              ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
              : theme.colorScheme.primary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final isHovered = states.contains(WidgetState.hovered);
          return BorderSide(
            width: isHovered ? 2 : 1,
            color: isHovered
                ? theme.colorScheme.tertiary
                : theme.colorScheme.secondaryContainer,
          );
        }),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
      ),
      onPressed: () => _onTap(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // contactTooltip is also the visible label below when present, so
          // the icon only needs its own Semantics label in the icon-only
          // fallback case — otherwise the button's Text already covers it.
          contactTooltip == null
              ? Semantics(label: contactUrl, child: icon)
              : icon,
          if (contactTooltip != null) ...[
            gapW8,
            Text(contactTooltip, style: theme.textTheme.labelMedium),
          ],
        ],
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final contactUrl = contact.url;
    if (contactUrl == null) return;
    try {
      await LaunchUrlHelper.launchURL(contactUrl);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: contactUrl);
      }
    }
  }
}
