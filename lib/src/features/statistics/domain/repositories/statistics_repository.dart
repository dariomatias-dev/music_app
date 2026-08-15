import 'package:music_app/src/features/statistics/domain/entities/daily_play_count.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';

/// Calculations derived from the user's playback history.
abstract interface class StatisticsRepository {
  /// Every played track's play count, most played first.
  Stream<List<TrackPlayCount>> watchTrackPlayCounts();

  /// The total time actually played across every recorded play.
  Stream<Duration> watchTotalListenedDuration();

  /// Play counts by hour of day (index 0-23, local time), summed across
  /// every recorded play.
  Stream<List<int>> watchHourlyDistribution();

  /// Play counts by calendar day that had at least one play, oldest first.
  Stream<List<DailyPlayCount>> watchDailyPlayCounts();

  /// The user's current and longest streaks of consecutive days with at
  /// least one play.
  Stream<ListeningStreak> watchListeningStreak();
}
