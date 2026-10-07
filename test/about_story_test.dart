import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/about/domain/about_story.dart';

void main() {
  const text = 'Lead line: the pitch.\n\n'
      'Intro paragraph.\n\n'
      'A few problems I\'ve solved:\n\n'
      '→ First problem. How it was solved.\n\n'
      '→ Second problem without a body\n\n'
      'How I work: own the problem.\n\n'
      'A closing line with no label.';

  test('splits lead, intro, heading, problems and notes', () {
    final story = AboutStory.parse(text);

    expect(story.lead, 'Lead line: the pitch.');
    expect(story.intro, ['Intro paragraph.']);
    expect(story.heading, 'A few problems I\'ve solved');
    expect(story.problems.map((p) => p.title), [
      'First problem',
      'Second problem without a body',
    ]);
    expect(story.problems.first.body, 'How it was solved.');
    expect(story.problems.last.body, isEmpty);
    expect(story.notes.first.label, 'How I work');
    expect(story.notes.first.body, 'Own the problem.');
    expect(story.notes.last.label, isNull);
    expect(story.notes.last.body, 'A closing line with no label.');
  });

  test('a trailing colon with no list after it stays intro copy', () {
    final story = AboutStory.parse('Lead.\n\nSee below:\n\nPlain ending.');

    expect(story.heading, isNull);
    expect(story.problems, isEmpty);
    expect(story.intro, ['See below:', 'Plain ending.']);
  });
}
