/// The About copy split into the parts the section lays out as cards. The
/// source stays one plain string in en.json (Fit Check reads the same
/// text), so the structure is inferred from its shape:
///
/// - the first paragraph is the [lead];
/// - paragraphs before the list are the [intro];
/// - a paragraph ending in ":" directly before the list is its [heading];
/// - each paragraph starting with "→ " is a [problems] entry, whose first
///   sentence is its title;
/// - paragraphs after the list shaped "Label: body" become [notes]; any
///   other paragraph there becomes a note with no label.
class AboutStory {
  const AboutStory({
    required this.lead,
    required this.intro,
    required this.heading,
    required this.problems,
    required this.notes,
  });

  factory AboutStory.parse(String text) {
    final paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (paragraphs.isEmpty) {
      return const AboutStory(
        lead: '',
        intro: [],
        heading: null,
        problems: [],
        notes: [],
      );
    }

    final intro = <String>[];
    final problems = <AboutProblem>[];
    final notes = <AboutNote>[];
    String? heading;

    for (final paragraph in paragraphs.skip(1)) {
      if (paragraph.startsWith(_arrow)) {
        problems.add(AboutProblem.parse(paragraph.substring(_arrow.length)));
      } else if (problems.isEmpty) {
        // A trailing ":" only counts as the list heading once it's clear
        // a list follows; until then it is ordinary intro copy.
        intro.add(paragraph);
      } else {
        notes.add(AboutNote.parse(paragraph));
      }
    }
    if (problems.isNotEmpty && intro.isNotEmpty && intro.last.endsWith(':')) {
      final last = intro.removeLast();
      heading = last.substring(0, last.length - 1).trim();
    }

    return AboutStory(
      lead: paragraphs.first,
      intro: intro,
      heading: heading,
      problems: problems,
      notes: notes,
    );
  }

  static const _arrow = '→ ';

  final String lead;
  final List<String> intro;
  final String? heading;
  final List<AboutProblem> problems;
  final List<AboutNote> notes;
}

class AboutProblem {
  const AboutProblem({required this.title, required this.body});

  /// "Prayer times that were wrong at high latitudes. A prayer-times app…"
  /// → title "Prayer times that were wrong at high latitudes", body the rest.
  factory AboutProblem.parse(String text) {
    final end = text.indexOf('. ');
    if (end < 0) return AboutProblem(title: text, body: '');
    return AboutProblem(
      title: text.substring(0, end).trim(),
      body: text.substring(end + 2).trim(),
    );
  }

  final String title;
  final String body;
}

class AboutNote {
  const AboutNote({required this.label, required this.body});

  /// "How I work: I own the problem…" → label "How I work". A colon only
  /// counts as a label break when what precedes it is short and has no
  /// sentence break, so a colon mid-sentence stays part of the body.
  factory AboutNote.parse(String text) {
    final match = _label.firstMatch(text);
    if (match == null) return AboutNote(label: null, body: text);
    // With the label lifted out, "make your app…" opens the card — so it
    // gets a capital like any other first sentence.
    final body = match.group(2)!.trim();
    return AboutNote(
      label: match.group(1)!.trim(),
      body: body[0].toUpperCase() + body.substring(1),
    );
  }

  static final _label = RegExp(r'^([^:.\n]{2,40}):\s+([\s\S]+)$');

  final String? label;
  final String body;
}
