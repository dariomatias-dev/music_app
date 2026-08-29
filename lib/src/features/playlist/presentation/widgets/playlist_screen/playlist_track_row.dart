import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

/// One track row within a playlist, in either the normal (play/more) or
/// reorder-editing (drag handle/remove) state.
class PlaylistTrackRow extends ConsumerWidget {
  /// Creates a [PlaylistTrackRow].
  const PlaylistTrackRow({
    required this.track,
    required this.index,
    required this.editing,
    required this.current,
    required this.playing,
    required this.onTap,
    required this.onRemove,
    required this.onMore,
    super.key,
  });

  /// The track this row represents.
  final Track track;

  /// The track's position, shown as a number when not editing and used for
  /// the drag handle when editing.
  final int index;

  /// Whether the row is shown in reorder-editing state.
  final bool editing;

  /// Whether this track is the one currently loaded in the player.
  final bool current;

  /// Whether playback is active, used for the current-track indicator.
  final bool playing;

  /// Called when the row is tapped to start playback, ignored while editing.
  final VoidCallback onTap;

  /// Called when the remove action is pressed while editing.
  final VoidCallback onRemove;

  /// Called when the overflow menu is pressed while not editing.
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final artistName = ref.watch(artistNamesProvider)[track.artistId];

    return Pressable(
      scale: 0.99,
      onTap: editing ? null : onTap,
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
                semanticLabel: l10n.removeFromPlaylistSemanticLabel,
                onPressed: onRemove,
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
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: current ? colors.accent : colors.textPrimary,
                    ),
                  ),
                  if (artistName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowSubtitle.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
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
            else ...[
              if (current)
                AppPlaybackIndicator(playing: playing, color: colors.accent)
              else
                Text(
                  formatDuration(track.duration),
                  style: AppTypography.meta.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              AppIconButton(
                icon: Icons.more_vert,
                semanticLabel: l10n.playlistOptionsSemanticLabel,
                size: 36,
                iconSize: AppSizes.iconSmall,
                onPressed: onMore,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
