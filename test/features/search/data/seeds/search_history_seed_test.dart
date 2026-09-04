import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/search/data/seeds/search_history_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await SearchHistorySeed(database, clock: clock).run();
  });

  test('writes recent terms, most recent first', () async {
    final terms = await database.searchHistoryDao.watchRecent().first;

    expect(terms, isNotEmpty);
    expect(terms.first.term, 'night');
    expect(terms.first.searchedAt.isBefore(clock()), isTrue);
  });

  test('includes a term that matches nothing in the library', () async {
    final terms = await database.searchHistoryDao.watchRecent().first;

    expect(terms.map((entry) => entry.term), contains('zzz'));
  });

  test('running twice does not repeat a term', () async {
    await SearchHistorySeed(database, clock: clock).run();

    final terms = await database.searchHistoryDao.watchRecent().first;

    expect(terms.map((entry) => entry.term).toSet().length, terms.length);
  });
}
