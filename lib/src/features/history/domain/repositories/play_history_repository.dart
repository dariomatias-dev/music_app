/// Access to the user's playback history.
abstract interface class PlayHistoryRepository {
  /// Watches up to [limit] distinct track ids, most recently played first.
  Stream<List<String>> watchRecentTrackIds({int limit});
}
