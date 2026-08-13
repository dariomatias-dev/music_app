/// A persisted snapshot of the playback queue, meant to be restored the
/// next time the app starts.
class PlaybackSession {
  /// Creates a [PlaybackSession].
  const PlaybackSession({
    required this.trackIds,
    required this.currentIndex,
    required this.position,
  });

  /// Ids of the tracks that were in the queue, in order.
  final List<String> trackIds;

  /// Index of the track that was playing within [trackIds].
  final int currentIndex;

  /// Playback position within the current track.
  final Duration position;
}
