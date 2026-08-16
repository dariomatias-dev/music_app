import 'dart:async';

import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';

/// Bridges [AudioPlayerService] to the OS media notification and lock
/// screen via `audio_service`.
///
/// Forwards OS-originated commands (notification/lock-screen buttons,
/// headset controls) to [AudioPlayerService], and mirrors its state back as
/// [audio_service.PlaybackState] and [audio_service.MediaItem] so the OS can
/// display playback controls and the current track's metadata and artwork.
class MusicAudioHandler extends audio_service.BaseAudioHandler {
  /// Creates a [MusicAudioHandler] wrapping [_playerService].
  MusicAudioHandler(this._playerService) {
    _subscription = _playerService.snapshotStream.listen(_onSnapshot);
    _broadcastPlaybackState(_playerService.snapshot);
  }

  final AudioPlayerService _playerService;
  late final StreamSubscription<AudioPlaybackSnapshot> _subscription;
  AudioPlaybackSnapshot? _lastBroadcastSnapshot;
  DateTime? _lastBroadcastTime;

  /// Replaces the queue with [items] and loads the item at [initialIndex].
  Future<void> setQueue(
    List<QueueMediaItem> items, {
    int initialIndex = 0,
    Duration? initialPosition,
  }) async {
    queue.add(items.map((item) => item.toMediaItem()).toList());
    await _playerService.setQueue(
      items.map((item) => item.filePath).toList(),
      initialIndex: initialIndex,
      initialPosition: initialPosition,
    );
    _publishCurrentMediaItem();
  }

  /// Appends [item] to the end of the queue.
  Future<void> addToQueue(QueueMediaItem item) async {
    queue.add([...queue.value, item.toMediaItem()]);
    await _playerService.addToQueue(item.filePath);
  }

  /// Inserts [item] right after the current item, so it plays next.
  Future<void> insertNext(QueueMediaItem item) async {
    final index = (_playerService.snapshot.currentIndex ?? -1) + 1;
    queue.add([...queue.value]..insert(index, item.toMediaItem()));
    await _playerService.insertNext(item.filePath);
  }

  /// Removes the queue item at [index].
  Future<void> removeFromQueue(int index) async {
    queue.add([...queue.value]..removeAt(index));
    await _playerService.removeFromQueue(index);
  }

  /// Moves the queue item at [from] to [to].
  Future<void> moveInQueue(int from, int to) async {
    final updated = [...queue.value];
    final item = updated.removeAt(from);
    updated.insert(to, item);
    queue.add(updated);
    await _playerService.moveInQueue(from, to);
  }

  @override
  Future<void> play() => _playerService.play();

  @override
  Future<void> pause() => _playerService.pause();

  @override
  Future<void> stop() => _playerService.stop();

  @override
  Future<void> seek(Duration position) => _playerService.seek(position);

  @override
  Future<void> skipToNext() => _playerService.seekToNext();

  @override
  Future<void> skipToPrevious() => _playerService.seekToPrevious();

  @override
  Future<void> setSpeed(double speed) => _playerService.setSpeed(speed);

  @override
  Future<void> setRepeatMode(
    audio_service.AudioServiceRepeatMode repeatMode,
  ) {
    return _playerService.setLoopMode(_toAudioLoopMode(repeatMode));
  }

  @override
  Future<void> setShuffleMode(
    audio_service.AudioServiceShuffleMode shuffleMode,
  ) {
    return _playerService.setShuffleModeEnabled(
      enabled: shuffleMode != audio_service.AudioServiceShuffleMode.none,
    );
  }

  /// Releases resources held by this handler and the wrapped service.
  Future<void> dispose() async {
    await _subscription.cancel();
    await _playerService.dispose();
  }

  void _onSnapshot(AudioPlaybackSnapshot snapshot) {
    if (_isSignificant(snapshot)) _broadcastPlaybackState(snapshot);
  }

  /// Whether [next] is worth pushing to the OS media session.
  ///
  /// The engine reports a new position roughly every 200ms while playing;
  /// pushing every one of those across the platform channel costs battery
  /// for no benefit, since the OS already extrapolates the displayed
  /// position from `updatePosition`/`updateTime`/`speed` between updates.
  /// A real seek is still caught: it moves position further than normal
  /// playback progression could explain since the last broadcast.
  bool _isSignificant(AudioPlaybackSnapshot next) {
    final prev = _lastBroadcastSnapshot;
    final prevTime = _lastBroadcastTime;
    if (prev == null || prevTime == null) return true;
    if (prev.playing != next.playing ||
        prev.processingState != next.processingState ||
        prev.speed != next.speed ||
        prev.currentIndex != next.currentIndex ||
        prev.queueLength != next.queueLength ||
        prev.loopMode != next.loopMode ||
        prev.shuffleModeEnabled != next.shuffleModeEnabled ||
        prev.duration != next.duration) {
      return true;
    }
    final elapsed = DateTime.now().difference(prevTime);
    final expected =
        prev.position + (prev.playing ? elapsed * prev.speed : Duration.zero);
    final drift = next.position - expected;
    return drift.abs() > const Duration(seconds: 2);
  }

  void _broadcastPlaybackState(AudioPlaybackSnapshot snapshot) {
    _lastBroadcastSnapshot = snapshot;
    _lastBroadcastTime = DateTime.now();
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          audio_service.MediaControl.skipToPrevious,
          if (snapshot.playing)
            audio_service.MediaControl.pause
          else
            audio_service.MediaControl.play,
          audio_service.MediaControl.skipToNext,
        ],
        systemActions: const {audio_service.MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _toAudioServiceProcessingState(
          snapshot.processingState,
        ),
        playing: snapshot.playing,
        updatePosition: snapshot.position,
        bufferedPosition: snapshot.bufferedPosition,
        speed: snapshot.speed,
        repeatMode: _toAudioServiceRepeatMode(snapshot.loopMode),
        shuffleMode: snapshot.shuffleModeEnabled
            ? audio_service.AudioServiceShuffleMode.all
            : audio_service.AudioServiceShuffleMode.none,
        queueIndex: snapshot.currentIndex,
      ),
    );
    _publishCurrentMediaItem();
  }

  void _publishCurrentMediaItem() {
    final index = _playerService.snapshot.currentIndex;
    final items = queue.value;
    if (index == null || index >= items.length) {
      mediaItem.add(null);
      return;
    }
    mediaItem.add(
      items[index].copyWith(duration: _playerService.snapshot.duration),
    );
  }
}

audio_service.AudioProcessingState _toAudioServiceProcessingState(
  AudioProcessingState state,
) {
  switch (state) {
    case AudioProcessingState.idle:
      return audio_service.AudioProcessingState.idle;
    case AudioProcessingState.loading:
      return audio_service.AudioProcessingState.loading;
    case AudioProcessingState.buffering:
      return audio_service.AudioProcessingState.buffering;
    case AudioProcessingState.ready:
      return audio_service.AudioProcessingState.ready;
    case AudioProcessingState.completed:
      return audio_service.AudioProcessingState.completed;
  }
}

audio_service.AudioServiceRepeatMode _toAudioServiceRepeatMode(
  AudioLoopMode mode,
) {
  switch (mode) {
    case AudioLoopMode.off:
      return audio_service.AudioServiceRepeatMode.none;
    case AudioLoopMode.track:
      return audio_service.AudioServiceRepeatMode.one;
    case AudioLoopMode.queue:
      return audio_service.AudioServiceRepeatMode.all;
  }
}

AudioLoopMode _toAudioLoopMode(audio_service.AudioServiceRepeatMode mode) {
  switch (mode) {
    case audio_service.AudioServiceRepeatMode.none:
      return AudioLoopMode.off;
    case audio_service.AudioServiceRepeatMode.one:
      return AudioLoopMode.track;
    case audio_service.AudioServiceRepeatMode.all:
    case audio_service.AudioServiceRepeatMode.group:
      return AudioLoopMode.queue;
  }
}
