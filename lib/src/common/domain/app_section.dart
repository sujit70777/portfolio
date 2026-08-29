/// The page's sections in the order they actually appear, top to bottom.
/// The single source of truth for section-eyebrow numbering — see
/// SectionEyebrow — so a reordered section can't silently drift out of
/// sync with a number baked into a translated string somewhere else.
enum AppSection {
  about,
  skills,
  experience,
  projects,
}

extension AppSectionNumber on AppSection {
  int get number => index + 1;
}
