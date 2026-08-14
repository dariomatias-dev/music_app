import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics.freezed.dart';

/// Where a track's lyrics were resolved from.
enum LyricsSource {
  /// Read from an embedded tag in the audio file (e.g. an ID3 `USLT`
  /// frame).
  embedded,

  /// Read from a sidecar `.lrc` file next to the audio file.
  file,

  /// Resolved, but no lyrics were found anywhere.
  none,
}

/// A track's lyrics, once resolved.
@freezed
abstract class Lyrics with _$Lyrics {
  /// Creates a [Lyrics].
  const factory Lyrics({
    required String trackId,
    required String? content,
    required LyricsSource source,
  }) = _Lyrics;
}
