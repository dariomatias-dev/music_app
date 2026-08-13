/// Stage of loading/playing the current queue item.
enum AudioProcessingState {
  /// No source loaded.
  idle,

  /// A source is loading.
  loading,

  /// Playback is temporarily starved, waiting for more data.
  buffering,

  /// Ready to play.
  ready,

  /// The queue item finished playing.
  completed,
}

/// Repeat behavior of the queue.
enum AudioLoopMode {
  /// Stop after the last item.
  off,

  /// Repeat the current item.
  track,

  /// Repeat the whole queue.
  queue,
}

/// A snapshot of the audio engine's playback state at a point in time.
class AudioPlaybackSnapshot {
  /// Creates an [AudioPlaybackSnapshot].
  const AudioPlaybackSnapshot({
    required this.processingState,
    required this.playing,
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.speed,
    required this.currentIndex,
    required this.queueLength,
    required this.loopMode,
    required this.shuffleModeEnabled,
  });

  /// The initial, empty snapshot: no queue loaded.
  const AudioPlaybackSnapshot.initial()
    : processingState = AudioProcessingState.idle,
      playing = false,
      position = Duration.zero,
      duration = null,
      bufferedPosition = Duration.zero,
      speed = 1,
      currentIndex = null,
      queueLength = 0,
      loopMode = AudioLoopMode.off,
      shuffleModeEnabled = false;

  /// Current loading/playing stage.
  final AudioProcessingState processingState;

  /// Whether playback is active (as opposed to paused).
  ///
  /// Independent from [processingState]: a player can be playing while
  /// [AudioProcessingState.buffering].
  final bool playing;

  /// Current playback position within the item at [currentIndex].
  final Duration position;

  /// Duration of the item at [currentIndex], once known.
  final Duration? duration;

  /// How much of the current item has been buffered.
  final Duration bufferedPosition;

  /// Playback speed multiplier (1 is normal speed).
  final double speed;

  /// Index of the item currently loaded within the queue, or `null` when
  /// the queue is empty.
  final int? currentIndex;

  /// Number of items in the queue.
  final int queueLength;

  /// Current repeat behavior.
  final AudioLoopMode loopMode;

  /// Whether shuffle order is active.
  final bool shuffleModeEnabled;
}

/// Engine that plays a queue of local audio files.
///
/// Queue editing is exposed here, rather than only at a higher layer, so
/// implementations can apply edits without interrupting playback of the
/// current item (gapless).
abstract interface class AudioPlayerService {
  /// The most recent snapshot.
  AudioPlaybackSnapshot get snapshot;

  /// Emits a new snapshot whenever playback state changes.
  Stream<AudioPlaybackSnapshot> get snapshotStream;

  /// Replaces the queue with [filePaths] and loads the item at
  /// [initialIndex], seeking to [initialPosition] when given.
  ///
  /// Does not start playback; call [play] afterward.
  Future<void> setQueue(
    List<String> filePaths, {
    int initialIndex = 0,
    Duration? initialPosition,
  });

  /// Appends [filePath] to the end of the queue.
  Future<void> addToQueue(String filePath);

  /// Inserts [filePath] right after the current item, so it plays next.
  Future<void> insertNext(String filePath);

  /// Removes the queue item at [index].
  Future<void> removeFromQueue(int index);

  /// Moves the queue item at [from] to [to].
  Future<void> moveInQueue(int from, int to);

  /// Starts or resumes playback.
  Future<void> play();

  /// Pauses playback, keeping the current position.
  Future<void> pause();

  /// Stops playback and releases the loaded source.
  Future<void> stop();

  /// Seeks to [position] within the item at [index], or within the current
  /// item when [index] is omitted.
  Future<void> seek(Duration position, {int? index});

  /// Skips to the next item, respecting [AudioLoopMode] and shuffle order.
  Future<void> seekToNext();

  /// Skips to the previous item, respecting [AudioLoopMode] and shuffle
  /// order.
  Future<void> seekToPrevious();

  /// Sets the playback speed multiplier.
  Future<void> setSpeed(double speed);

  /// Sets the repeat behavior.
  Future<void> setLoopMode(AudioLoopMode mode);

  /// Enables or disables shuffle order.
  Future<void> setShuffleModeEnabled({required bool enabled});

  /// Releases underlying resources. The service cannot be used afterward.
  Future<void> dispose();
}
