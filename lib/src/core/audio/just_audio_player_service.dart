import 'dart:async';

import 'package:just_audio/just_audio.dart' as ja;
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

/// [AudioPlayerService] implementation backed by `just_audio`.
class JustAudioPlayerService implements AudioPlayerService {
  /// Creates a [JustAudioPlayerService], optionally wrapping an existing
  /// [ja.AudioPlayer] (useful for tests).
  JustAudioPlayerService([ja.AudioPlayer? player])
    : _player = player ?? ja.AudioPlayer() {
    _subscriptions = [
      _player.playbackEventStream.listen(_onPlaybackEvent),
      _player.playingStream.listen(
        (playing) => _emit((s) => _copyWith(s, playing: playing)),
      ),
      _player.speedStream.listen(
        (speed) => _emit((s) => _copyWith(s, speed: speed)),
      ),
      _player.loopModeStream.listen(
        (mode) => _emit(
          (s) => _copyWith(s, loopMode: _fromJustAudioLoopMode(mode)),
        ),
      ),
      _player.shuffleModeEnabledStream.listen(
        (enabled) => _emit((s) => _copyWith(s, shuffleModeEnabled: enabled)),
      ),
      _player.positionStream.listen(
        (position) => _emit((s) => _copyWith(s, position: position)),
      ),
      _player.errorStream.listen(
        (error) => _errorController.add(
          PlaybackException('Playback failed.', cause: error),
        ),
      ),
    ];
  }

  final ja.AudioPlayer _player;
  late final List<StreamSubscription<void>> _subscriptions;
  final _snapshotController =
      StreamController<AudioPlaybackSnapshot>.broadcast();
  final _errorController = StreamController<PlaybackException>.broadcast();
  var _snapshot = const AudioPlaybackSnapshot.initial();

  @override
  AudioPlaybackSnapshot get snapshot => _snapshot;

  @override
  Stream<AudioPlaybackSnapshot> get snapshotStream =>
      _snapshotController.stream;

  @override
  Stream<PlaybackException> get errorStream => _errorController.stream;

  void _emit(AudioPlaybackSnapshot Function(AudioPlaybackSnapshot) update) {
    _snapshot = update(_snapshot);
    _snapshotController.add(_snapshot);
  }

  void _onPlaybackEvent(ja.PlaybackEvent event) {
    _emit(
      (s) => AudioPlaybackSnapshot(
        processingState: _fromJustAudioProcessingState(event.processingState),
        playing: s.playing,
        position: s.position,
        duration: event.duration,
        bufferedPosition: event.bufferedPosition,
        speed: s.speed,
        currentIndex: event.currentIndex,
        queueLength: s.queueLength,
        loopMode: s.loopMode,
        shuffleModeEnabled: s.shuffleModeEnabled,
      ),
    );
  }

  @override
  Future<void> setQueue(
    List<String> filePaths, {
    int initialIndex = 0,
    Duration? initialPosition,
  }) async {
    try {
      await _player.setAudioSources(
        filePaths.map(ja.AudioSource.file).toList(),
        initialIndex: filePaths.isEmpty ? null : initialIndex,
        initialPosition: initialPosition,
      );
    } on Exception catch (e) {
      throw PlaybackException('Failed to load queue.', cause: e);
    }
    _emit((s) => _copyWith(s, queueLength: filePaths.length));
  }

  @override
  Future<void> addToQueue(String filePath) async {
    await _player.addAudioSource(ja.AudioSource.file(filePath));
    _emit((s) => _copyWith(s, queueLength: _player.audioSources.length));
  }

  @override
  Future<void> insertNext(String filePath) async {
    final index = (_player.currentIndex ?? -1) + 1;
    await _player.insertAudioSource(index, ja.AudioSource.file(filePath));
    _emit((s) => _copyWith(s, queueLength: _player.audioSources.length));
  }

  @override
  Future<void> removeFromQueue(int index) async {
    await _player.removeAudioSourceAt(index);
    _emit((s) => _copyWith(s, queueLength: _player.audioSources.length));
  }

  @override
  Future<void> moveInQueue(int from, int to) async {
    await _player.moveAudioSource(from, to);
    _emit((s) => _copyWith(s, queueLength: _player.audioSources.length));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position, {int? index}) =>
      _player.seek(position, index: index);

  @override
  Future<void> seekToNext() => _player.seekToNext();

  @override
  Future<void> seekToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> setLoopMode(AudioLoopMode mode) =>
      _player.setLoopMode(_toJustAudioLoopMode(mode));

  @override
  Future<void> setShuffleModeEnabled({required bool enabled}) =>
      _player.setShuffleModeEnabled(enabled);

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _snapshotController.close();
    await _errorController.close();
    await _player.dispose();
  }

  AudioPlaybackSnapshot _copyWith(
    AudioPlaybackSnapshot snapshot, {
    bool? playing,
    Duration? position,
    double? speed,
    int? queueLength,
    AudioLoopMode? loopMode,
    bool? shuffleModeEnabled,
  }) {
    return AudioPlaybackSnapshot(
      processingState: snapshot.processingState,
      playing: playing ?? snapshot.playing,
      position: position ?? snapshot.position,
      duration: snapshot.duration,
      bufferedPosition: snapshot.bufferedPosition,
      speed: speed ?? snapshot.speed,
      currentIndex: snapshot.currentIndex,
      queueLength: queueLength ?? snapshot.queueLength,
      loopMode: loopMode ?? snapshot.loopMode,
      shuffleModeEnabled: shuffleModeEnabled ?? snapshot.shuffleModeEnabled,
    );
  }
}

AudioProcessingState _fromJustAudioProcessingState(ja.ProcessingState state) {
  switch (state) {
    case ja.ProcessingState.idle:
      return AudioProcessingState.idle;
    case ja.ProcessingState.loading:
      return AudioProcessingState.loading;
    case ja.ProcessingState.buffering:
      return AudioProcessingState.buffering;
    case ja.ProcessingState.ready:
      return AudioProcessingState.ready;
    case ja.ProcessingState.completed:
      return AudioProcessingState.completed;
  }
}

ja.LoopMode _toJustAudioLoopMode(AudioLoopMode mode) {
  switch (mode) {
    case AudioLoopMode.off:
      return ja.LoopMode.off;
    case AudioLoopMode.track:
      return ja.LoopMode.one;
    case AudioLoopMode.queue:
      return ja.LoopMode.all;
  }
}

AudioLoopMode _fromJustAudioLoopMode(ja.LoopMode mode) {
  switch (mode) {
    case ja.LoopMode.off:
      return AudioLoopMode.off;
    case ja.LoopMode.one:
      return AudioLoopMode.track;
    case ja.LoopMode.all:
      return AudioLoopMode.queue;
  }
}
