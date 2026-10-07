import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/features/project/domain/project.dart';

/// Storefronts a project is available on — from `links[].platform` or by
/// sniffing `url` when a project only has a single link field.
Set<LinkPlatform> projectPlatforms(Project project) {
  final platforms = <LinkPlatform>{};
  for (final link in project.links ?? const <Link>[]) {
    final platform = link.platform;
    if (platform != null) platforms.add(platform);
  }
  if (platforms.isEmpty) {
    final sniffed = platformFromUrl(project.url);
    if (sniffed != null) platforms.add(sniffed);
  }
  return platforms;
}

LinkPlatform? platformFromUrl(String? url) {
  final host = Uri.tryParse(url ?? '')?.host ?? '';
  if (host.contains('apps.apple.com')) return LinkPlatform.ios;
  if (host.contains('play.google.com')) return LinkPlatform.android;
  if (host.contains('github.com')) return LinkPlatform.github;
  if (host.contains('pub.dev')) return LinkPlatform.pubdev;
  if (host.isNotEmpty) return LinkPlatform.web;
  return null;
}

/// Unique technology names across [projects], sorted A–Z.
List<String> collectTechnologyNames(List<Project> projects) {
  return collectTechnologyIcons(projects).keys.toList();
}

/// Map of technology name → first non-null icon found across [projects].
/// Keys are sorted A–Z for stable dropdown order.
Map<String, IconModel?> collectTechnologyIcons(List<Project> projects) {
  final icons = <String, IconModel?>{};
  for (final project in projects) {
    for (final tech in project.technologies ?? const []) {
      final name = tech.name?.trim();
      if (name == null || name.isEmpty) continue;
      final current = icons[name];
      if (current == null && tech.icon != null) {
        icons[name] = tech.icon;
      } else {
        icons.putIfAbsent(name, () => null);
      }
    }
  }
  final sortedKeys = icons.keys.toList()..sort();
  return {for (final key in sortedKeys) key: icons[key]};
}

/// Platforms that appear at least once in [projects], in a stable display order.
List<LinkPlatform> collectPlatforms(List<Project> projects) {
  const order = [
    LinkPlatform.ios,
    LinkPlatform.android,
    LinkPlatform.web,
    LinkPlatform.github,
    LinkPlatform.pubdev,
  ];
  final present = <LinkPlatform>{};
  for (final project in projects) {
    present.addAll(projectPlatforms(project));
  }
  return order.where(present.contains).toList();
}

bool isCaseStudy(Project project) =>
    project.flagship == true || project.featured == true;

/// Applies search + platform + technology with AND. Preserves [projects] order.
List<Project> filterProjects(
  List<Project> projects, {
  required String searchQuery,
  LinkPlatform? platform,
  String? technology,
}) {
  final query = searchQuery.trim().toLowerCase();
  return projects.where((project) {
    if (query.isNotEmpty) {
      final name = (project.name ?? '').toLowerCase();
      if (!name.contains(query)) return false;
    }
    if (platform != null && !projectPlatforms(project).contains(platform)) {
      return false;
    }
    if (technology != null) {
      // Dropdown labels are trimmed; compare against trimmed names so a
      // trailing space in en.json cannot hide a matching project.
      final needle = technology.trim();
      final names = project.technologies
              ?.map((t) => t.name?.trim())
              .whereType<String>()
              .where((n) => n.isNotEmpty)
              .toSet() ??
          const <String>{};
      if (!names.contains(needle)) return false;
    }
    return true;
  }).toList();
}

typedef ProjectSections = ({List<Project> caseStudies, List<Project> more});

/// Splits filtered projects into the same tiers as the projects page.
ProjectSections sectionProjects(List<Project> filtered) {
  return (
    caseStudies: filtered.where(isCaseStudy).toList(),
    more: filtered.where((p) => !isCaseStudy(p)).toList(),
  );
}

/// Flat visible order: case studies first, then more shipped work.
List<Project> flattenSections(ProjectSections sections) => [
      ...sections.caseStudies,
      ...sections.more,
    ];
