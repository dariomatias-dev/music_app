import 'package:music_app/src/features/statistics/domain/entities/daily_play_count.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';

/// Calculations derived from the user's playback history.
abstract interface class StatisticsRepository {
  /// Every played track's play count since [from] (all time when omitted),
  /// most played first.
  Stream<List<TrackPlayCount>> watchTrackPlayCounts({DateTime? from});

  /// The total time actually played since [from] (all time when omitted).
  Stream<Duration> watchTotalListenedDuration({DateTime? from});

  /// Play counts by hour of day (index 0-23, local time), summed across
  /// every play since [from] (all time when omitted).
  Stream<List<int>> watchHourlyDistribution({DateTime? from});

  /// Play counts by calendar day that had at least one play since [from]
  /// (all time when omitted), oldest first.
  Stream<List<DailyPlayCount>> watchDailyPlayCounts({DateTime? from});

  /// The user's current and longest streaks of consecutive days with at
  /// least one play, across all time.
  Stream<ListeningStreak> watchListeningStreak();
}
