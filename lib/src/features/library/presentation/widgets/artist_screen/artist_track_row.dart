import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/playback_state_indicator.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// One track row in the artist screen's discography list.
class ArtistTrackRow extends StatelessWidget {
  /// Creates an [ArtistTrackRow].
  const ArtistTrackRow({
    required this.track,
    required this.current,
    required this.onTap,
    super.key,
  });

  /// The track this row represents.
  final Track track;

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
