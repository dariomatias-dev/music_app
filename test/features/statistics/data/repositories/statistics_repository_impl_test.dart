import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/statistics/data/repositories/statistics_repository_impl.dart';

void main() {
  late AppDatabase database;
  late StatisticsRepositoryImpl repository;

  Future<void> seedPlay({
    required String id,
    required String trackId,
    required DateTime startedAt,
    int playedDurationMs = 60000,
  }) {
    return database
        .into(database.playEventTable)
        .insert(
          PlayEventTableCompanion.insert(
            id: id,
            trackId: trackId,
            startedAt: startedAt,
            playedDuration: playedDurationMs,
            completed: true,
          ),
        );
  }

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = StatisticsRepositoryImpl(database);
  });

  tearDown(() => database.close());

  group('watchTrackPlayCounts', () {
    test('counts and ranks tracks by number of plays', () async {
      await seedPlay(id: '1', trackId: 'a', startedAt: DateTime(2026));
      await seedPlay(id: '2', trackId: 'a', startedAt: DateTime(2026, 1, 2));
      await seedPlay(id: '3', trackId: 'b', startedAt: DateTime(2026, 1, 3));

      final counts = await repository.watchTrackPlayCounts().first;

      expect(counts.map((c) => c.trackId), ['a', 'b']);
      expect(counts.map((c) => c.playCount), [2, 1]);
    });
  });

  group('watchTotalListenedDuration', () {
    test('sums played duration across every play', () async {
      await seedPlay(
        id: '1',
        trackId: 'a',
        startedAt: DateTime(2026),
        playedDurationMs: 30000,
      );
      await seedPlay(
        id: '2',
        trackId: 'b',
        startedAt: DateTime(2026),
        playedDurationMs: 45000,
      );

      final total = await repository.watchTotalListenedDuration().first;

      expect(total, const Duration(seconds: 75));
    });

    test('is zero when nothing was played', () async {
      expect(
        await repository.watchTotalListenedDuration().first,
        Duration.zero,
      );
    });
  });

  group('watchHourlyDistribution', () {
    test('buckets plays by hour of day', () async {
      await seedPlay(
        id: '1',
        trackId: 'a',
        startedAt: DateTime(2026, 1, 1, 9),
      );
      await seedPlay(
        id: '2',
        trackId: 'b',
        startedAt: DateTime(2026, 1, 2, 9),
      );
      await seedPlay(
        id: '3',
        trackId: 'c',
        startedAt: DateTime(2026, 1, 1, 21),
      );

      final buckets = await repository.watchHourlyDistribution().first;

      expect(buckets, hasLength(24));
      expect(buckets[9], 2);
      expect(buckets[21], 1);
      expect(buckets[0], 0);
    });
  });

  group('watchDailyPlayCounts', () {
    test('counts plays per calendar day, oldest first', () async {
      await seedPlay(
        id: '1',
        trackId: 'a',
        startedAt: DateTime(2026, 1, 3, 8),
      );
      await seedPlay(
        id: '2',
        trackId: 'b',
        startedAt: DateTime(2026, 1, 1, 22),
      );
      await seedPlay(
        id: '3',
        trackId: 'c',
        startedAt: DateTime(2026, 1, 1, 23),
      );

      final daily = await repository.watchDailyPlayCounts().first;

      expect(daily.map((d) => d.date), [DateTime(2026), DateTime(2026, 1, 3)]);
      expect(daily.map((d) => d.playCount), [2, 1]);
    });
  });

  group('watchListeningStreak', () {
    test('is zero for both streaks when nothing was played', () async {
      final streak = await repository.watchListeningStreak().first;

      expect(streak.currentDays, 0);
      expect(streak.longestDays, 0);
    });

    test('current streak counts consecutive days ending today', () async {
      repository.clock = () => DateTime(2026, 1, 5);
      await seedPlay(id: '1', trackId: 'a', startedAt: DateTime(2026, 1, 3));
      await seedPlay(id: '2', trackId: 'a', startedAt: DateTime(2026, 1, 4));
      await seedPlay(id: '3', trackId: 'a', startedAt: DateTime(2026, 1, 5));

      final streak = await repository.watchListeningStreak().first;

      expect(streak.currentDays, 3);
    });

    test(
      'current streak stays alive through today if it ended yesterday',
      () async {
        repository.clock = () => DateTime(2026, 1, 5);
        await seedPlay(id: '1', trackId: 'a', startedAt: DateTime(2026, 1, 3));
        await seedPlay(id: '2', trackId: 'a', startedAt: DateTime(2026, 1, 4));

        final streak = await repository.watchListeningStreak().first;

        expect(streak.currentDays, 2);
      },
    );

    test('current streak is zero once a day is missed', () async {
      repository.clock = () => DateTime(2026, 1, 5);
      await seedPlay(id: '1', trackId: 'a', startedAt: DateTime(2026, 1, 2));

      final streak = await repository.watchListeningStreak().first;

      expect(streak.currentDays, 0);
    });

    test(
      'longest streak survives even after the current streak breaks',
      () async {
        repository.clock = () => DateTime(2026, 1, 10);
        await seedPlay(id: '1', trackId: 'a', startedAt: DateTime(2026));
        await seedPlay(id: '2', trackId: 'a', startedAt: DateTime(2026, 1, 2));
        await seedPlay(id: '3', trackId: 'a', startedAt: DateTime(2026, 1, 3));
        await seedPlay(id: '4', trackId: 'a', startedAt: DateTime(2026, 1, 4));
        await seedPlay(id: '5', trackId: 'a', startedAt: DateTime(2026, 1, 9));

        final streak = await repository.watchListeningStreak().first;

        expect(streak.longestDays, 4);
        expect(streak.currentDays, 1);
      },
    );
  });
}
