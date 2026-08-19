import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/utils/playback_speed_formatter.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

/// Presets cycled through by [PlaybackSpeedControl].
const _speedPresets = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];

/// Small pill that cycles the playback speed through a fixed set of
/// presets on tap.
class PlaybackSpeedControl extends ConsumerWidget {
  /// Creates a [PlaybackSpeedControl].
  const PlaybackSpeedControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(
      playbackViewModelProvider.select((state) => state.value?.speed ?? 1.0),
    );
    final index = _speedPresets.indexOf(speed);

    return AppTextButton(
      label: formatPlaybackSpeed(speed),
      onPressed: () {
        final next =
            _speedPresets[(index < 0 ? 0 : index + 1) % _speedPresets.length];
        unawaited(ref.read(audioPlayerServiceProvider).setSpeed(next));
      },
    );
  }
}
