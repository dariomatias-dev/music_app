import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Shows every track currently loaded into the playback queue, highlighting
/// the one playing now. Tapping a row jumps playback to that track.
///
/// Reordering, removal and clearing are added in Etapa 64.
class QueueScreen extends ConsumerWidget {
  /// Creates a [QueueScreen].
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final queue = ref.watch(queueViewModelProvider);
    final playback = ref.watch(playbackViewModelProvider).value;
    final currentIndex = playback?.currentIndex;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.viewQueueLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: queue.isEmpty
          ? AppEmptyState(
              icon: Icons.queue_music_rounded,
              title: l10n.queueEmptyTitle,
              message: l10n.queueEmptyMessage,
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
                vertical: AppSpacing.sm,
              ),
              itemCount: queue.length,
              itemBuilder: (context, index) => _QueueRow(
                item: queue[index],
                index: index,
                current: index == currentIndex,
                playing: playback?.playing ?? false,
              ),
            ),
    );
  }
}

class _QueueRow extends ConsumerWidget {
  const _QueueRow({
    required this.item,
    required this.index,
    required this.current,
    required this.playing,
  });

  final QueueMediaItem item;
  final int index;
  final bool current;
  final bool playing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final titleColor = current ? colors.accent : colors.textPrimary;

    return Semantics(
      label: current ? l10n.nowPlayingSemanticLabel : null,
      child: Pressable(
        scale: 0.99,
        onTap: () => unawaited(
          ref
              .read(audioPlayerServiceProvider)
              .seek(Duration.zero, index: index),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '${index + 1}',
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TrackArtwork(item: item, size: 44, radius: AppRadius.small),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowTitle.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: 2),
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
              ),
              const SizedBox(width: AppSpacing.sm),
              if (current)
                AppPlaybackIndicator(playing: playing, color: colors.accent)
              else if (item.duration != null)
                Text(
                  formatDuration(item.duration!),
                  style: AppTypography.meta.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
