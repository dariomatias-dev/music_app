import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';

part 'artist_dao.g.dart';

/// Data access for [ArtistTable].
@DriftAccessor(tables: [ArtistTable])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  /// Creates an [ArtistDao] bound to [attachedDatabase].
  ArtistDao(super.attachedDatabase);

  /// Watches all artists.
  Stream<List<ArtistRow>> watchAll() => select(artistTable).watch();

  /// Reads a single artist by [id].
  Future<ArtistRow?> getById(String id) =>
      (select(artistTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Reads a single artist by its [sourceId].
  Future<ArtistRow?> getBySourceId(String sourceId) => (select(
    artistTable,
  )..where((t) => t.sourceId.equals(sourceId))).getSingleOrNull();

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<ArtistRow> entry) =>
      into(artistTable).insertOnConflictUpdate(entry);

  /// Deletes the artist with [id].
  Future<void> deleteById(String id) =>
      (delete(artistTable)..where((t) => t.id.equals(id))).go();
}
