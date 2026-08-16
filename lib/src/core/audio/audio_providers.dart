import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_session_coordinator.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

/// Provides the [AudioPlayerService] used across the app.
///
/// Must be overridden with the same instance passed to [MusicAudioHandler]
/// before the app starts, so both share a single underlying audio engine.
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  throw UnimplementedError('audioPlayerServiceProvider was not overridden');
});

/// Provides the [MusicAudioHandler] bridging playback to the OS media
/// notification and lock screen.
///
/// Must be overridden with the instance returned by `AudioService.init`
/// before the app starts, since creating it requires an async platform
/// call.
final audioHandlerProvider = Provider<MusicAudioHandler>((ref) {
  throw UnimplementedError('audioHandlerProvider was not overridden');
});

/// Provides the [AudioSessionCoordinator] handling audio focus,
/// interruptions and device disconnects.
///
/// Must be overridden with an already-[AudioSessionCoordinator.initialize]d
/// instance before the app starts.
final audioSessionCoordinatorProvider = Provider<AudioSessionCoordinator>((
  ref,
) {
  throw UnimplementedError(
    'audioSessionCoordinatorProvider was not overridden',
  );
});

/// Streams playback engine failures (e.g. a corrupt or missing file), so
/// the UI can surface them to the user.
final playbackErrorProvider = StreamProvider<PlaybackException>((ref) {
  return ref.watch(audioPlayerServiceProvider).errorStream;
});
