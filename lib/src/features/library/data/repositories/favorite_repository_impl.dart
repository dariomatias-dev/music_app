import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/library/domain/repositories/favorite_repository.dart';

/// [FavoriteRepository] implementation backed by [AppDatabase].
class FavoriteRepositoryImpl implements FavoriteRepository {
  /// Creates a [FavoriteRepositoryImpl].
  const FavoriteRepositoryImpl(this._database, this._idGenerator);

  final AppDatabase _database;
  final IdGenerator _idGenerator;

  @override
  Stream<bool> watchIsFavorite(String trackId) {
    return _database.favoriteDao
        .watchByTrackId(trackId)
        .map((row) => row != null);
  }

  @override
  Stream<List<String>> watchFavoriteTrackIds() {
    return _database.favoriteDao.watchAll().map(
      (rows) => rows.map((row) => row.trackId).toList(),
    );
  }

  @override
  Future<void> setFavorite(String trackId, {required bool isFavorite}) async {
    if (!isFavorite) {
      await _database.favoriteDao.deleteByTrackId(trackId);
      return;
    }

    final existing = await _database.favoriteDao.getByTrackId(trackId);
    if (existing != null) return;

    await _database.favoriteDao.upsertOne(
      FavoriteTableCompanion.insert(
        id: _idGenerator.generate(),
        trackId: trackId,
        createdAt: DateTime.now(),
      ),
    );
  }
}
