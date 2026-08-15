import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/playlist_table.dart';

part 'playlist_dao.g.dart';

/// Data access for [PlaylistTable].
@DriftAccessor(tables: [PlaylistTable])
class PlaylistDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistDaoMixin {
  /// Creates a [PlaylistDao] bound to [attachedDatabase].
  PlaylistDao(super.attachedDatabase);

  /// Watches all playlists.
  Stream<List<PlaylistRow>> watchAll() => select(playlistTable).watch();

  /// Reads a single playlist by [id].
  Future<PlaylistRow?> getById(String id) =>
      (select(playlistTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Watches a single playlist by [id].
  Stream<PlaylistRow?> watchById(String id) => (select(
    playlistTable,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Inserts [entry]. Callers are expected to generate a fresh id, since
  /// this never updates an existing row.
  Future<void> insertOne(Insertable<PlaylistRow> entry) =>
      into(playlistTable).insert(entry);

  /// Applies [companion] to the playlist with [id].
  Future<void> updateOne(String id, PlaylistTableCompanion companion) =>
      (update(playlistTable)..where((t) => t.id.equals(id))).write(companion);

  /// Deletes the playlist with [id].
  Future<void> deleteById(String id) =>
      (delete(playlistTable)..where((t) => t.id.equals(id))).go();
}
