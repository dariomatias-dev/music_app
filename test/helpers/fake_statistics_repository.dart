import 'package:music_app/src/features/statistics/domain/entities/daily_play_count.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';
import 'package:music_app/src/features/statistics/domain/repositories/statistics_repository.dart';

/// In-memory [StatisticsRepository] for tests.
class FakeStatisticsRepository implements StatisticsRepository {
  FakeStatisticsRepository({
    List<TrackPlayCount> trackPlayCounts = const [],
    Duration totalListenedDuration = Duration.zero,
    List<int>? hourlyDistribution,
    List<DailyPlayCount> dailyPlayCounts = const [],
    ListeningStreak listeningStreak = const ListeningStreak(
      currentDays: 0,
      longestDays: 0,
    ),
  }) : _trackPlayCounts = trackPlayCounts,
       _totalListenedDuration = totalListenedDuration,
       _hourlyDistribution = hourlyDistribution ?? List.filled(24, 0),
       _dailyPlayCounts = dailyPlayCounts,
       _listeningStreak = listeningStreak;

  final List<TrackPlayCount> _trackPlayCounts;
  final Duration _totalListenedDuration;
  final List<int> _hourlyDistribution;
  final List<DailyPlayCount> _dailyPlayCounts;
  final ListeningStreak _listeningStreak;

  @override
  Stream<List<TrackPlayCount>> watchTrackPlayCounts() =>
      Stream.value(_trackPlayCounts);

  @override
  Stream<Duration> watchTotalListenedDuration() =>
      Stream.value(_totalListenedDuration);

  @override
  Stream<List<int>> watchHourlyDistribution() =>
      Stream.value(_hourlyDistribution);

  @override
  Stream<List<DailyPlayCount>> watchDailyPlayCounts() =>
      Stream.value(_dailyPlayCounts);

  @override
  Stream<ListeningStreak> watchListeningStreak() =>
      Stream.value(_listeningStreak);
}
