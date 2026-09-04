import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

/// Writes three playlists: a long one, a short favorited one with a
/// description, and an empty one, so the playlists tab shows a full row, a
/// sparse row and the empty-playlist screen without any setup.
///
/// Runs after [LibrarySeed], whose tracks it points at.
class PlaylistSeed implements Seed {
  /// Creates a [PlaylistSeed] writing into the given database, dating the
  /// playlists relative to [clock].
  PlaylistSeed(this._database, {required DateTime Function() clock})
    : _clock = clock;

  final AppDatabase _database;
  final DateTime Function() _clock;

  @override
  Future<void> run() async {
    final now = _clock();
    final trackIds = seedTrackIds;

    await _write(
      id: 'seed-playlist-1',
      name: 'Evening Wind Down',
      description:
          'Slow tracks for the end of the day, in the order they were '
          'added rather than by title.',
      createdAt: now.subtract(const Duration(days: 40)),
      positions: [0, 1, 4, 7, 12, 16, 20, 26, 31],
      trackIds: trackIds,
    );
    await _write(
      id: 'seed-playlist-2',
      name: 'Focus',
      isFavorite: true,
      createdAt: now.subtract(const Duration(days: 12)),
      positions: [8, 13, 18],
      trackIds: trackIds,
    );
    await _write(
      id: 'seed-playlist-3',
      name: 'Nada ainda',
      createdAt: now.subtract(const Duration(days: 2)),
      positions: const [],
      trackIds: trackIds,
    );
  }

  /// Replaces the playlist with [id] and its entries.
  ///
  /// Deleted first rather than updated: the row's entries cascade with it,
  /// which is what keeps a rerun from stacking a second copy of the track
  /// list onto the same playlist.
  Future<void> _write({
    required String id,
    required String name,
    required DateTime createdAt,
    required List<int> positions,
    required List<String> trackIds,
    String? description,
    bool isFavorite = false,
  }) async {
    await _database.playlistDao.deleteById(id);
    await _database.playlistDao.insertOne(
      PlaylistTableCompanion.insert(
        id: id,
        name: name,
        createdAt: createdAt,
        updatedAt: createdAt,
        description: Value(description),
        isFavorite: Value(isFavorite),
      ),
    );

    await _database.playlistTrackDao.replaceForPlaylist(id, [
      for (final (index, position) in positions.indexed)
        if (position < trackIds.length)
          PlaylistTrackTableCompanion.insert(
            playlistId: id,
            trackId: trackIds[position],
            position: index,
          ),
    ]);
  }
}
