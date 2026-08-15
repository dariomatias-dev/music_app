import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/search_history_table.dart';

part 'search_history_dao.g.dart';

/// Data access for [SearchHistoryTable].
@DriftAccessor(tables: [SearchHistoryTable])
class SearchHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$SearchHistoryDaoMixin {
  /// Creates a [SearchHistoryDao] bound to [attachedDatabase].
  SearchHistoryDao(super.attachedDatabase);

  /// Watches up to [limit] recent search terms, most recent first.
  ///
  /// Ties on [SearchHistoryTable.searchedAt] (same-millisecond searches)
  /// break on id, which is time-ordered (UUIDv7) and so preserves recency
  /// too.
  Stream<List<SearchHistoryRow>> watchRecent({int limit = 20}) {
    final query = select(searchHistoryTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.searchedAt),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    return query.watch();
  }

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<SearchHistoryRow> entry) =>
      into(searchHistoryTable).insertOnConflictUpdate(entry);

  /// Removes the entry for [term].
  Future<void> deleteByTerm(String term) =>
      (delete(searchHistoryTable)..where((t) => t.term.equals(term))).go();

  /// Deletes every search history entry.
  Future<void> clear() => delete(searchHistoryTable).go();
}
