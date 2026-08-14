import 'package:music_app/src/features/player/data/providers/player_data_providers.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics_providers.g.dart';

/// Resolves and caches the lyrics for the track at [filePath].
@riverpod
Future<Lyrics> lyrics(Ref ref, String trackId, String filePath) {
  return ref.watch(lyricsRepositoryProvider).resolve(trackId, filePath);
}
