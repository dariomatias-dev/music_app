/// Access to the user's favorited tracks.
abstract interface class FavoriteRepository {
  /// Watches whether the track with [trackId] is favorited.
  Stream<bool> watchIsFavorite(String trackId);

  /// Watches the ids of every favorited track, most recently favorited
  /// first.
  Stream<List<String>> watchFavoriteTrackIds();

  /// Marks the track with [trackId] as favorited or not.
  Future<void> setFavorite(String trackId, {required bool isFavorite});
}
