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

  /// Reads every track.
  Future<List<TrackRow>> getAll() => select(trackTable).get();

  /// Reads a single track by [id].
  Future<TrackRow?> getById(String id) =>
      (select(trackTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Reads every track's id, keyed by its `sourceId`.
  ///
  /// A scan needs nothing but the id to keep a known track's identity, so
  /// this reads the two columns for the whole table once instead of
  /// selecting whole rows one file at a time.
  Future<Map<String, String>> getIdsBySourceId() async {
    final query = selectOnly(trackTable)
      ..addColumns([trackTable.sourceId, trackTable.id]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(trackTable.sourceId)!: row.read(trackTable.id)!,
    };
  }

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<TrackRow> entry) =>
      into(trackTable).insertOnConflictUpdate(entry);

  /// Deletes the track with [id].
  Future<void> deleteById(String id) =>
      (delete(trackTable)..where((t) => t.id.equals(id))).go();
}
