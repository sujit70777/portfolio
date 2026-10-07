import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/conversion/domain/note_markup.dart';

void main() {
  test('splits paragraphs, bullet lists and numbered lists', () {
    final blocks = parseNoteBody(
      'Opening line\nwraps here.\n\n'
      '- one\n- two\n\n'
      '1. first\n2. second\n\n'
      'Closing.',
    );

    expect(blocks.map((b) => b.kind), [
      NoteBlockKind.paragraph,
      NoteBlockKind.bullets,
      NoteBlockKind.numbered,
      NoteBlockKind.paragraph,
    ]);
    expect(blocks.first.items.single, [const NoteSpan('Opening line wraps here.')]);
    expect(blocks[1].items, [
      [const NoteSpan('one')],
      [const NoteSpan('two')],
    ]);
    expect(blocks[2].items.last, [const NoteSpan('second')]);
  });

  test('parses **bold** and `code` inline', () {
    expect(
      parseNoteInline('**Lead.** Use `appAccountToken` here.'),
      [
        const NoteSpan('Lead.', bold: true),
        const NoteSpan(' Use '),
        const NoteSpan('appAccountToken', code: true),
        const NoteSpan(' here.'),
      ],
    );
  });

  test('a block mixing list and plain lines stays a paragraph', () {
    final blocks = parseNoteBody('Intro line\n- not really a list');
    expect(blocks.single.kind, NoteBlockKind.paragraph);
  });
}
