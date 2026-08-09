import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';

part 'track_dao.g.dart';

/// Data access for [TrackTable].
@DriftAccessor(tables: [TrackTable])
class TrackDao extends DatabaseAccessor<AppDatabase> with _$TrackDaoMixin {
  /// Creates a [TrackDao] bound to [attachedDatabase].
  TrackDao(super.attachedDatabase);

  /// Watches all tracks.
  Stream<List<TrackRow>> watchAll() => select(trackTable).watch();

  /// Reads a single track by [id].
  Future<TrackRow?> getById(String id) =>
      (select(trackTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<TrackRow> entry) =>
      into(trackTable).insertOnConflictUpdate(entry);

  /// Deletes the track with [id].
  Future<void> deleteById(String id) =>
      (delete(trackTable)..where((t) => t.id.equals(id))).go();
}
