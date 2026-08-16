import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/utils/stable_hash.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

/// Waveform seek bar for the current track, with elapsed/remaining time
/// labels below it. Tapping the time on the right toggles it between the
/// total duration and the time remaining.
///
/// Watches playback position itself, so a tick doesn't rebuild the rest of
/// the playback screen.
class PlaybackProgressBar extends ConsumerStatefulWidget {
  /// Creates a [PlaybackProgressBar].
  const PlaybackProgressBar({required this.item, super.key});

  /// The track currently loaded.
  final QueueMediaItem item;

  @override
  ConsumerState<PlaybackProgressBar> createState() =>
      _PlaybackProgressBarState();
}

class _PlaybackProgressBarState extends ConsumerState<PlaybackProgressBar> {
  var _showRemaining = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (position, playing, duration) = ref.watch(
      playbackViewModelProvider.select(
        (state) => (
          state.value?.position ?? Duration.zero,
          state.value?.playing ?? false,
          state.value?.duration ?? Duration.zero,
        ),
      ),
    );
    final progress = duration > Duration.zero
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      children: [
        AppWaveformSeekBar(
          progress: progress,
          isPlaying: playing,
          seed: stableHash(widget.item.id),
          onSeek: (value) {
            final target = duration * value;
            final service = ref.read(audioPlayerServiceProvider);
            unawaited(service.seek(target));
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDuration(position),
              style: AppTypography.meta.copyWith(color: colors.textSecondary),
            ),
            Pressable(
              scale: 0.9,
              onTap: () => setState(() => _showRemaining = !_showRemaining),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: Text(
                    _showRemaining
                        ? '-${formatDuration(duration - position)}'
                        : formatDuration(duration),
                    key: ValueKey(_showRemaining),
                    style: AppTypography.meta.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
