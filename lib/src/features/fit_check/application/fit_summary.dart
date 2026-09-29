import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/fit_check/domain/fit_report.dart';

/// Plain text a recruiter can paste into an ATS note, Slack or an email to
/// the hiring manager — every line checkable against the site it links to.
String buildFitSummary(
  FitReport report, {
  required String name,
  required String headline,
  required String siteUrl,
  String? email,
  String presentLabel = 'Present',
  int maxRequirements = 30,
}) {
  final lines = <String>[
    'Fit check: $name, $headline',
    'Checked against the job description on $siteUrl',
    '',
  ];

  if (report.requiredCount > 0) {
    lines.add(
      'Evidence for ${report.requiredEvidenced} of ${report.requiredCount} '
      'required skills'
      '${report.niceCount > 0 ? ', ${report.niceEvidenced} of ${report.niceCount} nice-to-haves' : ''}.',
    );
  }
  final years = report.yearsCheck;
  if (years != null) {
    lines.add(
      'Asked for ${years.asked}+ years of experience: has ${years.have} years in mobile.',
    );
  }
  lines.add('');

  for (final requirement in report.requirements.take(maxRequirements)) {
    lines.add(_requirementLine(requirement, presentLabel));
  }
  final hidden = report.requirements.length - maxRequirements;
  if (hidden > 0) lines.add('…and $hidden more on the site.');

  if (report.alsoBrings.isNotEmpty) {
    lines
      ..add('')
      ..add(
        'Also brings: ${report.alsoBrings.map((m) => m.signal.label).join(', ')}.',
      );
  }

  lines
    ..add('')
    ..add('Portfolio: $siteUrl');
  if (email != null) lines.add('Contact: $email');
  return lines.join('\n');
}

String _requirementLine(RequirementMatch match, String presentLabel) {
  final label = match.priority == RequirementPriority.niceToHave
      ? '${match.signal.label} (nice to have)'
      : match.signal.label;
  final asked = match.yearsAsked == null
      ? ''
      : ' [asked ${match.yearsAsked}+ yrs]';
  switch (match.level) {
    case EvidenceLevel.none:
      return '✗ $label$asked: not shown on the portfolio';
    case EvidenceLevel.listed:
      return '~ $label$asked: listed skill';
    case EvidenceLevel.proven:
      final evidence = <String>[
        ...match.experiences.map(
          (e) => '${shortCompany(e)} (${dateRange(e, presentLabel)})',
        ),
        ...match.projects.take(3).map((p) => p.name ?? ''),
        if (match.projects.length > 3) '+${match.projects.length - 3} more',
      ];
      return '✓ $label$asked: ${evidence.join(', ')}';
  }
}

/// "Developer eXperience Hub (Devxhub)" → "Devxhub": the name people use
/// is usually the parenthesised one.
String shortCompany(Experience experience) {
  final company = experience.company ?? '';
  final short = RegExp(r'\(([^)]+)\)').firstMatch(company)?.group(1);
  return short ?? company;
}

String dateRange(Experience experience, String presentLabel) {
  final start = experience.startYear?.toString() ?? '';
  final end = experience.isPresent == true
      ? presentLabel
      : experience.endYear?.toString() ?? '';
  return '$start–$end';
}
