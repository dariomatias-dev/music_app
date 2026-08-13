import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';

part 'playback_state.freezed.dart';

/// The app-wide playback state, mapped from the audio engine's snapshot.
@freezed
abstract class PlaybackState with _$PlaybackState {
  /// Creates a [PlaybackState].
  const factory PlaybackState({
    required AudioProcessingState processingState,
    required bool playing,
    required Duration position,
    required Duration? duration,
    required Duration bufferedPosition,
    required double speed,
    required int? currentIndex,
    required int queueLength,
    required AudioLoopMode loopMode,
    required bool shuffleModeEnabled,
  }) = _PlaybackState;

  /// The initial state: no queue loaded.
  factory PlaybackState.initial() =>
      PlaybackState.fromSnapshot(const AudioPlaybackSnapshot.initial());

  /// Maps an [AudioPlaybackSnapshot] from the audio engine into app state.
  factory PlaybackState.fromSnapshot(AudioPlaybackSnapshot snapshot) {
    return PlaybackState(
      processingState: snapshot.processingState,
      playing: snapshot.playing,
      position: snapshot.position,
      duration: snapshot.duration,
      bufferedPosition: snapshot.bufferedPosition,
      speed: snapshot.speed,
      currentIndex: snapshot.currentIndex,
      queueLength: snapshot.queueLength,
      loopMode: snapshot.loopMode,
      shuffleModeEnabled: snapshot.shuffleModeEnabled,
    );
  }
}
