import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/playback_state_indicator.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// One numbered track row in the album screen's track list.
class AlbumTrackRow extends StatelessWidget {
  /// Creates an [AlbumTrackRow].
  const AlbumTrackRow({
    required this.track,
    required this.number,
    required this.current,
    required this.onTap,
    super.key,
  });

  /// The track this row represents.
  final Track track;

  /// The track's position within the album.
  final int number;

  /// Whether this track is the one currently loaded in the player.
  final bool current;

  /// Called when the row is tapped to start playback from here.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$number',
                style: AppTypography.caption.copyWith(
                  color: colors.textTertiary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowTitle.copyWith(
                  color: current ? colors.accent : colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (current)
              PlaybackStateIndicator(color: colors.accent)
            else
              Text(
                formatDuration(track.duration),
                style: AppTypography.meta.copyWith(
                  color: colors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
