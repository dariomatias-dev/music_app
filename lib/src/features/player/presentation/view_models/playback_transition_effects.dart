import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_state.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_transition_effects.g.dart';

/// How long playback pauses before resuming on an automatic track change,
/// when gapless playback is disabled.
const gaplessOffGapDuration = Duration(milliseconds: 400);

/// Number of steps used to animate a crossfade fade-in.
const _fadeSteps = 20;

/// Applies the user's gapless/crossfade preference whenever the current
/// queue item changes: either a brief pause (gapless disabled) or a
/// volume fade-in (crossfade enabled). Does nothing when gapless is
/// enabled and crossfade is off, matching the engine's own default
/// behavior.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.
@Riverpod(keepAlive: true)
class PlaybackTransitionEffects extends _$PlaybackTransitionEffects {
  int? _currentIndex;
  int _fadeToken = 0;

  /// Source of delays, overridable so tests can simulate elapsed time
  /// without real waits.
  @visibleForTesting
  Future<void> Function(Duration) delay = Future<void>.delayed;

  @override
  void build() {
    ref.listen(playbackViewModelProvider, (previous, next) {
      final state = next.value;
      if (state != null) _onStateChanged(state);
    });
  }

  void _onStateChanged(PlaybackState state) {
    final changed = state.currentIndex != _currentIndex;
    _currentIndex = state.currentIndex;
    if (!changed || state.currentIndex == null || !state.playing) return;

    final preferences = ref.read(playbackPreferencesViewModelProvider).value;
    if (preferences == null) return;

    if (preferences.crossfadeDuration > Duration.zero) {
      unawaited(_fadeIn(preferences.crossfadeDuration));
    } else if (!preferences.gaplessEnabled) {
      unawaited(_gapAndResume());
    }
  }

  Future<void> _fadeIn(Duration duration) async {
    final token = ++_fadeToken;
    final service = ref.read(audioPlayerServiceProvider);
    final stepDuration = duration ~/ _fadeSteps;
    await service.setVolume(0);
    for (var step = 1; step <= _fadeSteps; step++) {
      if (token != _fadeToken) return;
      await delay(stepDuration);
      if (token != _fadeToken) return;
      await service.setVolume(step / _fadeSteps);
    }
  }

  Future<void> _gapAndResume() async {
    final service = ref.read(audioPlayerServiceProvider);
    await service.pause();
    await delay(gaplessOffGapDuration);
    await service.play();
  }
}
