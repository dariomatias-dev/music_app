import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';

/// Writes a short search history, so the search screen opens on recent
/// terms instead of its empty state.
///
/// The terms match the seeded catalogue, including an accented one and one
/// that matches nothing, which is what the no-results state needs.
class SearchHistorySeed implements Seed {
  /// Creates a [SearchHistorySeed] writing into the given database, dating
  /// the searches relative to [clock].
  SearchHistorySeed(this._database, {required DateTime Function() clock})
    : _clock = clock;

  final AppDatabase _database;
  final DateTime Function() _clock;

  /// Most recently searched last: the list orders by [DateTime], and this
  /// is written oldest first.
  static const _terms = [
    'zzz',
    'nocturne',
    'maré',
    'charcoal',
    'night',
  ];

  @override
  Future<void> run() async {
    final now = _clock();

    for (final (index, term) in _terms.indexed) {
      await _database.searchHistoryDao.upsertOne(
        SearchHistoryTableCompanion.insert(
          id: 'seed-search-$index',
          term: term,
          searchedAt: now.subtract(Duration(hours: _terms.length - index)),
        ),
      );
    }
  }
}
