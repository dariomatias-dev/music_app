import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';

/// Access to the user's playlists and their track order.
abstract interface class PlaylistRepository {
  /// Watches every playlist.
  Stream<List<Playlist>> watchPlaylists();

  /// Watches the playlist with [playlistId], `null` if it doesn't exist
  /// (e.g. after being deleted).
  Stream<Playlist?> watchPlaylist(String playlistId);

  /// Watches the track ids of the playlist with [playlistId], in order.
  Stream<List<String>> watchPlaylistTrackIds(String playlistId);

  /// Creates a new, empty playlist named [name] and returns its id.
  Future<String> createPlaylist(String name);

  /// Renames the playlist with [playlistId].
  Future<void> renamePlaylist(String playlistId, String name);

  /// Sets the description of the playlist with [playlistId]. `null` clears
  /// it.
  Future<void> updatePlaylistDescription(
    String playlistId,
    String? description,
  );

  /// Sets whether the playlist with [playlistId] is favorited.
  Future<void> setPlaylistFavorite(
    String playlistId, {
    required bool isFavorite,
  });

  /// Deletes the playlist with [playlistId].
  Future<void> deletePlaylist(String playlistId);

  /// Replaces the playlist with [playlistId]'s tracks with [trackIds], in
  /// the given order. Used for adding, removing and reordering tracks
  /// alike: callers build the new full order and pass it here.
  Future<void> setPlaylistTracks(String playlistId, List<String> trackIds);
}
