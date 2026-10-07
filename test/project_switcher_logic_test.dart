import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/common/domain/technology.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_switcher_logic.dart';

void main() {
  const flutter = Technology(
    name: 'Flutter',
    icon: IconModel(assetName: 'assets/icons/software-development/flutter.svg'),
  );
  const dart = Technology(
    name: 'Dart',
    icon: IconModel(assetName: 'assets/icons/other/dart.svg'),
  );

  final caseStudy = Project(
    name: 'Case Alpha',
    description: 'A featured case study',
    featured: true,
    technologies: const [flutter, dart],
    links: const [
      Link(url: 'https://apps.apple.com/app/1', platform: LinkPlatform.ios),
      Link(
        url: 'https://play.google.com/store/apps/details?id=a',
        platform: LinkPlatform.android,
      ),
    ],
  );

  final package = Project(
    name: 'flutter_helper',
    description: 'A pub package',
    featured: false,
    technologies: const [flutter],
    url: 'https://pub.dev/packages/flutter_helper',
  );

  final githubOnly = Project(
    name: 'Side Project',
    description: 'On GitHub',
    url: 'https://github.com/someone/side',
  );

  test('projectPlatforms prefers link platforms and sniffs url fallback', () {
    expect(
      projectPlatforms(caseStudy),
      {LinkPlatform.ios, LinkPlatform.android},
    );
    expect(projectPlatforms(package), {LinkPlatform.pubdev});
    expect(projectPlatforms(githubOnly), {LinkPlatform.github});
  });

  test('filterProjects ANDs search, platform, and technology', () {
    final all = [caseStudy, package, githubOnly];

    expect(
      filterProjects(all, searchQuery: 'flutter').map((p) => p.name),
      ['flutter_helper'],
    );

    expect(
      filterProjects(
        all,
        searchQuery: '',
        platform: LinkPlatform.ios,
      ).map((p) => p.name),
      ['Case Alpha'],
    );

    expect(
      filterProjects(
        all,
        searchQuery: '',
        technology: 'Flutter',
        platform: LinkPlatform.pubdev,
      ).map((p) => p.name),
      ['flutter_helper'],
    );

    expect(
      filterProjects(
        all,
        searchQuery: 'nope',
        technology: 'Flutter',
      ),
      isEmpty,
    );
  });

  test('sectionProjects splits case studies from more shipped work', () {
    final sections = sectionProjects([caseStudy, package, githubOnly]);
    expect(sections.caseStudies.map((p) => p.name), ['Case Alpha']);
    expect(sections.more.map((p) => p.name), ['flutter_helper', 'Side Project']);
  });

  test('collectTechnologyNames and collectPlatforms are sorted / ordered', () {
    final all = [caseStudy, package, githubOnly];
    expect(collectTechnologyNames(all), ['Dart', 'Flutter']);
    expect(collectPlatforms(all), [
      LinkPlatform.ios,
      LinkPlatform.android,
      LinkPlatform.github,
      LinkPlatform.pubdev,
    ]);
  });

  test('collectTechnologyIcons keeps first non-null icon per name', () {
    final icons = collectTechnologyIcons([caseStudy, package]);
    expect(
      icons['Flutter']?.assetName,
      'assets/icons/software-development/flutter.svg',
    );
    expect(icons['Dart']?.assetName, 'assets/icons/other/dart.svg');
  });
}
