import 'package:music_app/src/features/player/domain/entities/lyrics.dart';

/// Resolves and caches a track's lyrics.
abstract interface class LyricsRepository {
  /// Watches the cached lyrics entry for [trackId], `null` until resolved.
  Stream<Lyrics?> watchLyrics(String trackId);

  /// Returns the cached lyrics for [trackId], resolving and persisting them
  /// from the file at [filePath] the first time this is called.
  ///
  /// Resolution tries, in order: an embedded tag, a sidecar `.lrc` file,
  /// then falls back to [LyricsSource.none].
  Future<Lyrics> resolve(String trackId, String filePath);
}
