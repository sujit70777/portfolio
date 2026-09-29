import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/fit_check/domain/skill_signal.dart';
import 'package:portfolio/src/features/project/domain/project.dart';

enum RequirementPriority { required, niceToHave }

/// How well the portfolio backs a requirement up.
enum EvidenceLevel {
  /// Named in a role or a project — something a reviewer can open and check.
  proven,

  /// Only named in the skills list, with no role or project behind it.
  listed,

  /// Not shown anywhere on the site.
  none,
}

class RequirementMatch {
  const RequirementMatch({
    required this.signal,
    required this.priority,
    required this.experiences,
    required this.projects,
    required this.listedSkills,
    this.yearsAsked,
  });

  final SkillSignal signal;
  final RequirementPriority priority;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<String> listedSkills;

  /// "3+ years with Flutter" in the brief. Shown next to the roles that
  /// used the skill, with their dates, rather than turned into a computed
  /// verdict — overlapping and part-time roles make a per-skill year count
  /// easy to overstate, and an inflated number costs more trust than it
  /// buys.
  final int? yearsAsked;

  EvidenceLevel get level {
    if (experiences.isNotEmpty || projects.isNotEmpty) {
      return EvidenceLevel.proven;
    }
    if (listedSkills.isNotEmpty) return EvidenceLevel.listed;
    return EvidenceLevel.none;
  }
}

/// A general "N+ years of mobile experience" ask, answered against the
/// headline years figure.
class YearsCheck {
  const YearsCheck({required this.asked, required this.have});

  final int asked;
  final int have;

  bool get met => have >= asked;
}

class FitReport {
  const FitReport({
    required this.requirements,
    required this.alsoBrings,
    this.yearsCheck,
  });

  final List<RequirementMatch> requirements;

  /// Differentiating strengths with real evidence that the brief didn't
  /// mention.
  final List<RequirementMatch> alsoBrings;

  final YearsCheck? yearsCheck;

  bool get isEmpty => requirements.isEmpty && yearsCheck == null;

  Iterable<RequirementMatch> _of(RequirementPriority priority) =>
      requirements.where((r) => r.priority == priority);

  int get requiredCount => _of(RequirementPriority.required).length;
  int get requiredEvidenced => _of(
    RequirementPriority.required,
  ).where((r) => r.level != EvidenceLevel.none).length;
  int get niceCount => _of(RequirementPriority.niceToHave).length;
  int get niceEvidenced => _of(
    RequirementPriority.niceToHave,
  ).where((r) => r.level != EvidenceLevel.none).length;
}
