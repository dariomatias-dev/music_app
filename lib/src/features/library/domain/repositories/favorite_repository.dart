/// Access to the user's favorited tracks.
abstract interface class FavoriteRepository {
  /// Watches whether the track with [trackId] is favorited.
  Stream<bool> watchIsFavorite(String trackId);

  /// Marks the track with [trackId] as favorited or not.
  Future<void> setFavorite(String trackId, {required bool isFavorite});
}
