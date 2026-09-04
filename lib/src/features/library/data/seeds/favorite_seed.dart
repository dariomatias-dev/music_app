import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

/// Favorites a handful of the seeded tracks, spread across artists so the
/// favorites tab is neither empty nor a single album's worth.
///
/// Runs after [LibrarySeed]: a favorite points at a track, and the schema
/// enforces it.
class FavoriteSeed implements Seed {
  /// Creates a [FavoriteSeed] writing into the given database, dating the
  /// favorites relative to [clock].
  FavoriteSeed(this._database, {required DateTime Function() clock})
    : _clock = clock;

  final AppDatabase _database;
  final DateTime Function() _clock;

  /// Positions in [seedTrackIds] of the tracks that start out favorited.
  static const _favoritedPositions = [0, 5, 9, 14, 21, 27];

  @override
  Future<void> run() async {
    final now = _clock();
    final trackIds = seedTrackIds;

    for (final (index, position) in _favoritedPositions.indexed) {
      if (position >= trackIds.length) continue;
      final trackId = trackIds[position];
      await _database.favoriteDao.upsertOne(
        FavoriteTableCompanion.insert(
          id: 'seed-favorite-$trackId',
          trackId: trackId,
          createdAt: now.subtract(Duration(days: index * 2)),
        ),
      );
    }
  }
}
