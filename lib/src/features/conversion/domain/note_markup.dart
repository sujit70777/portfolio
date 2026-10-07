/// The light markdown a [Note] body is written in, parsed into blocks and
/// inline spans for NoteBody to draw. Deliberately small — it covers what
/// the notes use and nothing else:
///
/// - blank lines separate blocks;
/// - a block whose lines all start "- " is a bullet list, one whose lines
///   all start "1. ", "2. "… is a numbered list; anything else is a
///   paragraph (its line breaks fold into spaces);
/// - inside any text, **bold** and `code`.
enum NoteBlockKind { paragraph, bullets, numbered }

class NoteBlock {
  const NoteBlock(this.kind, this.items);

  final NoteBlockKind kind;

  /// One entry for a paragraph; one per item for a list.
  final List<List<NoteSpan>> items;
}

class NoteSpan {
  const NoteSpan(this.text, {this.bold = false, this.code = false});

  final String text;
  final bool bold;
  final bool code;

  @override
  bool operator ==(Object other) =>
      other is NoteSpan &&
      other.text == text &&
      other.bold == bold &&
      other.code == code;

  @override
  int get hashCode => Object.hash(text, bold, code);

  @override
  String toString() => 'NoteSpan($text${bold ? ', bold' : ''}'
      '${code ? ', code' : ''})';
}

final _bullet = RegExp(r'^- ');
final _numbered = RegExp(r'^\d+\. ');
final _inline = RegExp(r'\*\*(.+?)\*\*|`([^`]+)`');

List<NoteBlock> parseNoteBody(String body) {
  final blocks = <NoteBlock>[];
  for (final raw in body.split(RegExp(r'\n\s*\n'))) {
    final lines = raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) continue;
    if (lines.every(_bullet.hasMatch)) {
      blocks.add(NoteBlock(NoteBlockKind.bullets, [
        for (final l in lines) parseNoteInline(l.replaceFirst(_bullet, '')),
      ]));
    } else if (lines.every(_numbered.hasMatch)) {
      blocks.add(NoteBlock(NoteBlockKind.numbered, [
        for (final l in lines) parseNoteInline(l.replaceFirst(_numbered, '')),
      ]));
    } else {
      blocks.add(NoteBlock(NoteBlockKind.paragraph, [
        parseNoteInline(lines.join(' ')),
      ]));
    }
  }
  return blocks;
}

List<NoteSpan> parseNoteInline(String text) {
  final spans = <NoteSpan>[];
  var cursor = 0;
  for (final match in _inline.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(NoteSpan(text.substring(cursor, match.start)));
    }
    final bold = match.group(1);
    spans.add(
      bold != null ? NoteSpan(bold, bold: true) : NoteSpan(match.group(2)!, code: true),
    );
    cursor = match.end;
  }
  if (cursor < text.length) spans.add(NoteSpan(text.substring(cursor)));
  return spans;
}
