import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/album_table.dart';

part 'album_dao.g.dart';

/// Data access for [AlbumTable].
@DriftAccessor(tables: [AlbumTable])
class AlbumDao extends DatabaseAccessor<AppDatabase> with _$AlbumDaoMixin {
  /// Creates an [AlbumDao] bound to [attachedDatabase].
  AlbumDao(super.attachedDatabase);

  /// Watches all albums.
  Stream<List<AlbumRow>> watchAll() => select(albumTable).watch();

  /// Reads a single album by [id].
  Future<AlbumRow?> getById(String id) =>
      (select(albumTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Reads a single album by its [sourceId].
  Future<AlbumRow?> getBySourceId(String sourceId) => (select(
    albumTable,
  )..where((t) => t.sourceId.equals(sourceId))).getSingleOrNull();

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<AlbumRow> entry) =>
      into(albumTable).insertOnConflictUpdate(entry);

  /// Deletes the album with [id].
  Future<void> deleteById(String id) =>
      (delete(albumTable)..where((t) => t.id.equals(id))).go();
}
