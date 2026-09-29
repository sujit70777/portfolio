import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/fit_check/domain/fit_report.dart';
import 'package:portfolio/src/features/fit_check/domain/skill_signal.dart';
import 'package:portfolio/src/features/project/domain/project.dart';

/// Matches a pasted job description or project brief against this site's
/// own content, entirely in-process: no network, no model, nothing stored.
/// That's the point — recruiters often can't paste a client's brief into a
/// third-party AI tool, and a deterministic keyword match can't invent
/// experience that isn't on the page.
class FitAnalyzer {
  FitAnalyzer({
    required List<Experience> experiences,
    required List<Project> projects,
    required List<String> skills,
    required this.totalYears,
    List<SkillSignal> signals = skillSignals,
  }) : _signals = signals,
       _experiences = [for (final e in experiences) (e, _experienceText(e))],
       _projects = [for (final p in projects) (p, _projectText(p))],
       _skills = skills;

  final List<SkillSignal> _signals;
  final List<(Experience, String)> _experiences;
  final List<(Project, String)> _projects;
  final List<String> _skills;

  /// The headline "years in mobile" figure, used to answer a brief's
  /// general years ask.
  final int totalYears;

  /// Signals whose presence in a sentence makes an "N+ years" ask
  /// skill-specific rather than a general years-of-experience ask.
  static const _generalYearsSignals = {
    'leadership',
    'remote',
    'collaboration',
    'agile',
    'ownership',
  };

  FitReport analyze(String text) {
    final asked = <String, _Ask>{};
    int? generalYears;

    for (final clause in _clauses(text)) {
      final found = [
        for (final signal in _signals)
          if (signal.regExp.hasMatch(clause.text)) signal,
      ];
      for (final signal in found) {
        final previous = asked[signal.id];
        // A skill named as both required and nice-to-have is required.
        final priority = previous?.priority == RequirementPriority.required
            ? RequirementPriority.required
            : clause.priority;
        asked[signal.id] = _Ask(priority, previous?.years);
      }

      for (final (years, segments) in _yearsAsks(clause.text)) {
        var specific = const <SkillSignal>[];
        // The skill usually follows the number ("3+ years with Flutter");
        // fall back to what precedes it ("Flutter: 3+ years").
        for (final segment in segments) {
          specific = [
            for (final signal in found)
              if (!_generalYearsSignals.contains(signal.id) &&
                  signal.regExp.hasMatch(segment))
                signal,
          ];
          if (specific.isNotEmpty) break;
        }
        if (specific.isEmpty) {
          if (generalYears == null || years > generalYears) {
            generalYears = years;
          }
          continue;
        }
        for (final signal in specific) {
          final ask = asked[signal.id]!;
          asked[signal.id] = _Ask(ask.priority, years);
        }
      }
    }

    final requirements =
        <RequirementMatch>[
          for (final signal in _signals)
            if (asked[signal.id] case final ask?)
              _match(signal, ask.priority, ask.years),
        ]..sort((a, b) {
          final byPriority = a.priority.index.compareTo(b.priority.index);
          if (byPriority != 0) return byPriority;
          return a.level.index.compareTo(b.level.index);
        });

    final alsoBrings = [
      for (final signal in _signals)
        if (signal.differentiator && !asked.containsKey(signal.id))
          _match(signal, RequirementPriority.niceToHave, null),
    ].where((m) => m.level == EvidenceLevel.proven).toList();

    return FitReport(
      requirements: requirements,
      alsoBrings: alsoBrings,
      yearsCheck: generalYears == null
          ? null
          : YearsCheck(asked: generalYears, have: totalYears),
    );
  }

  RequirementMatch _match(
    SkillSignal signal,
    RequirementPriority priority,
    int? years,
  ) {
    final re = signal.regExp;
    return RequirementMatch(
      signal: signal,
      priority: priority,
      yearsAsked: years,
      experiences: [
        for (final (experience, text) in _experiences)
          if (re.hasMatch(text)) experience,
      ],
      projects: [
        for (final (project, text) in _projects)
          if (re.hasMatch(text)) project,
      ],
      listedSkills: [
        for (final skill in _skills)
          if (re.hasMatch(skill)) skill,
      ],
    );
  }

  static String _experienceText(Experience e) => [
    e.role,
    e.company,
    e.description,
    ...?e.technologies?.map((t) => t.name),
  ].whereType<String>().join('\n');

  static String _projectText(Project p) => [
    p.name,
    p.description,
    p.role,
    ...?p.highlights,
    ...?p.technologies?.map((t) => t.name),
  ].whereType<String>().join('\n');

  // "5+ years", "at least 3 years", "minimum of 4 yrs", "3-5 years" (the
  // lower bound is what's being asked for).
  static final _yearsPattern = RegExp(
    r'(\d{1,2})\s*(?:\+|-\s*\d{1,2}|–\s*\d{1,2}|or more)?\s*(?:years?|yrs?)\b',
    caseSensitive: false,
  );

  /// Each years ask in [text], with the text after it (up to the next ask)
  /// and the text before it (back to the previous one) as the places to
  /// look for the skill it's about — so "5+ years of mobile, 3+ years with
  /// Flutter" keeps the two asks apart.
  static List<(int, List<String>)> _yearsAsks(String text) {
    final matches = _yearsPattern.allMatches(text).toList();
    return [
      for (final (i, match) in matches.indexed)
        if (int.parse(match.group(1)!) case final years
            // "a 20-year-old company" or a stray date isn't a requirement.
            when years >= 1 && years <= 20)
          (
            years,
            [
              text.substring(
                match.start,
                i + 1 < matches.length ? matches[i + 1].start : text.length,
              ),
              text.substring(i > 0 ? matches[i - 1].end : 0, match.start),
            ],
          ),
    ];
  }

  // Section headers that switch priority for the lines that follow them.
  static final _niceHeader = RegExp(
    r'^\W*(?:nice[- ]to[- ]haves?|bonus(?: points)?|preferred(?: qualifications| skills)?|good[- ]to[- ]have|pluses|extra credit|desirable)\b',
    caseSensitive: false,
  );
  static final _requiredHeader = RegExp(
    r'^\W*(?:requirements|required|must[- ]haves?|qualifications|minimum qualifications|what you(?:.ll)? (?:bring|need|have)|you have|about you|who you are|responsibilities|what you.ll do|the role)\b',
    caseSensitive: false,
  );
  // Sections whose words aren't asks — "health insurance" under Benefits
  // is not a healthcare-domain requirement.
  static final _ignoredHeader = RegExp(
    r'^\W*(?:benefits|perks|what we offer|we offer|compensation|salary|equal opportunity|eeo|how to apply)\b',
    caseSensitive: false,
  );
  // Inline markers that make just that sentence nice-to-have.
  static final _niceInline = RegExp(
    r'nice[- ]to[- ]have|\bbonus\b|\ba plus\b|\bis a plus\b|\bpreferred\b|good[- ]to[- ]have|\bideally\b|familiarity with',
    caseSensitive: false,
  );

  static Iterable<_Clause> _clauses(String text) sync* {
    var section = RequirementPriority.required;
    var ignoring = false;
    for (final rawLine in text.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      final isShort = line.length <= 60;
      if (isShort && _ignoredHeader.hasMatch(line)) {
        ignoring = true;
        continue;
      }
      if (_niceHeader.hasMatch(line)) {
        section = RequirementPriority.niceToHave;
        ignoring = false;
      } else if (isShort && _requiredHeader.hasMatch(line)) {
        section = RequirementPriority.required;
        ignoring = false;
      }
      if (ignoring) continue;
      // Sentences, so an inline "…is a plus" only demotes its own sentence.
      for (final sentence in line.split(RegExp(r'(?<=[.;!?])\s+'))) {
        final priority = _niceInline.hasMatch(sentence)
            ? RequirementPriority.niceToHave
            : section;
        yield _Clause(sentence, priority);
      }
    }
  }
}

class _Clause {
  const _Clause(this.text, this.priority);

  final String text;
  final RequirementPriority priority;
}

class _Ask {
  const _Ask(this.priority, this.years);

  final RequirementPriority priority;
  final int? years;
}
