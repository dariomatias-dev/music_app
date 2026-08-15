import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/favorite_table.dart';

part 'favorite_dao.g.dart';

/// Data access for [FavoriteTable].
@DriftAccessor(tables: [FavoriteTable])
class FavoriteDao extends DatabaseAccessor<AppDatabase>
    with _$FavoriteDaoMixin {
  /// Creates a [FavoriteDao] bound to [attachedDatabase].
  FavoriteDao(super.attachedDatabase);

  /// Watches all favorites, most recently favorited first.
  ///
  /// Ties on [FavoriteTable.createdAt] (same-millisecond favorites) break
  /// on id, which is time-ordered (UUIDv7) and so preserves recency too.
  Stream<List<FavoriteRow>> watchAll() =>
      (select(favoriteTable)..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.desc(t.id),
          ]))
          .watch();

  /// Reads the favorite entry for [trackId], if any.
  Future<FavoriteRow?> getByTrackId(String trackId) => (select(
    favoriteTable,
  )..where((t) => t.trackId.equals(trackId))).getSingleOrNull();

  /// Watches the favorite entry for [trackId], if any.
  Stream<FavoriteRow?> watchByTrackId(String trackId) => (select(
    favoriteTable,
  )..where((t) => t.trackId.equals(trackId))).watchSingleOrNull();

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<FavoriteRow> entry) =>
      into(favoriteTable).insertOnConflictUpdate(entry);

  /// Removes the favorite for [trackId].
  Future<void> deleteByTrackId(String trackId) =>
      (delete(favoriteTable)..where((t) => t.trackId.equals(trackId))).go();
}
