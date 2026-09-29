import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/fit_check/application/fit_summary.dart';
import 'package:portfolio/src/features/fit_check/domain/fit_report.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class FitResults extends StatelessWidget {
  const FitResults({
    super.key,
    required this.report,
    required this.onEmail,
    required this.onCopySummary,
  });

  final FitReport report;
  final VoidCallback? onEmail;
  final VoidCallback onCopySummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final years = report.yearsCheck;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (report.requiredCount > 0)
              _ScoreTile(
                value: '${report.requiredEvidenced}/${report.requiredCount}',
                label: 'required skills evidenced',
              ),
            if (report.niceCount > 0)
              _ScoreTile(
                value: '${report.niceEvidenced}/${report.niceCount}',
                label: 'nice-to-haves evidenced',
              ),
            if (years != null)
              _ScoreTile(
                value: '${years.have} yrs',
                label: 'in mobile · you asked ${years.asked}+',
                met: years.met,
              ),
          ],
        ),
        gapH24,
        for (final requirement in report.requirements) ...[
          _RequirementRow(match: requirement),
          Divider(height: 1, color: scheme.onSurface.withAlpha(20)),
        ],
        if (report.alsoBrings.isNotEmpty) ...[
          gapH24,
          Text(
            tr(LocaleKeys.fitCheck_alsoBrings).toUpperCase(),
            style: monoLabelStyle(
              fontSize: 11,
              letterSpacing: 0.06,
              color: mutedTextColor(scheme),
            ),
          ),
          gapH12,
          for (final match in report.alsoBrings)
            _RequirementRow(match: match, showPriority: false),
        ],
        gapH24,
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (onEmail != null)
              FilledButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(scheme.tertiary),
                  foregroundColor: WidgetStatePropertyAll(scheme.secondary),
                  shape: const WidgetStatePropertyAll(StadiumBorder()),
                ),
                onPressed: onEmail,
                icon: const Icon(Icons.mail_outline, size: 18),
                label: Text(tr(LocaleKeys.fitCheck_emailButton)),
              ),
            OutlinedButton.icon(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
                side: WidgetStatePropertyAll(
                  BorderSide(color: scheme.onSurface.withAlpha(60)),
                ),
                shape: const WidgetStatePropertyAll(StadiumBorder()),
              ),
              onPressed: onCopySummary,
              icon: const Icon(Icons.content_copy, size: 16),
              label: Text(tr(LocaleKeys.fitCheck_copySummaryButton)),
            ),
          ],
        ),
        gapH16,
        Text(
          tr(LocaleKeys.fitCheck_disclaimer),
          style: theme.textTheme.bodySmall?.copyWith(
            color: mutedTextColor(scheme),
          ),
        ),
      ],
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.value, required this.label, this.met});

  final String value;
  final String label;
  final bool? met;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: monoLabelStyle(fontSize: 22, color: scheme.tertiary),
              ),
              if (met != null) ...[
                gapW8,
                Icon(
                  met! ? Icons.check_circle : Icons.info_outline,
                  size: 18,
                  color: met! ? scheme.tertiary : mutedTextColor(scheme),
                ),
              ],
            ],
          ),
          gapH4,
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mutedTextColor(scheme)),
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends ConsumerWidget {
  const _RequirementRow({required this.match, this.showPriority = true});

  final RequirementMatch match;

  /// Off for "Also brings", which the brief didn't ask for at all.
  final bool showPriority;

  static const _maxProjects = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = mutedTextColor(scheme);

    final (icon, iconColor, semantics) = switch (match.level) {
      EvidenceLevel.proven => (Icons.check_circle, scheme.tertiary, 'Shown'),
      EvidenceLevel.listed => (Icons.adjust, muted, 'Listed skill'),
      EvidenceLevel.none => (Icons.remove_circle_outline, muted, 'Not shown'),
    };

    final projects = match.projects.take(_maxProjects).toList();
    final hiddenProjects = match.projects.length - projects.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
              semanticLabel: semantics,
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      match.signal.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (showPriority &&
                        match.priority == RequirementPriority.niceToHave)
                      const _Tag('nice to have'),
                    if (match.yearsAsked != null)
                      _Tag('asked ${match.yearsAsked}+ yrs'),
                  ],
                ),
                gapH8,
                switch (match.level) {
                  EvidenceLevel.none => Text(
                    tr(LocaleKeys.fitCheck_notShown),
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  EvidenceLevel.listed => Text(
                    '${tr(LocaleKeys.fitCheck_listedOnly)}: '
                    '${match.listedSkills.join(' · ')}',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  EvidenceLevel.proven => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final experience in match.experiences)
                        _EvidenceChip(
                          icon: Icons.work_outline,
                          label:
                              '${shortCompany(experience)} · '
                              '${dateRange(experience, tr(LocaleKeys.present))}',
                          tooltip: experience.role,
                          onTap: () =>
                              _scrollTo(ref.read(experienceSectionKeyProvider)),
                        ),
                      for (final project in projects)
                        _EvidenceChip(
                          icon: Icons.apps,
                          label: project.name ?? '',
                          tooltip: 'Open project',
                          onTap: () => _openProject(context, project),
                        ),
                      if (hiddenProjects > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '+$hiddenProjects more',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: muted,
                            ),
                          ),
                        ),
                    ],
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _openProject(BuildContext context, Project project) {
    showProjectDetailModal(context, project: project);
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.onSurface.withAlpha(60)),
      ),
      child: Text(
        label.toUpperCase(),
        style: monoLabelStyle(
          fontSize: 10,
          letterSpacing: 0.06,
          color: mutedTextColor(scheme),
        ),
      ),
    );
  }
}

/// Every chip is a link to the evidence itself — a role scrolls to
/// Experience, a project opens its detail modal — so nothing in the report
/// has to be taken on trust.
class _EvidenceChip extends StatefulWidget {
  const _EvidenceChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<_EvidenceChip> createState() => _EvidenceChipState();
}

class _EvidenceChipState extends State<_EvidenceChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final chip = Material(
      color: scheme.secondary,
      shape: StadiumBorder(
        side: BorderSide(
          color: _hovered ? scheme.tertiary : Colors.transparent,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: widget.onTap,
        onHover: (value) => setState(() => _hovered = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: scheme.tertiary),
              gapW8,
              Flexible(
                child: Text(
                  widget.label,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final tooltip = widget.tooltip;
    return tooltip == null ? chip : Tooltip(message: tooltip, child: chip);
  }
}
