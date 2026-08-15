import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/search/domain/repositories/search_history_repository.dart';

/// [SearchHistoryRepository] implementation backed by [AppDatabase].
class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  /// Creates a [SearchHistoryRepositoryImpl].
  const SearchHistoryRepositoryImpl(this._database, this._idGenerator);

  final AppDatabase _database;
  final IdGenerator _idGenerator;

  @override
  Stream<List<String>> watchRecentTerms({int limit = 20}) {
    return _database.searchHistoryDao
        .watchRecent(limit: limit)
        .map((rows) => rows.map((row) => row.term).toList());
  }

  @override
  Future<void> record(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;

    // Re-inserts with a fresh id rather than updating the existing row in
    // place, so a re-search always sorts as the most recent even when it
    // ties on timestamp with another entry.
    await _database.searchHistoryDao.deleteByTerm(trimmed);
    await _database.searchHistoryDao.upsertOne(
      SearchHistoryTableCompanion.insert(
        id: _idGenerator.generate(),
        term: trimmed,
        searchedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> remove(String term) =>
      _database.searchHistoryDao.deleteByTerm(term);

  @override
  Future<void> clear() => _database.searchHistoryDao.clear();
}
