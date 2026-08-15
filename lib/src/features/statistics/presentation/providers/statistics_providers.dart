import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/statistics/data/providers/statistics_data_providers.dart';
import 'package:music_app/src/features/statistics/domain/entities/daily_play_count.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';

/// Every played track's play count, most played first.
final trackPlayCountsProvider = StreamProvider<List<TrackPlayCount>>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchTrackPlayCounts(),
);

/// The total time actually played across every recorded play.
final totalListenedDurationProvider = StreamProvider<Duration>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchTotalListenedDuration(),
);

/// Play counts by hour of day (index 0-23, local time).
final hourlyDistributionProvider = StreamProvider<List<int>>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchHourlyDistribution(),
);

/// Play counts by calendar day that had at least one play, oldest first.
final dailyPlayCountsProvider = StreamProvider<List<DailyPlayCount>>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchDailyPlayCounts(),
);

/// The user's current and longest streaks of consecutive days with at least
/// one play.
final listeningStreakProvider = StreamProvider<ListeningStreak>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchListeningStreak(),
);

/// The user's played, non-missing tracks, ranked by play count.
final mostPlayedTracksProvider = Provider<List<Track>>((ref) {
  final counts = ref.watch(trackPlayCountsProvider).value ?? const [];
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final tracksById = {for (final track in tracks) track.id: track};

  final result = <Track>[];
  for (final count in counts) {
    final track = tracksById[count.trackId];
    if (track != null && !track.isMissing) result.add(track);
  }
  return result;
});

/// The user's played artists, ranked by the combined play count of their
/// non-missing tracks.
final mostPlayedArtistsProvider = Provider<List<Artist>>((ref) {
  final counts = ref.watch(trackPlayCountsProvider).value ?? const [];
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final artists = ref.watch(artistsStreamProvider).value ?? const [];
  final tracksById = {for (final track in tracks) track.id: track};
  final artistsById = {for (final artist in artists) artist.id: artist};

  final artistPlayCounts = <String, int>{};
  for (final count in counts) {
    final track = tracksById[count.trackId];
    if (track == null || track.isMissing) continue;
    artistPlayCounts[track.artistId] =
        (artistPlayCounts[track.artistId] ?? 0) + count.playCount;
  }

  final rankedArtistIds = artistPlayCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return [
    for (final entry in rankedArtistIds) ?artistsById[entry.key],
  ];
});
