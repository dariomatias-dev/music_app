import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/presentation/view_models/playlist_track_sort_view_model.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_track_sort_sheet.dart';

/// The row above a playlist's track list: track count and the sort control.
class PlaylistSortRow extends ConsumerWidget {
  /// Creates a [PlaylistSortRow].
  const PlaylistSortRow({
    required this.trackCount,
    required this.sort,
    super.key,
  });

  /// Number of tracks currently shown.
  final int trackCount;

  /// The active sort order.
  final PlaylistTrackSort sort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.smMd,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.trackCountLabel(trackCount),
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
          Pressable(
            scale: 0.97,
            onTap: () => unawaited(showPlaylistTrackSortSheet(context, ref)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
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
                    playlistTrackSortLabel(l10n, sort),
                    style: AppTypography.meta.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
