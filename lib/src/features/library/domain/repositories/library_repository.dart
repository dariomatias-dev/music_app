import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Access to the indexed tracks, albums and artists.
abstract interface class LibraryRepository {
  /// Watches every indexed track.
  Stream<List<Track>> watchTracks();

  /// Watches every indexed album.
  Stream<List<Album>> watchAlbums();

  /// Watches every indexed artist.
  Stream<List<Artist>> watchArtists();

  /// Scans the device and reconciles the local library, yielding progress
  /// as files are processed.
  Stream<IndexingProgress> reindex();

  /// Permanently deletes every track currently marked missing.
  Future<void> purgeMissingTracks();

  /// Clears every cached album artwork file and its stored path, so the
  /// next scan re-extracts it.
  Future<void> clearArtworkCache();
}
