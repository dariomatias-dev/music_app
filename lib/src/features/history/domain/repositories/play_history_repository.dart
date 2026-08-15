/// Access to the user's playback history.
abstract interface class PlayHistoryRepository {
  /// Watches up to [limit] distinct track ids, most recently played first.
  Stream<List<String>> watchRecentTrackIds({int limit});

  /// Records a play of [trackId] that started at [startedAt] and ran for
  /// [playedDuration], having reached the end or not per [completed].
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
  });
}
