import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/core/widgets/playback_state_indicator.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';
import 'package:music_app/src/features/library/presentation/widgets/track_more_sheet.dart';
import 'package:music_app/src/features/library/presentation/widgets/track_sort_sheet.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Every indexed track, sortable, with tap-to-play-from-here.
class TracksTab extends ConsumerWidget {
  /// Creates a [TracksTab].
  const TracksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final tracks = ref.watch(sortedTracksProvider);
    final artistNames = ref.watch(artistNamesProvider);
    final albumNames = ref.watch(albumNamesProvider);
    final albumArtwork = ref.watch(albumArtworkProvider);
    final sort = ref.watch(trackSortViewModelProvider);
    final currentTrackId = ref.watch(playbackScreenViewModelProvider)?.id;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxs,
            AppSpacing.smMd,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Pressable(
                scale: 0.95,
                onTap: () => unawaited(showTrackSortSheet(context, ref)),
                child: ConstrainedBox(
                  // Keeps the tappable area at least the platform minimum,
                  // even though the visible icon and label are compact.
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.minTouchTarget,
                    minHeight: AppSizes.minTouchTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 17,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          _sortLabel(l10n, sort),
                          style: AppTypography.meta.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tracks.isEmpty
              ? AppEmptyState(
                  icon: Icons.music_note_outlined,
                  title: l10n.tracksEmptyTitle,
                  message: l10n.tracksEmptyMessage,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smMd,
                  ),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) => _TrackRow(
                    track: tracks[index],
                    artistName: artistNames[tracks[index].artistId],
                    artworkPath: albumArtwork[tracks[index].albumId],
                    current: tracks[index].id == currentTrackId,
                    onTap: () => unawaited(
                      ref
                          .read(queueViewModelProvider.notifier)
                          .playFromSource(tracks, startIndex: index),
                    ),
                    onLongPress: () => unawaited(
                      showTrackMoreSheet(
                        context,
                        ref,
                        track: tracks[index],
                        artistName: artistNames[tracks[index].artistId],
                        albumName: albumNames[tracks[index].albumId],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  String _sortLabel(AppLocalizations l10n, TrackSort sort) => switch (sort) {
    TrackSort.title => l10n.sortByTitleLabel,
    TrackSort.artist => l10n.sortByArtistLabel,
    TrackSort.dateAdded => l10n.sortByDateAddedLabel,
    TrackSort.duration => l10n.sortByDurationLabel,
  };
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.track,
    required this.artistName,
    required this.artworkPath,
    required this.current,
    required this.onTap,
    required this.onLongPress,
  });

  final Track track;
  final String? artistName;
  final String? artworkPath;
  final bool current;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final path = artworkPath;

    return Pressable(
      scale: 0.99,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _artwork(path),
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
                  const SizedBox(height: 2),
                  Text(
                    artistName ?? '',
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

  Widget _artwork(String? path) {
    if (path == null) {
      return AppArtwork(seed: track.id, size: 44, radius: AppRadius.small);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: CachedSquareImage(path: path, size: 44),
    );
  }
}
