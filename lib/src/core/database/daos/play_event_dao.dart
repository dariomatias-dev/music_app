import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/play_event_table.dart';

part 'play_event_dao.g.dart';

/// Data access for [PlayEventTable].
@DriftAccessor(tables: [PlayEventTable])
class PlayEventDao extends DatabaseAccessor<AppDatabase>
    with _$PlayEventDaoMixin {
  /// Creates a [PlayEventDao] bound to [attachedDatabase].
  PlayEventDao(super.attachedDatabase);

  /// Watches all play events.
  Stream<List<PlayEventRow>> watchAll() => select(playEventTable).watch();

  /// Watches up to [limit] distinct track ids, most recently played first.
  Stream<List<String>> watchRecentTrackIds({int limit = 20}) {
    final query = select(playEventTable)
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      // Fetches a generous window before deduping by track, since the same
      // track can appear many times in a row of raw events.
      ..limit(limit * 4);
    return query.watch().map((rows) {
      final seen = <String>{};
      final ids = <String>[];
      for (final row in rows) {
        if (ids.length == limit) break;
        if (seen.add(row.trackId)) ids.add(row.trackId);
      }
      return ids;
    });
  }

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<PlayEventRow> entry) =>
      into(playEventTable).insertOnConflictUpdate(entry);

  /// Deletes all play events.
  Future<void> clear() => delete(playEventTable).go();
}
