import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Skip to the next/previous track when a horizontal drag ends faster than
/// this, in logical pixels per second.
const _skipVelocityThreshold = 220.0;

/// Open the playback screen when a vertical drag ends faster than this,
/// in logical pixels per second.
const _openVelocityThreshold = 180.0;

/// Persistent transport docked above the bottom navigation.
///
/// A floating card that keeps the app's content gutter as its side margins,
/// so its edges line up with the rows and headers scrolling above it.
/// Animates in and out as the queue goes from empty to loaded and back, and
/// uses the opposite theme brightness from the screen behind it, so it
/// always reads as a distinct layer over the content.
class MiniPlayer extends ConsumerWidget {
  /// Creates a [MiniPlayer].
  const MiniPlayer({super.key});

  /// The card's height.
  static const height = 70.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueViewModelProvider);
    final playback = ref.watch(playbackViewModelProvider).value;

    final currentIndex = playback?.currentIndex;
    final currentItem = currentIndex == null || currentIndex >= queue.length
        ? null
        : queue[currentIndex];

    final invertedTheme = Theme.of(context).brightness == Brightness.dark
        ? AppTheme.light
        : AppTheme.dark;

    return AnimatedSwitcher(
      duration: AppDurations.base,
      switchInCurve: AppCurves.emphasized,
      switchOutCurve: AppCurves.emphasized,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: currentItem == null
          ? const SizedBox.shrink()
          : Theme(
              key: const ValueKey('mini-player-visible'),
              data: invertedTheme,
              child: _MiniPlayerCard(
                item: currentItem,
                playing: playback?.playing ?? false,
                position: playback?.position ?? Duration.zero,
                duration: playback?.duration ?? currentItem.duration,
              ),
            ),
    );
  }
}

class _MiniPlayerCard extends ConsumerWidget {
  const _MiniPlayerCard({
    required this.item,
    required this.playing,
    required this.position,
    required this.duration,
  });

  final QueueMediaItem item;
  final bool playing;
  final Duration position;
  final Duration? duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currentDuration = duration;
    final progress = currentDuration != null && currentDuration > Duration.zero
        ? (position.inMilliseconds / currentDuration.inMilliseconds).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        key: const ValueKey('miniPlayerGestureArea'),
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -_openVelocityThreshold) {
            unawaited(context.push(RoutePaths.player));
          }
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          final service = ref.read(audioPlayerServiceProvider);
          if (velocity < -_skipVelocityThreshold) {
            if (Pressable.hapticsEnabled) {
              unawaited(HapticFeedback.selectionClick());
            }
            unawaited(service.seekToNext());
          } else if (velocity > _skipVelocityThreshold) {
            if (Pressable.hapticsEnabled) {
              unawaited(HapticFeedback.selectionClick());
            }
            unawaited(service.seekToPrevious());
          }
        },
        child: Pressable(
          scale: 0.985,
          onTap: () => context.push(RoutePaths.player),
          child: Container(
            height: MiniPlayer.height,
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.large),
              boxShadow: AppElevations.high(colors.shadow),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Hero(
                  tag: heroTagFor(origin: 'player', id: item.id),
                  child: TrackArtwork(
                    item: item,
                    size: 52,
                    radius: AppRadius.small,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _MiniPlayerLabel(item: item)),
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
        ),
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
