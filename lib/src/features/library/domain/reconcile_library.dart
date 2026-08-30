import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';

/// Reconciles the local library against a fresh device scan.
///
/// Tracks already known keep their identifiers and get their data updated;
/// new files are added; tracks no longer found on disk are marked missing
/// instead of being deleted, which preserves favorites, playlist entries
/// and listening history that reference them.
class ReconcileLibrary {
  /// Creates a [ReconcileLibrary].
  const ReconcileLibrary({
    required LibraryIndexer indexer,
    required LibraryLocalDataSource dataSource,
  }) : _indexer = indexer,
       _dataSource = dataSource;

  final LibraryIndexer _indexer;
  final LibraryLocalDataSource _dataSource;

  /// Runs the reconciliation, yielding progress as files are indexed.
  ///
  /// Once every file has been processed, tracks whose `sourceId` was not
  /// seen in this run are marked missing, and tracks that reappeared are
  /// marked present again. Files under any of [excludedFolders] are
  /// skipped, so their tracks end up marked missing too.
  Stream<IndexingProgress> call({
    List<String> excludedFolders = const [],
  }) async* {
    final seenSourceIds = <String>{};

    await for (final progress in _indexer.indexLibrary(
      excludedFolders: excludedFolders,
    )) {
      seenSourceIds.add(progress.trackSourceId);
      yield progress;
    }

    await _updateMissingTracks(seenSourceIds);
  }

  /// Permanently deletes every track currently marked missing.
  ///
  /// Meant to be called after the user confirms the cleanup; it does not
  /// happen automatically as part of [call].
  Future<void> purgeMissingTracks() async {
    final tracks = await _dataSource.findAllTracks();
    await _dataSource.runInTransaction(() async {
      for (final track in tracks) {
        if (track.isMissing) await _dataSource.deleteTrack(track.id);
      }
    });
  }

  Future<void> _updateMissingTracks(Set<String> seenSourceIds) async {
    final tracks = await _dataSource.findAllTracks();
    final changed = [
      for (final track in tracks)
        if (!seenSourceIds.contains(track.sourceId) != track.isMissing)
          track.copyWith(isMissing: !seenSourceIds.contains(track.sourceId)),
    ];
    if (changed.isEmpty) return;

    await _dataSource.runInTransaction(() async {
      for (final track in changed) {
        await _dataSource.upsertTrack(track);
      }
    });
  }
}
