import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';

/// Configures the platform audio session for music playback and pauses
/// [_playerService] on interruptions (calls, other apps) and when audio
/// output devices (e.g. headphones) are disconnected.
class AudioSessionCoordinator {
  /// Creates an [AudioSessionCoordinator] for [_playerService], optionally
  /// over an existing [session] (useful for tests).
  AudioSessionCoordinator(this._playerService, {Future<AudioSession>? session})
    : _session = session ?? AudioSession.instance;

  final AudioPlayerService _playerService;
  final Future<AudioSession> _session;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSubscription;
  StreamSubscription<void>? _becomingNoisySubscription;

  /// Configures the audio session and starts listening for interruptions.
  ///
  /// Must be called once before playback starts.
  Future<void> initialize() async {
    final session = await _session;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
        ),
        androidWillPauseWhenDucked: true,
      ),
    );

    _interruptionSubscription = session.interruptionEventStream.listen(
      _onInterruption,
    );
    _becomingNoisySubscription = session.becomingNoisyEventStream.listen(
      (_) => _playerService.pause(),
    );
  }

  void _onInterruption(AudioInterruptionEvent event) {
    if (event.begin) unawaited(_playerService.pause());
  }

  /// Stops listening for interruptions.
  Future<void> dispose() async {
    await _interruptionSubscription?.cancel();
    await _becomingNoisySubscription?.cancel();
  }
}
