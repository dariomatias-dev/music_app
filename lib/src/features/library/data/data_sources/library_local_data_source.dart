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

  /// Inserts or updates [track].
  Future<void> upsertTrack(Track track);
}
