import 'dart:async';

import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sleep_timer_view_model.g.dart';

/// Whether a sleep timer is active, pausing playback once it fires.
///
/// Kept alive across navigation, so leaving and returning to the playback
/// screen doesn't cancel a running timer.
@Riverpod(keepAlive: true)
class SleepTimerViewModel extends _$SleepTimerViewModel {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    return false;
  }

  /// Starts a timer that pauses playback after [duration].
  void start(Duration duration) {
    _timer?.cancel();
    state = true;
    _timer = Timer(duration, () {
      unawaited(ref.read(audioPlayerServiceProvider).pause());
      state = false;
    });
  }

  /// Cancels a running timer without pausing playback.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    state = false;
  }
}
