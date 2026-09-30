import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/rich_description.dart';
import 'package:portfolio/src/common/widgets/technology_wrap_chips.dart';
import 'package:portfolio/src/common/widgets/wrap_links.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/features/experience/presentation/widgets/experience_date_text.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// One role in the Experience timeline, keyed to its own [hue]: a lit
/// accent edge on the left, a tinted border, and — on hover — a lift and a
/// glow in the same colour.
class ExperienceCard extends ConsumerStatefulWidget {
  const ExperienceCard({
    super.key,
    required this.experience,
    required this.hue,
  });

  final Experience experience;
  final Color hue;

  @override
  ConsumerState<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends ConsumerState<ExperienceCard> {
  bool _hovered = false;

  static const _radius = 20.0;
  static const _accentWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experience = widget.experience;
    final hue = widget.hue;

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12 + _accentWidth + 8, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  experience.role ?? "",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              gapW24,
              if (!Responsive.isMobile(context))
                ExperienceDateText(experience: experience),
            ],
          ),
          gapH4,
          Text(
            experience.company ?? "",
            style: theme.textTheme.titleMedium?.copyWith(color: hue),
          ),
          if (Responsive.isMobile(context)) ...[
            gapH4,
            ExperienceDateText(experience: experience),
          ],
          gapH12,
          RichDescription(
            text: experience.description ?? "",
            markerColors: [hue],
            subheadingColor: hue,
          ),
          gapH12,
          if (experience.links?.isNotEmpty == true) ...[
            WrapLinks(links: experience.links!),
            gapH12,
          ] else
            gapH4,
          if (experience.technologies != null)
            TechnologyWrapChips(technologies: experience.technologies!),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            hue.withAlpha(_hovered ? 16 : 8),
            theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: hue.withAlpha(_hovered ? 140 : 50),
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: hue.withAlpha(_hovered ? 36 : 0),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(_radius),
          child: InkWell(
            mouseCursor: WidgetStateMouseCursor.textable,
            onTap: () => _onTap(context),
            hoverColor: Colors.transparent,
            splashColor: hue.withAlpha(30),
            highlightColor: hue.withAlpha(20),
            child: MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: Stack(
                children: [
                  content,
                  // The accent edge: the role's hue, fading down the card.
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: _accentWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [hue, hue.withAlpha(_hovered ? 120 : 30)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    final url = widget.experience.url;
    if (url == null) return;
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }
}
