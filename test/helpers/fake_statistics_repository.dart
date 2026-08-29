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
    bool? hasAnyPlay,
  }) : _trackPlayCounts = trackPlayCounts,
       _hasAnyPlay = hasAnyPlay,
       _totalListenedDuration = totalListenedDuration,
       _hourlyDistribution = hourlyDistribution ?? List.filled(24, 0),
       _dailyPlayCounts = dailyPlayCounts,
       _listeningStreak = listeningStreak;

  final List<TrackPlayCount> _trackPlayCounts;
  final Duration _totalListenedDuration;
  final List<int> _hourlyDistribution;
  final List<DailyPlayCount> _dailyPlayCounts;
  final ListeningStreak _listeningStreak;
  final bool? _hasAnyPlay;

  @override
  Stream<List<TrackPlayCount>> watchTrackPlayCounts({DateTime? from}) =>
      Stream.value(_trackPlayCounts);

  @override
  Stream<Duration> watchTotalListenedDuration({DateTime? from}) =>
      Stream.value(_totalListenedDuration);

  @override
  Stream<List<int>> watchHourlyDistribution({DateTime? from}) =>
      Stream.value(_hourlyDistribution);

  @override
  Stream<List<DailyPlayCount>> watchDailyPlayCounts({DateTime? from}) =>
      Stream.value(_dailyPlayCounts);

  @override
  Stream<ListeningStreak> watchListeningStreak() =>
      Stream.value(_listeningStreak);

  /// Defaults to whether the seeded track play counts are non-empty, which
  /// is how the statistics screen used to derive "has history" before the
  /// repository answered it directly. Pass `hasAnyPlay` to drive the two
  /// apart.
  @override
  Stream<bool> watchHasAnyPlay() =>
      Stream.value(_hasAnyPlay ?? _trackPlayCounts.isNotEmpty);
}
