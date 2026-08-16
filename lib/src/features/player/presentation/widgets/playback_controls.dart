import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

const List<AudioLoopMode> _loopModeCycle = [
  AudioLoopMode.off,
  AudioLoopMode.queue,
  AudioLoopMode.track,
];

AudioLoopMode _nextLoopMode(AudioLoopMode current) {
  final index = _loopModeCycle.indexOf(current);
  return _loopModeCycle[(index + 1) % _loopModeCycle.length];
}

/// Playback transport: shuffle, previous, play/pause, next and repeat.
///
/// Haptic feedback on tap comes from [Pressable] itself (via
/// [AppIconButton]/[AppPlayPauseButton]), gated app-wide by
/// `Pressable.hapticsEnabled` rather than here.
class PlaybackControls extends ConsumerWidget {
  /// Creates a [PlaybackControls].
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    // Selects only the fields this row actually shows, so the frequent
    // position ticks during playback don't rebuild it.
    final (playing, shuffleEnabled, loopMode) = ref.watch(
      playbackViewModelProvider.select(
        (state) => (
          state.value?.playing ?? false,
          state.value?.shuffleModeEnabled ?? false,
          state.value?.loopMode ?? AudioLoopMode.off,
        ),
      ),
    );
    final repeatIcon = loopMode == AudioLoopMode.track
        ? Icons.repeat_one_rounded
        : Icons.repeat_rounded;
    final repeatActive = loopMode != AudioLoopMode.off;
    // The five controls need ~262px; anything narrower than that plus the
    // usual xxl margins would clip on small phones (e.g. a 320px-wide
    // screen), so fall back to a tighter margin there.
    final horizontalPadding = MediaQuery.sizeOf(context).width < 360
        ? AppSpacing.lg
        : AppSpacing.xxl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            icon: Icons.shuffle_rounded,
            semanticLabel: l10n.shuffleButtonSemanticLabel,
            color: shuffleEnabled ? colors.textPrimary : colors.textTertiary,
            onPressed: () => unawaited(
              ref
                  .read(queueViewModelProvider.notifier)
                  .setShuffleModeEnabled(enabled: !shuffleEnabled),
            ),
          ),
          AppIconButton(
            icon: Icons.skip_previous_rounded,
            semanticLabel: l10n.previousTrackButtonSemanticLabel,
            size: 50,
            iconSize: 30,
            onPressed: () => unawaited(
              ref.read(audioPlayerServiceProvider).seekToPrevious(),
            ),
          ),
          AppPlayPauseButton(
            isPlaying: playing,
            size: 66,
            playSemanticLabel: l10n.playButtonSemanticLabel,
            pauseSemanticLabel: l10n.pauseButtonSemanticLabel,
            onTap: () {
              final service = ref.read(audioPlayerServiceProvider);
              unawaited(playing ? service.pause() : service.play());
            },
          ),
          AppIconButton(
            icon: Icons.skip_next_rounded,
            semanticLabel: l10n.nextTrackButtonSemanticLabel,
            size: 50,
            iconSize: 30,
            onPressed: () =>
                unawaited(ref.read(audioPlayerServiceProvider).seekToNext()),
          ),
          AppIconButton(
            icon: repeatIcon,
            semanticLabel: l10n.repeatButtonSemanticLabel,
            color: repeatActive ? colors.textPrimary : colors.textTertiary,
            onPressed: () => unawaited(
              ref
                  .read(queueViewModelProvider.notifier)
                  .setLoopMode(_nextLoopMode(loopMode)),
            ),
          ),
        ],
      ),
    );
  }
}
