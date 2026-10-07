/// The page's sections in the order they actually appear, top to bottom.
/// The single source of truth for section-eyebrow numbering — see
/// SectionEyebrow — so a reordered section can't silently drift out of
/// sync with a number baked into a translated string somewhere else.
///
/// [video] is optional: when [videoVisible] is false it is skipped in the
/// numbering so the page never jumps 05 → 07.
enum AppSection {
  about,
  skills,
  experience,
  projects,
  openSource,
  video,
  notes,
  contract,
  fitCheck,
}

extension AppSectionNumber on AppSection {
  /// 1-based eyebrow number for the currently visible section set.
  int number({bool videoVisible = false}) {
    final order = <AppSection>[
      AppSection.about,
      AppSection.skills,
      AppSection.experience,
      AppSection.projects,
      AppSection.openSource,
      if (videoVisible) AppSection.video,
      AppSection.notes,
      AppSection.contract,
      AppSection.fitCheck,
    ];
    final i = order.indexOf(this);
    return (i < 0 ? index : i) + 1;
  }
}
