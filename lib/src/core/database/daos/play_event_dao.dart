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

  /// Every play event, read once.
  ///
  /// Distinct from [watchAll] so a one-shot read does not register a query
  /// stream, run it, emit and immediately cancel just to get one value.
  Future<List<PlayEventRow>> getAll() => select(playEventTable).get();

  /// Every play event started at or after [from], newest first.
  ///
  /// Filtering in SQL rather than over [watchAll]'s result: the history
  /// grows without bound, and the statistics screen's shorter periods
  /// otherwise pay to ship years of rows across just to discard them.
  Stream<List<PlayEventRow>> watchSince(DateTime from) {
    return (select(
      playEventTable,
    )..where((t) => t.startedAt.isBiggerOrEqualValue(from))).watch();
  }

  /// Whether any play event exists at all.
  ///
  /// Answers the "is there history?" question the statistics screen gates
  /// on without reading the rows themselves.
  Stream<bool> watchHasAny() {
    final query = selectOnly(playEventTable)
      ..addColumns([playEventTable.id.count()]);
    return query
        .map((row) => (row.read(playEventTable.id.count()) ?? 0) > 0)
        .watchSingle();
  }

  /// Watches how many times each track was played, most played first,
  /// counting only events started at or after [from] when given.
  ///
  /// Counted by SQLite rather than over [watchAll]'s rows: the history has
  /// one row per play and this needs one per track, so aggregating here
  /// keeps the rest from crossing into Dart at all.
  Stream<List<({String trackId, int playCount})>> watchPlayCountsByTrack({
    DateTime? from,
  }) {
    final playCount = playEventTable.id.count();
    final query = selectOnly(playEventTable)
      ..addColumns([playEventTable.trackId, playCount])
      ..groupBy([playEventTable.trackId])
      ..orderBy([OrderingTerm.desc(playCount)]);
    if (from != null) {
      query.where(playEventTable.startedAt.isBiggerOrEqualValue(from));
    }

    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            trackId: row.read(playEventTable.trackId)!,
            playCount: row.read(playCount) ?? 0,
          ),
      ],
    );
  }

  /// Watches the total played time in milliseconds, counting only events
  /// started at or after [from] when given.
  ///
  /// Summed by SQLite for the same reason as [watchPlayCountsByTrack]:
  /// the answer is a single number.
  Stream<int> watchTotalPlayedMilliseconds({DateTime? from}) {
    final total = playEventTable.playedDuration.sum();
    final query = selectOnly(playEventTable)..addColumns([total]);
    if (from != null) {
      query.where(playEventTable.startedAt.isBiggerOrEqualValue(from));
    }

    return query.map((row) => row.read(total) ?? 0).watchSingle();
  }

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
