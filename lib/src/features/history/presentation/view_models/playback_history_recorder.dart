import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_state.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_history_recorder.g.dart';

/// Minimum time actually played for a play to be counted, unless the track
/// played to completion in less than that.
const _minPlayedDuration = Duration(seconds: 30);

/// Watches playback and records how long each queued track is actually
/// played, so [PlayHistoryRepository] backs both recently-played and future
/// statistics.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.
@Riverpod(keepAlive: true)
class PlaybackHistoryRecorder extends _$PlaybackHistoryRecorder {
  String? _trackId;
  DateTime? _startedAt;
  Duration _playedDuration = Duration.zero;
  DateTime? _accumulatingSince;

  /// Source of the current time, overridable so tests can simulate elapsed
  /// playback without real waits.
  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  @override
  void build() {
    ref
      ..listen(playbackViewModelProvider, (previous, next) {
        final state = next.value;
        if (state != null) _onStateChanged(state);
      })
      ..onDispose(() => _finalize(completed: false));
  }

  void _onStateChanged(PlaybackState state) {
    final queue = ref.read(queueViewModelProvider);
    final index = state.currentIndex;
    final currentId = (index != null && index >= 0 && index < queue.length)
        ? queue[index].id
        : null;

    if (currentId != _trackId) {
      _finalize(completed: false);
      _trackId = currentId;
      _startedAt = currentId == null ? null : clock();
    }

    if (_trackId == null) return;

    if (state.playing) {
      _accumulatingSince ??= clock();
    } else {
      _accumulate();
      _accumulatingSince = null;
    }

    if (state.processingState == AudioProcessingState.completed) {
      _finalize(completed: true);
      _trackId = null;
    }
  }

  void _accumulate() {
    final since = _accumulatingSince;
    if (since == null) return;
    final now = clock();
    _playedDuration += now.difference(since);
    _accumulatingSince = now;
  }

  void _finalize({required bool completed}) {
    _accumulate();
    final trackId = _trackId;
    final startedAt = _startedAt;
    final playedDuration = _playedDuration;
    _playedDuration = Duration.zero;
    _accumulatingSince = null;

    if (trackId == null || startedAt == null) return;
    if (playedDuration < _minPlayedDuration && !completed) return;

    unawaited(
      ref
          .read(playHistoryRepositoryProvider)
          .recordPlay(
            trackId: trackId,
            startedAt: startedAt,
            playedDuration: playedDuration,
            completed: completed,
          ),
    );
  }
}
