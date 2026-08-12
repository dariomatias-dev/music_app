import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';

/// [LibraryRepository] implementation backed by [LibraryLocalDataSource]
/// and [ReconcileLibrary].
class LibraryRepositoryImpl implements LibraryRepository {
  /// Creates a [LibraryRepositoryImpl].
  const LibraryRepositoryImpl({
    required LibraryLocalDataSource dataSource,
    required ReconcileLibrary reconcileLibrary,
  }) : _dataSource = dataSource,
       _reconcileLibrary = reconcileLibrary;

  final LibraryLocalDataSource _dataSource;
  final ReconcileLibrary _reconcileLibrary;

  @override
  Stream<List<Track>> watchTracks() => _dataSource.watchTracks();

  @override
  Stream<List<Album>> watchAlbums() => _dataSource.watchAlbums();

  @override
  Stream<List<Artist>> watchArtists() => _dataSource.watchArtists();

  @override
  Stream<IndexingProgress> reindex() => _reconcileLibrary();

  @override
  Future<void> purgeMissingTracks() => _reconcileLibrary.purgeMissingTracks();
}
