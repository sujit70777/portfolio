import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/widgets/icon.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_switcher_logic.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

String _caseStudiesLabel() {
  try {
    return tr(LocaleKeys.sectionEyebrowProjects);
  } catch (_) {
    return 'Case studies';
  }
}

String _moreShippedLabel() {
  try {
    return tr(LocaleKeys.projectsMoreLabel);
  } catch (_) {
    return 'More projects';
  }
}

/// Search, technology filter, and the sectioned project list used by both
/// the desktop rail and the tablet/mobile drawer.
class ProjectSwitcherPanel extends StatelessWidget {
  const ProjectSwitcherPanel({
    super.key,
    required this.allProjects,
    required this.selected,
    this.selectedItemKey,
    required this.searchController,
    required this.searchFocusNode,
    required this.listFocusNode,
    required this.searchQuery,
    required this.technologyFilter,
    required this.onSearchChanged,
    required this.onTechnologyChanged,
    required this.onClearFilters,
    required this.onSelect,
  });

  final List<Project> allProjects;
  final Project selected;
  /// Attached to the selected row so arrow-key selection can scroll into view.
  final GlobalKey? selectedItemKey;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final FocusNode listFocusNode;
  final String searchQuery;
  final String? technologyFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTechnologyChanged;
  final VoidCallback onClearFilters;
  final ValueChanged<Project> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final technologyIcons = collectTechnologyIcons(allProjects);
    final technologies = technologyIcons.keys.toList();
    final filtered = filterProjects(
      allProjects,
      searchQuery: searchQuery,
      technology: technologyFilter,
    );
    final sections = sectionProjects(filtered);
    final hasFilters =
        searchQuery.trim().isNotEmpty || technologyFilter != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: onSearchChanged,
                textInputAction: TextInputAction.search,
                style: theme.textTheme.bodySmall,
                cursorColor: scheme.tertiary,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: scheme.secondary.withAlpha(140),
                  hintText: 'Search projects',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withAlpha(120),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: scheme.tertiary,
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: scheme.onSurface.withAlpha(160),
                          ),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: scheme.onSurface.withAlpha(24),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: scheme.tertiary.withAlpha(180),
                    ),
                  ),
                ),
              ),
              if (technologies.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'TECHNOLOGY',
                  style: monoLabelStyle(
                    fontSize: 10,
                    letterSpacing: 0.08,
                    color: scheme.onSurface.withAlpha(130),
                  ),
                ),
                const SizedBox(height: 6),
                _TechnologyFilterButton(
                  key: const ValueKey('technology-filter'),
                  value: technologyFilter,
                  technologies: technologies,
                  iconsByName: technologyIcons,
                  onChanged: onTechnologyChanged,
                ),
              ],
              if (hasFilters) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onClearFilters,
                    style: TextButton.styleFrom(
                      foregroundColor: scheme.tertiary,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear',
                      style: monoLabelStyle(
                        fontSize: 11,
                        color: scheme.tertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Divider(height: 1, color: scheme.onSurface.withAlpha(20)),
        Expanded(
          child: Focus(
            focusNode: listFocusNode,
            child: filtered.isEmpty
                ? _EmptyFilterState(
                    hasFilters: hasFilters,
                    onClear: onClearFilters,
                  )
                : Builder(
                    builder: (context) {
                      // Stable hue per project from its place in the full
                      // list — same wrapping family as skills categories —
                      // so colours don't reshuffle when filters change.
                      final palette = Palette.of(context);
                      Color hueFor(Project project) {
                        final index = allProjects.indexWhere(
                          (p) => p.name == project.name,
                        );
                        return palette.hue(index < 0 ? 0 : index);
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          if (sections.caseStudies.isNotEmpty) ...[
                            _SectionHeader(label: _caseStudiesLabel()),
                            for (final project in sections.caseStudies)
                              _SwitcherRow(
                                key: project.name == selected.name
                                    ? selectedItemKey
                                    : null,
                                project: project,
                                hue: hueFor(project),
                                selected: project.name == selected.name,
                                onTap: () => onSelect(project),
                              ),
                          ],
                          if (sections.more.isNotEmpty) ...[
                            _SectionHeader(label: _moreShippedLabel()),
                            for (final project in sections.more)
                              _SwitcherRow(
                                key: project.name == selected.name
                                    ? selectedItemKey
                                    : null,
                                project: project,
                                hue: hueFor(project),
                                selected: project.name == selected.name,
                                onTap: () => onSelect(project),
                              ),
                          ],
                        ],
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

/// Outlined pill control — same language as tech chips / locale chrome.
class _TechnologyFilterButton extends StatelessWidget {
  const _TechnologyFilterButton({
    super.key,
    required this.value,
    required this.technologies,
    required this.iconsByName,
    required this.onChanged,
  });

  final String? value;
  final List<String> technologies;
  final Map<String, IconModel?> iconsByName;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final active = value != null;
    final label = value ?? 'All technologies';
    final selectedIcon = value == null ? null : iconsByName[value];

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.primary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: const WidgetStatePropertyAll(8),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 6)),
        maximumSize: WidgetStatePropertyAll(
          Size(280, MediaQuery.sizeOf(context).height * 0.5),
        ),
      ),
      builder: (context, controller, _) {
        return Material(
          color: active
              ? scheme.tertiary.withAlpha(28)
              : scheme.secondary.withAlpha(160),
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: active
                      ? scheme.tertiary.withAlpha(160)
                      : scheme.onSurface.withAlpha(28),
                ),
              ),
              child: Row(
                children: [
                  _TechIcon(icon: selectedIcon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    controller.isOpen
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: active
                        ? scheme.tertiary
                        : scheme.onSurface.withAlpha(160),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      menuChildren: [
        _TechMenuItem(
          label: 'All technologies',
          icon: null,
          selected: value == null,
          onPressed: () => onChanged(null),
        ),
        for (final tech in technologies)
          _TechMenuItem(
            label: tech,
            icon: iconsByName[tech],
            selected: value == tech,
            onPressed: () => onChanged(tech),
          ),
      ],
    );
  }
}

class _TechIcon extends StatelessWidget {
  const _TechIcon({required this.icon, this.size = 18});

  final IconModel? icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: MyIcon(
        icon: icon,
        size: size,
        placeholder: Icon(
          Icons.memory_rounded,
          size: size - 2,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
        ),
      ),
    );
  }
}

class _TechMenuItem extends StatelessWidget {
  const _TechMenuItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconModel? icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return MenuItemButton(
      onPressed: onPressed,
      leadingIcon: _TechIcon(icon: icon, size: 18),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          selected ? scheme.tertiary.withAlpha(28) : null,
        ),
      ),
      trailingIcon: selected
          ? Icon(Icons.check_rounded, size: 16, color: scheme.tertiary)
          : null,
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: monoLabelStyle(
          fontSize: 10,
          letterSpacing: 0.08,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
        ),
      ),
    );
  }
}

class _SwitcherRow extends StatelessWidget {
  const _SwitcherRow({
    super.key,
    required this.project,
    required this.hue,
    required this.selected,
    required this.onTap,
  });

  final Project project;
  final Color hue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Same wash language as skill category cards / chips.
    final bg = selected
        ? Color.alphaBlend(hue.withAlpha(36), theme.colorScheme.primary)
        : Colors.transparent;
    return Semantics(
      button: true,
      selected: selected,
      label: project.name ?? 'Project',
      child: Material(
        color: bg,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: hue,
                    borderRadius: BorderRadius.circular(2.5),
                    boxShadow: [
                      BoxShadow(color: hue.withAlpha(100), blurRadius: 6),
                    ],
                  ),
                ),
                gapW8,
                SizedBox(
                  width: 24,
                  height: 24,
                  child: MyIcon(
                    icon: project.icon,
                    size: 18,
                    placeholder: Icon(
                      Icons.code,
                      size: 16,
                      color: hue.withAlpha(180),
                    ),
                  ),
                ),
                gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.5,
                          height: 1.2,
                          color: hue,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                      if ((project.description ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          project.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11,
                            height: 1.25,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurface.withAlpha(110),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No projects match',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            gapH8,
            Text(
              'Try clearing search or the technology filter.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              gapH16,
              TextButton(
                onPressed: onClear,
                child: Text(
                  'Clear',
                  style: monoLabelStyle(
                    fontSize: 12,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
