import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

/// The animated bars marking the row of the track playing now.
///
/// Reads whether audio is running itself, so pausing and resuming rebuilds
/// this indicator alone; a list that passed `playing` down to its rows
/// instead would rebuild every one of them on each toggle.
class PlaybackStateIndicator extends ConsumerWidget {
  /// Creates a [PlaybackStateIndicator].
  const PlaybackStateIndicator({this.color, super.key});

  /// Bar color. Defaults to the theme's primary text color.
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing =
        ref.watch(
          playbackViewModelProvider.select((state) => state.value?.playing),
        ) ??
        false;

    return AppPlaybackIndicator(playing: playing, color: color);
  }
}
