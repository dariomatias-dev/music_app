import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/lyrics_parser.dart';

void main() {
  group('parseLyricLines', () {
    test('parses timed lines and drops metadata tags', () {
      final lines = parseLyricLines('''
[ar:Charcoal]
[ti:Night Drive]
[00:01.00]Line one
[00:05.50]Line two
''');

      expect(lines.map((l) => l.text), ['Line one', 'Line two']);
      expect(lines[0].timestamp, const Duration(seconds: 1));
      expect(
        lines[1].timestamp,
        const Duration(seconds: 5, milliseconds: 500),
      );
    });

    test('sorts timed lines by timestamp regardless of input order', () {
      final lines = parseLyricLines('[00:10.00]Second\n[00:02.00]First');

      expect(lines.map((l) => l.text), ['First', 'Second']);
    });

    test('expands a line with multiple time tags into repeated lines', () {
      final lines = parseLyricLines(
        '[00:01.00][00:20.00]Chorus\n[00:10.00]Verse',
      );

      expect(lines.map((l) => l.text), ['Chorus', 'Verse', 'Chorus']);
      expect(lines.map((l) => l.timestamp), [
        const Duration(seconds: 1),
        const Duration(seconds: 10),
        const Duration(seconds: 20),
      ]);
    });

    test('falls back to untimed lines when nothing has a timestamp', () {
      final lines = parseLyricLines('Line one\n\nLine two\n');

      expect(lines.map((l) => l.text), ['Line one', 'Line two']);
      expect(lines.every((l) => l.timestamp == null), isTrue);
    });

    test('returns an empty list for blank input', () {
      expect(parseLyricLines('   \n  \n'), isEmpty);
    });
  });

  group('activeLyricLineIndex', () {
    test('returns -1 for untimed lines', () {
      final lines = [const LyricLine(text: 'Line one')];

      expect(activeLyricLineIndex(lines, Duration.zero), -1);
    });

    test('returns -1 before the first timestamp', () {
      final lines = parseLyricLines('[00:05.00]Line one');

      expect(
        activeLyricLineIndex(lines, const Duration(seconds: 1)),
        -1,
      );
    });

    test('returns the last line whose timestamp has passed', () {
      final lines = parseLyricLines(
        '[00:01.00]One\n[00:05.00]Two\n[00:10.00]Three',
      );

      expect(activeLyricLineIndex(lines, const Duration(seconds: 6)), 1);
      expect(activeLyricLineIndex(lines, const Duration(seconds: 10)), 2);
      expect(activeLyricLineIndex(lines, const Duration(minutes: 5)), 2);
    });
  });
}
