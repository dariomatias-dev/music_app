import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/history/data/seeds/play_history_seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LibrarySeed(database, clock: clock).run();
    await PlayHistorySeed(database, clock: clock).run();
  });

  test('plays something on the day it runs', () async {
    final events = await database.playEventDao.getAll();
    final days = events
        .map(
          (event) => DateTime(
            event.startedAt.year,
            event.startedAt.month,
            event.startedAt.day,
          ),
        )
        .toSet();
    final today = DateTime(clock().year, clock().month, clock().day);

    expect(days, contains(today));
  });

  test('spreads plays over days and hours', () async {
    final events = await database.playEventDao.getAll();

    expect(
      events.map((event) => event.startedAt.day).toSet().length,
      greaterThan(5),
    );
    expect(
      events.map((event) => event.startedAt.hour).toSet().length,
      greaterThan(5),
    );
  });

  test('plays some tracks more than once, and abandons others', () async {
    final events = await database.playEventDao.getAll();
    final playsPerTrack = <String, int>{};
    for (final event in events) {
      playsPerTrack[event.trackId] = (playsPerTrack[event.trackId] ?? 0) + 1;
    }

    expect(playsPerTrack.values.where((count) => count > 1), isNotEmpty);
    expect(events.where((event) => !event.completed), isNotEmpty);
  });

  test('running twice does not double the history', () async {
    final before = (await database.playEventDao.getAll()).length;

    await PlayHistorySeed(database, clock: clock).run();

    expect((await database.playEventDao.getAll()).length, before);
  });
}
