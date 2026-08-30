import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/playback_state_indicator.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// One track row in the queue list, in either the normal (tap to seek) or
/// editing (drag handle/remove) state.
class QueueRow extends ConsumerWidget {
  /// Creates a [QueueRow].
  const QueueRow({
    required this.item,
    required this.index,
    required this.current,
    required this.editing,
    super.key,
  });

  /// The queue item this row represents.
  final QueueMediaItem item;

  /// The item's position within the queue.
  final int index;

  /// Whether this item is the one currently loaded in the player.
  final bool current;

  /// Whether the row is shown in reorder-editing state.
  final bool editing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final titleColor = current ? colors.accent : colors.textPrimary;

    return Semantics(
      label: current ? l10n.nowPlayingSemanticLabel : null,
      child: Pressable(
        scale: 0.99,
        onTap: editing
            ? null
            : () => unawaited(
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
              if (editing)
                AppIconButton(
                  icon: Icons.remove_circle_outline,
                  semanticLabel: l10n.removeFromQueueSemanticLabel,
                  onPressed: () => unawaited(
                    ref.read(queueViewModelProvider.notifier).removeAt(index),
                  ),
                )
              else
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
              if (editing)
                ReorderableDragStartListener(
                  index: index,
                  child: Semantics(
                    label: l10n.dragToReorderSemanticLabel,
                    child: Icon(
                      Icons.drag_handle_rounded,
                      color: colors.textTertiary,
                    ),
                  ),
                )
              else if (current)
                PlaybackStateIndicator(color: colors.accent)
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
