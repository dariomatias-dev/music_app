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

  Stream<List<PlayEventRow>> _events({DateTime? from}) {
    return from == null
        ? _database.playEventDao.watchAll()
        : _database.playEventDao.watchSince(from);
  }

  @override
  Stream<bool> watchHasAnyPlay() => _database.playEventDao.watchHasAny();

  @override
  Stream<List<TrackPlayCount>> watchTrackPlayCounts({DateTime? from}) {
    return _database.playEventDao
        .watchPlayCountsByTrack(from: from)
        .map(
          (counts) => [
            for (final count in counts)
              TrackPlayCount(
                trackId: count.trackId,
                playCount: count.playCount,
              ),
          ],
        );
  }

  @override
  Stream<Duration> watchTotalListenedDuration({DateTime? from}) {
    return _database.playEventDao
        .watchTotalPlayedMilliseconds(from: from)
        .map((milliseconds) => Duration(milliseconds: milliseconds));
  }

  @override
  Stream<List<int>> watchHourlyDistribution({DateTime? from}) {
    return _events(from: from).map((events) {
      final buckets = List.filled(24, 0);
      for (final event in events) {
        buckets[event.startedAt.hour]++;
      }
      return buckets;
    });
  }

  @override
  Stream<List<DailyPlayCount>> watchDailyPlayCounts({DateTime? from}) {
    return _events(from: from).map((events) {
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
    return _events().map((events) {
      final dates = events.map((event) => _dateOnly(event.startedAt)).toSet();
      if (dates.isEmpty) {
        return const ListeningStreak(currentDays: 0, longestDays: 0);
      }

      final sortedDates = dates.toList()..sort();
      var longestDays = 0;
      var run = 0;
      DateTime? previous;
      for (final date in sortedDates) {
        run = (previous != null && date == _dayAfter(previous)) ? run + 1 : 1;
        if (run > longestDays) longestDays = run;
        previous = date;
      }

      final today = _dateOnly(clock());
      var cursor = dates.contains(today) ? today : _dayBefore(today);
      var currentDays = 0;
      while (dates.contains(cursor)) {
        currentDays++;
        cursor = _dayBefore(cursor);
      }

      return ListeningStreak(
        currentDays: currentDays,
        longestDays: longestDays,
      );
    });
  }

  DateTime _dateOnly(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  /// The calendar day after [date].
  ///
  /// By the calendar rather than by adding 24 hours: a daylight saving
  /// change makes a local day 23 or 25 hours long, and a fixed duration
  /// then reads two consecutive days as further apart than they are,
  /// cutting the streak the user actually has.
  DateTime _dayAfter(DateTime date) =>
      DateTime(date.year, date.month, date.day + 1);

  /// The calendar day before [date], for the same reason as [_dayAfter].
  DateTime _dayBefore(DateTime date) =>
      DateTime(date.year, date.month, date.day - 1);
}
