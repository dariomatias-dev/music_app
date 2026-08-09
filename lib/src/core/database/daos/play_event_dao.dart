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

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<PlayEventRow> entry) =>
      into(playEventTable).insertOnConflictUpdate(entry);

  /// Deletes all play events.
  Future<void> clear() => delete(playEventTable).go();
}
