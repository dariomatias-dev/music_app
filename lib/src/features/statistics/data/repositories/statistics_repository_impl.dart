import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/statistics/domain/entities/daily_play_count.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';
import 'package:music_app/src/features/statistics/domain/repositories/statistics_repository.dart';

/// [StatisticsRepository] implementation backed by [AppDatabase].
class StatisticsRepositoryImpl implements StatisticsRepository {
  /// Creates a [StatisticsRepositoryImpl].
  StatisticsRepositoryImpl(this._database);

  final AppDatabase _database;

  /// Source of the current time, overridable so tests can control what
  /// counts as "today" for streak calculations.
  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  Stream<List<PlayEventRow>> get _events => _database.playEventDao.watchAll();

  @override
  Stream<List<TrackPlayCount>> watchTrackPlayCounts() {
    return _events.map((events) {
      final counts = <String, int>{};
      for (final event in events) {
        counts[event.trackId] = (counts[event.trackId] ?? 0) + 1;
      }
      return counts.entries
          .map(
            (entry) =>
                TrackPlayCount(trackId: entry.key, playCount: entry.value),
          )
          .toList()
        ..sort((a, b) => b.playCount.compareTo(a.playCount));
    });
  }

  @override
  Stream<Duration> watchTotalListenedDuration() {
    return _events.map((events) {
      var totalMilliseconds = 0;
      for (final event in events) {
        totalMilliseconds += event.playedDuration;
      }
      return Duration(milliseconds: totalMilliseconds);
    });
  }

  @override
  Stream<List<int>> watchHourlyDistribution() {
    return _events.map((events) {
      final buckets = List.filled(24, 0);
      for (final event in events) {
        buckets[event.startedAt.hour]++;
      }
      return buckets;
    });
  }

  @override
  Stream<List<DailyPlayCount>> watchDailyPlayCounts() {
    return _events.map((events) {
      final counts = <DateTime, int>{};
      for (final event in events) {
        final date = _dateOnly(event.startedAt);
        counts[date] = (counts[date] ?? 0) + 1;
      }
      return counts.entries
          .map(
            (entry) => DailyPlayCount(date: entry.key, playCount: entry.value),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    });
  }

  @override
  Stream<ListeningStreak> watchListeningStreak() {
    return _events.map((events) {
      final dates = events.map((event) => _dateOnly(event.startedAt)).toSet();
      if (dates.isEmpty) {
        return const ListeningStreak(currentDays: 0, longestDays: 0);
      }

      final sortedDates = dates.toList()..sort();
      var longestDays = 0;
      var run = 0;
      DateTime? previous;
      for (final date in sortedDates) {
        run = (previous != null && date.difference(previous).inDays == 1)
            ? run + 1
            : 1;
        if (run > longestDays) longestDays = run;
        previous = date;
      }

      final today = _dateOnly(clock());
      var cursor = dates.contains(today)
          ? today
          : today.subtract(const Duration(days: 1));
      var currentDays = 0;
      while (dates.contains(cursor)) {
        currentDays++;
        cursor = cursor.subtract(const Duration(days: 1));
      }

      return ListeningStreak(
        currentDays: currentDays,
        longestDays: longestDays,
      );
    });
  }

  DateTime _dateOnly(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
