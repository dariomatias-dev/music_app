/// A single line of lyrics, with its playback timestamp when the source is
/// time-synced (e.g. an LRC file).
class LyricLine {
  /// Creates a [LyricLine].
  const LyricLine({required this.text, this.timestamp});

  /// The line's text.
  final String text;

  /// When this line starts playing, or `null` for plain (untimed) lyrics.
  final Duration? timestamp;
}

final _timeTagPattern = RegExp(r'^\[(\d{1,2}):(\d{2})(?:\.(\d{1,3}))?\]');
final _metadataTagPattern = RegExp(r'^\[[a-zA-Z]+:.*\]$');

/// Parses raw lyrics text into lines, extracting LRC `[mm:ss.xx]` timestamp
/// tags when present.
///
/// A line can carry more than one tag (e.g. a repeated chorus); each tag
/// produces its own [LyricLine] with the same text, and the result is
/// sorted by timestamp. Metadata tags like `[ar:...]` are dropped. When no
/// line carries a timestamp, every non-empty line is returned untimed, in
/// its original order.
List<LyricLine> parseLyricLines(String raw) {
  final timed = <LyricLine>[];
  final plain = <LyricLine>[];

  for (final rawLine in raw.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty || _metadataTagPattern.hasMatch(line)) continue;

    var remaining = line;
    final timestamps = <Duration>[];
    var match = _timeTagPattern.firstMatch(remaining);
    while (match != null) {
      final minutes = int.parse(match.group(1)!);
      final seconds = int.parse(match.group(2)!);
      final fraction = match.group(3);
      final milliseconds = fraction == null
          ? 0
          : (double.parse('0.$fraction') * 1000).round();
      timestamps.add(
        Duration(
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
        ),
      );
      remaining = remaining.substring(match.end);
      match = _timeTagPattern.firstMatch(remaining);
    }

    final text = remaining.trim();
    if (text.isEmpty && timestamps.isEmpty) continue;

    if (timestamps.isEmpty) {
      plain.add(LyricLine(text: text));
    } else {
      for (final timestamp in timestamps) {
        timed.add(LyricLine(text: text, timestamp: timestamp));
      }
    }
  }

  if (timed.isEmpty) return plain;
  timed.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
  return timed;
}

/// Index of the line active at [position] among time-synced [lines].
///
/// Returns -1 when [lines] isn't time-synced, or when [position] is before
/// the first timestamp.
int activeLyricLineIndex(List<LyricLine> lines, Duration position) {
  if (lines.isEmpty || lines.first.timestamp == null) return -1;

  var active = -1;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].timestamp! > position) break;
    active = i;
  }
  return active;
}
