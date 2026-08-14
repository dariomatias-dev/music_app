import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Persistent transport docked above the bottom navigation.
///
/// A floating card that keeps the app's content gutter as its side margins,
/// so its edges line up with the rows and headers scrolling above it. Shows
/// nothing while the queue is empty.
class MiniPlayer extends ConsumerWidget {
  /// Creates a [MiniPlayer].
  const MiniPlayer({super.key});

  /// The card's height.
  static const height = 70.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final queue = ref.watch(queueViewModelProvider);
    final playback = ref.watch(playbackViewModelProvider).value;

    final currentIndex = playback?.currentIndex;
    final currentItem = currentIndex == null || currentIndex >= queue.length
        ? null
        : queue[currentIndex];
    if (currentItem == null) return const SizedBox.shrink();

    final playing = playback?.playing ?? false;
    final duration = playback?.duration ?? currentItem.duration;
    final position = playback?.position ?? Duration.zero;
    final progress = duration != null && duration > Duration.zero
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppElevations.high(colors.shadow),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            _MiniPlayerArtwork(item: currentItem),
            const SizedBox(width: 12),
            Expanded(child: _MiniPlayerLabel(item: currentItem)),
            const SizedBox(width: 10),
            AnimatedOpacity(
              opacity: playing ? 0.7 : 0.25,
              duration: AppDurations.base,
              child: AppPlaybackIndicator(playing: playing),
            ),
            const SizedBox(width: 14),
            AppPlayPauseButton(
              isPlaying: playing,
              progress: progress,
              size: 44,
              onTap: () {
                final service = ref.read(audioPlayerServiceProvider);
                unawaited(playing ? service.pause() : service.play());
              },
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayerArtwork extends StatelessWidget {
  const _MiniPlayerArtwork({required this.item});

  final QueueMediaItem item;

  @override
  Widget build(BuildContext context) {
    final artworkPath = item.artworkPath;
    if (artworkPath == null) {
      return AppArtwork(seed: item.id, size: 52, radius: AppRadius.small);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Image.file(
        File(artworkPath),
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _MiniPlayerLabel extends StatelessWidget {
  const _MiniPlayerLabel({required this.item});

  final QueueMediaItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedSwitcher(
      duration: AppDurations.base,
      switchInCurve: AppCurves.emphasized,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.centerLeft,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Column(
        key: ValueKey(item.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 1),
          Text(
            item.artist ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.rowSubtitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
