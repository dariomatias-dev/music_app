import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Local persistence for tracks, albums and artists.
abstract interface class LibraryLocalDataSource {
  /// Reads the artist previously indexed from [sourceId], if any.
  Future<Artist?> findArtistBySourceId(String sourceId);

  /// Inserts or updates [artist].
  Future<void> upsertArtist(Artist artist);

  /// Reads the album previously indexed from [sourceId], if any.
  Future<Album?> findAlbumBySourceId(String sourceId);

  /// Inserts or updates [album].
  Future<void> upsertAlbum(Album album);

  /// Reads the track previously indexed from [sourceId], if any.
  Future<Track?> findTrackBySourceId(String sourceId);

  /// Reads the track with [id], if any.
  Future<Track?> findTrackById(String id);

  /// Reads every indexed track.
  Future<List<Track>> findAllTracks();

  /// Inserts or updates [track].
  Future<void> upsertTrack(Track track);

  /// Permanently deletes the track with [id].
  Future<void> deleteTrack(String id);

  /// Watches every indexed track.
  Stream<List<Track>> watchTracks();

  /// Watches every indexed album.
  Stream<List<Album>> watchAlbums();

  /// Watches every indexed artist.
  Stream<List<Artist>> watchArtists();

  /// Clears every album's cached artwork path, so a future scan re-extracts
  /// it.
  Future<void> clearAlbumArtworkPaths();

  /// Runs [action] as a single unit of work.
  ///
  /// Every write outside one of these is its own transaction, and each
  /// commit costs a disk sync; a scan that writes per file pays that
  /// thousands of times over.
  Future<T> runInTransaction<T>(Future<T> Function() action);
}
