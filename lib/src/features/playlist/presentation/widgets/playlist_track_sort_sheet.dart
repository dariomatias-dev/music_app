import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/presentation/view_models/playlist_track_sort_view_model.dart';

/// Shows the playlist screen's sort options.
Future<void> showPlaylistTrackSortSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  void select(PlaylistTrackSort sort) {
    ref.read(playlistTrackSortViewModelProvider.notifier).order = sort;
    Navigator.of(context).pop();
  }

  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 2),
          child: Text(
            l10n.sortSheetTitle,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.reorder_rounded,
          label: l10n.sortByPlaylistOrderLabel,
          onTap: () => select(PlaylistTrackSort.custom),
        ),
        AppSheetAction(
          icon: Icons.sort_by_alpha_rounded,
          label: l10n.sortByTitleLabel,
          onTap: () => select(PlaylistTrackSort.title),
        ),
        AppSheetAction(
          icon: Icons.person_outline,
          label: l10n.sortByArtistLabel,
          onTap: () => select(PlaylistTrackSort.artist),
        ),
        AppSheetAction(
          icon: Icons.timer_outlined,
          label: l10n.sortByDurationLabel,
          onTap: () => select(PlaylistTrackSort.duration),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}

/// The visible label for [sort].
String playlistTrackSortLabel(AppLocalizations l10n, PlaylistTrackSort sort) {
  return switch (sort) {
    PlaylistTrackSort.custom => l10n.sortByPlaylistOrderLabel,
    PlaylistTrackSort.title => l10n.sortByTitleLabel,
    PlaylistTrackSort.artist => l10n.sortByArtistLabel,
    PlaylistTrackSort.duration => l10n.sortByDurationLabel,
  };
}
