// Fit Check runs against the site's real content here, not fixtures: the
// failure that matters is the portfolio side over-claiming — a loose
// pattern turning some unrelated sentence into "evidence" — and that only
// shows up against the actual copy.

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/fit_check/application/fit_analyzer.dart';
import 'package:portfolio/src/features/fit_check/application/fit_summary.dart';
import 'package:portfolio/src/features/fit_check/domain/fit_report.dart';
import 'package:portfolio/src/features/fit_check/domain/skill_signal.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/localization/generated/locale_json.g.dart';

final _content = CodegenLoader.mapLocales['en']!;

List<Map<String, dynamic>> _list(String key) =>
    (_content[key] as List).cast<Map<String, dynamic>>();

FitAnalyzer _analyzer() => FitAnalyzer(
  experiences: _list('experiences').map(Experience.fromJson).toList(),
  projects: _list('projects').map(Project.fromJson).toList(),
  skills: [
    for (final category in _list('skillCategories'))
      ...(category['skills'] as List).cast<String>(),
  ],
  totalYears: int.parse((_content['stats'] as Map)['years'] as String),
);

RequirementMatch? _find(FitReport report, String id) =>
    report.requirements.where((r) => r.signal.id == id).firstOrNull;

void main() {
  group('the bundled sample brief', () {
    final sample = (_content['fitCheck'] as Map)['sampleText'] as String;
    final report = _analyzer().analyze(sample);

    test('links core skills to real roles and projects', () {
      for (final id in ['flutter', 'dart', 'firebase', 'riverpod', 'bloc']) {
        expect(_find(report, id)?.level, EvidenceLevel.proven, reason: id);
      }
      expect(
        _find(report, 'flutter')!.experiences.map(shortCompany),
        contains('Devxhub'),
      );
    });

    test('reports an honest gap instead of dropping the requirement', () {
      final graphql = _find(report, 'graphql');
      expect(graphql, isNotNull);
      expect(graphql!.level, EvidenceLevel.none);
      expect(graphql.priority, RequirementPriority.required);
    });

    test('a nice-to-have header demotes what follows it', () {
      expect(_find(report, 'kmp')?.priority, RequirementPriority.niceToHave);
      expect(_find(report, 'a11y')?.priority, RequirementPriority.niceToHave);
    });

    test('a skill asked for as required stays required', () {
      // Kotlin appears under Requirements and again, inside "Kotlin
      // Multiplatform", under Nice to have.
      expect(_find(report, 'kotlin')?.priority, RequirementPriority.required);
    });

    test('keeps two years asks in one sentence apart', () {
      expect(report.yearsCheck?.asked, 5);
      expect(report.yearsCheck?.met, isTrue);
      expect(_find(report, 'flutter')?.yearsAsked, 3);
    });

    test('ignores the benefits section', () {
      // "health insurance" under Benefits isn't a healthcare requirement.
      expect(_find(report, 'health'), isNull);
    });

    test('lists required skills before nice-to-haves', () {
      final priorities = report.requirements.map((r) => r.priority).toList();
      final firstNice = priorities.indexOf(RequirementPriority.niceToHave);
      expect(firstNice, greaterThan(0));
      expect(
        priorities.skip(firstNice),
        everyElement(RequirementPriority.niceToHave),
      );
    });

    test('offers strengths the brief did not ask for', () {
      final ids = report.alsoBrings.map((m) => m.signal.id);
      expect(ids, contains('openSource'));
      expect(ids, isNot(contains('offlineFirst')), reason: 'already asked');
    });

    test('summary counts match the report', () {
      final summary = buildFitSummary(
        report,
        name: 'Name',
        headline: 'Headline',
        siteUrl: 'https://example.com/',
      );
      expect(
        summary,
        contains(
          'Evidence for ${report.requiredEvidenced} of '
          '${report.requiredCount} required skills',
        ),
      );
      expect(summary, contains('✗ GraphQL'));
      expect(summary, contains('has 11 years in mobile'));
    });
  });

  group('patterns', () {
    SkillSignal signal(String id) => skillSignals.firstWhere((s) => s.id == id);

    test('are bounded so near-names do not collide', () {
      expect(signal('swift').regExp.hasMatch('SwiftUI only'), isFalse);
      expect(signal('java').regExp.hasMatch('JavaScript'), isFalse);
      expect(signal('react').regExp.hasMatch('React Native'), isFalse);
      expect(signal('react').regExp.hasMatch('React and React Native'), isTrue);
      expect(signal('cpp').regExp.hasMatch('Modern C++ (17)'), isTrue);
      expect(signal('rest').regExp.hasMatch('the rest of the team'), isFalse);
    });

    test('do not turn unrelated portfolio copy into evidence', () {
      final evidence = _analyzer()
          .analyze('Python. Remote across time zones. FinTech.')
          .requirements;
      List<String?> projectsFor(String id) => evidence
          .firstWhere((r) => r.signal.id == id)
          .projects
          .map((p) => p.name)
          .toList();
      // A tutorial app *about* Python.
      expect(projectsFor('python'), isEmpty);
      // A prayer-time package's "timezone support".
      expect(projectsFor('remote'), isEmpty);
      // Invoicing in a legal time-tracking app.
      expect(projectsFor('fintech'), isNot(contains('Hourwise')));
    });

    test('every signal id is unique', () {
      final ids = skillSignals.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  test('an inline "is a plus" demotes only its own sentence', () {
    final report = _analyzer().analyze(
      'You know Flutter well. Experience with GraphQL is a plus.',
    );
    expect(_find(report, 'flutter')?.priority, RequirementPriority.required);
    expect(_find(report, 'graphql')?.priority, RequirementPriority.niceToHave);
  });

  test('text with no recognisable skills gives an empty report', () {
    expect(_analyzer().analyze('We are a friendly team.').isEmpty, isTrue);
  });
}
