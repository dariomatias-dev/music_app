import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';

/// A playlist's header: composed cover art, name, description, track
/// count/duration and the play/shuffle buttons.
class PlaylistHeader extends StatelessWidget {
  /// Creates a [PlaylistHeader].
  const PlaylistHeader({
    required this.playlistId,
    required this.playlistName,
    required this.description,
    required this.tracks,
    required this.albumArtwork,
    required this.onPlay,
    required this.onShuffle,
    super.key,
  });

  /// The playlist this header represents.
  final String playlistId;

  /// The playlist's name, or `null` while it's still loading.
  final String? playlistName;

  /// The playlist's description, if any.
  final String? description;

  /// The playlist's tracks, in display order.
  final List<Track> tracks;

  /// Album artwork paths keyed by album id, for the composed cover.
  final Map<String, String?> albumArtwork;

  /// Called when the play button is pressed, or `null` when disabled.
  final VoidCallback? onPlay;

  /// Called when the shuffle button is pressed, or `null` when disabled.
  final VoidCallback? onShuffle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final totalDuration = tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );
    final coverTracks = tracks
        .take(4)
        .map<PlaylistCoverTrack>(
          (track) => (seed: track.id, artworkPath: albumArtwork[track.albumId]),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaylistCoverArt(
                playlistId: playlistId,
                tracks: coverTracks,
                size: 140,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (playlistName != null)
                      Text(
                        playlistName!,
                        style: AppTypography.header.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.trackCountLabel(tracks.length)} · '
                      '${formatDuration(totalDuration)}',
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.rowSubtitle.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (tracks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lgXl),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: l10n.playLabel,
                    icon: Icons.play_arrow_rounded,
                    onPressed: onPlay,
                  ),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Expanded(
                  child: AppSecondaryButton(
                    label: l10n.shuffleButtonSemanticLabel,
                    icon: Icons.shuffle_rounded,
                    onPressed: onShuffle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lgXl),
          ],
        ],
      ),
    );
  }
}
