import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// [LibraryRepository] implementation backed by [LibraryLocalDataSource]
/// and [ReconcileLibrary].
class LibraryRepositoryImpl implements LibraryRepository {
  /// Creates a [LibraryRepositoryImpl].
  const LibraryRepositoryImpl({
    required LibraryLocalDataSource dataSource,
    required ReconcileLibrary reconcileLibrary,
    required ArtworkCache artworkCache,
    required ExcludedFolderRepository excludedFolderRepository,
  }) : _dataSource = dataSource,
       _reconcileLibrary = reconcileLibrary,
       _artworkCache = artworkCache,
       _excludedFolderRepository = excludedFolderRepository;

  final LibraryLocalDataSource _dataSource;
  final ReconcileLibrary _reconcileLibrary;
  final ArtworkCache _artworkCache;
  final ExcludedFolderRepository _excludedFolderRepository;

  @override
  Stream<List<Track>> watchTracks() => _dataSource.watchTracks();

  @override
  Stream<List<Album>> watchAlbums() => _dataSource.watchAlbums();

  @override
  Stream<List<Artist>> watchArtists() => _dataSource.watchArtists();

  @override
  Stream<IndexingProgress> reindex() async* {
    final excludedFolders = await _excludedFolderRepository
        .watchExcludedFolders()
        .first;
    yield* _reconcileLibrary(excludedFolders: excludedFolders);
  }

  @override
  Future<void> purgeMissingTracks() => _reconcileLibrary.purgeMissingTracks();

  @override
  Future<void> clearArtworkCache() async {
    await _artworkCache.clear();
    await _dataSource.clearAlbumArtworkPaths();
  }
}
