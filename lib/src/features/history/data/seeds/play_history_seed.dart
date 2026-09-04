import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

/// Writes a few weeks of listening: enough plays, spread over enough days
/// and hours, for recently played, the per-track counts, the hourly
/// distribution and both streaks to have something to show.
///
/// The most recent play lands on the day the seed runs, so the current
/// streak is alive rather than a number that only made sense the day the
/// data was written.
///
/// Runs after the library seed, whose tracks it plays.
class PlayHistorySeed implements Seed {
  /// Creates a [PlayHistorySeed] writing into the given database, dating
  /// the plays relative to [clock].
  PlayHistorySeed(this._database, {required DateTime Function() clock})
    : _clock = clock;

  final AppDatabase _database;
  final DateTime Function() _clock;

  /// Each play as (position in [seedTrackIds], days ago, hour of day,
  /// played to the end).
  ///
  /// Days 0 to 5 are consecutive, which is the current streak; the gap at
  /// day 6 ends it, and the longer run behind the gap is what the longest
  /// streak reports.
  static const _plays = <(int, int, int, bool)>[
    (0, 0, 8, true),
    (5, 0, 9, true),
    (13, 0, 22, false),
    (7, 1, 7, true),
    (21, 1, 18, true),
    (0, 2, 8, true),
    (16, 2, 13, true),
    (27, 2, 23, false),
    (9, 3, 10, true),
    (5, 3, 20, true),
    (31, 4, 15, true),
    (0, 4, 21, false),
    (14, 5, 11, true),
    (18, 5, 19, true),
    (2, 7, 9, true),
    (9, 7, 17, true),
    (24, 8, 12, true),
    (0, 8, 20, true),
    (5, 9, 8, false),
    (12, 9, 14, true),
    (30, 10, 16, true),
    (3, 10, 21, true),
    (9, 11, 9, true),
    (20, 11, 18, true),
    (0, 12, 7, true),
    (26, 13, 22, true),
    (5, 14, 19, true),
    (11, 16, 13, true),
    (33, 19, 10, false),
    (1, 23, 20, true),
  ];

  @override
  Future<void> run() async {
    final now = _clock();
    final trackIds = seedTrackIds;

    for (final (index, play) in _plays.indexed) {
      final (position, daysAgo, hour, completed) = play;
      if (position >= trackIds.length) continue;

      final day = now.subtract(Duration(days: daysAgo));
      await _database.playEventDao.upsertOne(
        PlayEventTableCompanion.insert(
          id: 'seed-play-$index',
          trackId: trackIds[position],
          startedAt: DateTime(day.year, day.month, day.day, hour, index % 60),
          playedDuration: completed
              ? const Duration(minutes: 4).inMilliseconds
              : const Duration(minutes: 1, seconds: 12).inMilliseconds,
          completed: completed,
        ),
      );
    }
  }
}
