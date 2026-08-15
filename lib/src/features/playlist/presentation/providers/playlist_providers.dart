import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_providers.g.dart';

/// Live-updating list of every playlist.
final playlistsProvider = StreamProvider<List<Playlist>>(
  (ref) => ref.watch(playlistRepositoryProvider).watchPlaylists(),
);

/// Live-updating track ids of the playlist with the given id, in order.
@riverpod
Stream<List<String>> playlistTrackIds(Ref ref, String playlistId) {
  return ref
      .watch(playlistRepositoryProvider)
      .watchPlaylistTrackIds(playlistId);
}

/// Live-updating playlist with the given id, `null` if it doesn't exist.
@riverpod
Stream<Playlist?> playlistById(Ref ref, String playlistId) {
  return ref.watch(playlistRepositoryProvider).watchPlaylist(playlistId);
}

/// The playlist with the given id's tracks, resolved and in order. Missing
/// tracks (deleted from the library since being added) are skipped.
@riverpod
List<Track> playlistTracks(Ref ref, String playlistId) {
  final ids = ref.watch(playlistTrackIdsProvider(playlistId)).value ?? const [];
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final tracksById = {for (final track in tracks) track.id: track};

  final result = <Track>[];
  for (final id in ids) {
    final track = tracksById[id];
    if (track != null && !track.isMissing) result.add(track);
  }
  return result;
}
