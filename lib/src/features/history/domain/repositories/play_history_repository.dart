/// A single recorded play, as returned by
/// [PlayHistoryRepository.getAllEntries].
typedef PlayHistoryEntry = ({
  String trackId,
  DateTime startedAt,
  Duration playedDuration,
  bool completed,
});

/// Access to the user's playback history.
abstract interface class PlayHistoryRepository {
  /// Watches up to [limit] distinct track ids, most recently played first.
  Stream<List<String>> watchRecentTrackIds({int limit});

  /// Reads every recorded play, in no particular order.
  Future<List<PlayHistoryEntry>> getAllEntries();

  /// Records a play of [trackId] that started at [startedAt] and ran for
  /// [playedDuration], having reached the end or not per [completed].
  ///
  /// [id] identifies the recorded play: passing the same one again rewrites
  /// it rather than recording a second play, which is what lets a play
  /// still in progress be written out early without being counted twice.
  /// Omitted, the play gets a fresh id.
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
    String? id,
  });

  /// Clears the entire play history, resetting recently-played and every
  /// statistic derived from it.
  Future<void> clearHistory();
}
