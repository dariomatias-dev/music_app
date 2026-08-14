import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/lyrics_reader/file_lyrics_reader.dart';
import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader.dart';

/// Provides the [LyricsReader] used across the app.
final lyricsReaderProvider = Provider<LyricsReader>(
  (ref) => const FileLyricsReader(),
);
