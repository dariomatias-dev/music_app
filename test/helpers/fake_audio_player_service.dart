import 'dart:async';

import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

/// In-memory [AudioPlayerService] for tests, with no real audio engine.
class FakeAudioPlayerService implements AudioPlayerService {
  final _queue = <String>[];
  final _controller = StreamController<AudioPlaybackSnapshot>.broadcast();
  final _errorController = StreamController<PlaybackException>.broadcast();
  var _snapshot = const AudioPlaybackSnapshot.initial();

  final _snapshotHistory = <AudioPlaybackSnapshot>[];

  /// Every snapshot emitted so far, in order (not including the initial
  /// value of [snapshot]).
  List<AudioPlaybackSnapshot> get snapshotHistory =>
      List.unmodifiable(_snapshotHistory);

  @override
  AudioPlaybackSnapshot get snapshot => _snapshot;

  @override
  Stream<AudioPlaybackSnapshot> get snapshotStream => _controller.stream;

  @override
  Stream<PlaybackException> get errorStream => _errorController.stream;

  /// Emits [error] on [errorStream], simulating a playback failure.
  void emitError(PlaybackException error) => _errorController.add(error);

  void _emit(AudioPlaybackSnapshot Function(AudioPlaybackSnapshot) update) {
    _snapshot = update(_snapshot);
    _snapshotHistory.add(_snapshot);
    _controller.add(_snapshot);
  }

  @override
  Future<void> setQueue(
    List<String> filePaths, {
    int initialIndex = 0,
    Duration? initialPosition,
  }) async {
    _queue
      ..clear()
      ..addAll(filePaths);
    _emit(
      (s) => _copyWith(
        s,
        processingState: filePaths.isEmpty
            ? AudioProcessingState.idle
            : AudioProcessingState.ready,
        playing: false,
        position: initialPosition ?? Duration.zero,
        currentIndex: filePaths.isEmpty ? null : initialIndex,
        queueLength: filePaths.length,
        clearCurrentIndex: filePaths.isEmpty,
      ),
    );
  }

  @override
  Future<void> addToQueue(String filePath) async {
    _queue.add(filePath);
    _emit((s) => _copyWith(s, queueLength: _queue.length));
  }

  @override
  Future<void> insertNext(String filePath) async {
    final index = (_snapshot.currentIndex ?? -1) + 1;
    _queue.insert(index, filePath);
    _emit((s) => _copyWith(s, queueLength: _queue.length));
  }

  @override
  Future<void> removeFromQueue(int index) async {
    _queue.removeAt(index);
    _emit((s) => _copyWith(s, queueLength: _queue.length));
  }

  @override
  Future<void> moveInQueue(int from, int to) async {
    final item = _queue.removeAt(from);
    _queue.insert(to, item);
    _emit((s) => _copyWith(s, queueLength: _queue.length));
  }

  @override
  Future<void> play() async {
    _emit(
      (s) => _copyWith(
        s,
        playing: true,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> pause() async {
    _emit((s) => _copyWith(s, playing: false));
  }

  @override
  Future<void> stop() async {
    _emit(
      (s) => _copyWith(
        s,
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
  }

  @override
  Future<void> seek(Duration position, {int? index}) async {
    _emit(
      (s) => _copyWith(
        s,
        position: position,
        currentIndex: index ?? s.currentIndex,
      ),
    );
  }

  @override
  Future<void> seekToNext() async {
    final next = (_snapshot.currentIndex ?? -1) + 1;
    if (next >= _queue.length) return;
    _emit((s) => _copyWith(s, currentIndex: next, position: Duration.zero));
  }

  @override
  Future<void> seekToPrevious() async {
    final previous = (_snapshot.currentIndex ?? 0) - 1;
    if (previous < 0) return;
    _emit(
      (s) => _copyWith(s, currentIndex: previous, position: Duration.zero),
    );
  }

  @override
  Future<void> setSpeed(double speed) async {
    _emit((s) => _copyWith(s, speed: speed));
  }

  @override
  Future<void> setLoopMode(AudioLoopMode mode) async {
    _emit((s) => _copyWith(s, loopMode: mode));
  }

  @override
  Future<void> setShuffleModeEnabled({required bool enabled}) async {
    _emit((s) => _copyWith(s, shuffleModeEnabled: enabled));
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
    await _errorController.close();
  }

  /// Sets the current item's duration, for tests that exercise seeking or
  /// progress. Production implementations only learn this from the engine.
  void setDurationForTesting(Duration duration) {
    _emit((s) => _copyWith(s, duration: duration));
  }

  /// Reports the current item as finished, for tests that exercise
  /// completion handling. Production implementations only learn this from
  /// the engine.
  void completeCurrentItemForTesting() {
    _emit(
      (s) => _copyWith(s, processingState: AudioProcessingState.completed),
    );
  }

  AudioPlaybackSnapshot _copyWith(
    AudioPlaybackSnapshot snapshot, {
    AudioProcessingState? processingState,
    bool? playing,
    Duration? position,
    Duration? duration,
    Duration? bufferedPosition,
    double? speed,
    int? currentIndex,
    bool clearCurrentIndex = false,
    int? queueLength,
    AudioLoopMode? loopMode,
    bool? shuffleModeEnabled,
  }) {
    return AudioPlaybackSnapshot(
      processingState: processingState ?? snapshot.processingState,
      playing: playing ?? snapshot.playing,
      position: position ?? snapshot.position,
      duration: duration ?? snapshot.duration,
      bufferedPosition: bufferedPosition ?? snapshot.bufferedPosition,
      speed: speed ?? snapshot.speed,
      currentIndex: clearCurrentIndex
          ? null
          : (currentIndex ?? snapshot.currentIndex),
      queueLength: queueLength ?? snapshot.queueLength,
      loopMode: loopMode ?? snapshot.loopMode,
      shuffleModeEnabled: shuffleModeEnabled ?? snapshot.shuffleModeEnabled,
    );
  }
}
