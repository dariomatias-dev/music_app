import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_providers.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';
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
  String? _playId;

  // Read once in `build`, not inside `onDispose`: Riverpod forbids
  // `ref.read` from within a dispose callback, since it's a mutation of
  // the provider graph made while that same graph is already tearing
  // down.
  late PlayHistoryRepository _repository;
  late IdGenerator _idGenerator;

  /// Source of the current time, overridable so tests can simulate elapsed
  /// playback without real waits.
  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  @override
  void build() {
    _repository = ref.read(playHistoryRepositoryProvider);
    _idGenerator = ref.read(idGeneratorProvider);
    ref
      // Selects only currentIndex, playing and processingState: the
      // frequent position ticks during playback don't touch any of these,
      // so this stays idle except on an actual track/play-state change.
      ..listen(
        playbackViewModelProvider.select(
          (state) => (
            state.value?.currentIndex,
            state.value?.playing ?? false,
            state.value?.processingState,
          ),
        ),
        (previous, next) => _onStateChanged(
          currentIndex: next.$1,
          playing: next.$2,
          processingState: next.$3,
        ),
      )
      ..listen(appLifecycleStateProvider, (previous, current) {
        final state = current.value;
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) {
          _checkpoint();
        }
      })
      ..onDispose(() => _finalize(completed: false));
  }

  void _onStateChanged({
    required int? currentIndex,
    required bool playing,
    required AudioProcessingState? processingState,
  }) {
    final queue = ref.read(queueViewModelProvider);
    final currentId =
        (currentIndex != null &&
            currentIndex >= 0 &&
            currentIndex < queue.length)
        ? queue[currentIndex].id
        : null;

    if (currentId != _trackId) {
      _finalize(completed: false);
      _trackId = currentId;
      _startedAt = currentId == null ? null : clock();
    }

    if (_trackId == null) return;

    if (playing) {
      _accumulatingSince ??= clock();
    } else {
      _accumulate();
      _accumulatingSince = null;
    }

    if (processingState == AudioProcessingState.completed) {
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

  /// Writes the play in progress out without ending it, so it survives the
  /// process being killed while playback continues in the background.
  ///
  /// Every write of a play reuses that play's id, so this replaces the row
  /// it wrote before rather than recording a play the user never made.
  void _checkpoint() {
    _accumulate();
    _write(completed: false);
  }

  void _finalize({required bool completed}) {
    _accumulate();
    _write(completed: completed);
    _playedDuration = Duration.zero;
    _accumulatingSince = null;
    _playId = null;
  }

  void _write({required bool completed}) {
    final trackId = _trackId;
    final startedAt = _startedAt;
    if (trackId == null || startedAt == null) return;
    if (_playedDuration < _minPlayedDuration && !completed) return;

    unawaited(
      _repository.recordPlay(
        id: _playId ??= _idGenerator.generate(),
        trackId: trackId,
        startedAt: startedAt,
        playedDuration: _playedDuration,
        completed: completed,
      ),
    );
  }
}
