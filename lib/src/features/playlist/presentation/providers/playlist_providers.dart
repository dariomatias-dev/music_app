import 'package:flutter_riverpod/flutter_riverpod.dart';
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
