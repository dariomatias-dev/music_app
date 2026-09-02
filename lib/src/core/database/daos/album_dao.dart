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

  /// Reads a single album by its [sourceId].
  Future<AlbumRow?> getBySourceId(String sourceId) => (select(
    albumTable,
  )..where((t) => t.sourceId.equals(sourceId))).getSingleOrNull();

  /// Every album, keyed by `sourceId`.
  ///
  /// Read once per scan for the same reason the artist DAO reads its own
  /// table whole: resolving albums file by file is a query per album in
  /// the library.
  Future<Map<String, AlbumRow>> getAllBySourceId() async {
    final rows = await select(albumTable).get();
    return {for (final row in rows) row.sourceId: row};
  }

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<AlbumRow> entry) =>
      into(albumTable).insertOnConflictUpdate(entry);

  /// Clears every album's cached artwork path, so a future scan re-extracts
  /// it.
  Future<void> clearArtworkPaths() => update(
    albumTable,
  ).write(const AlbumTableCompanion(artworkPath: Value(null)));
}
