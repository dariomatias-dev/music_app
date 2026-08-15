import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';

/// Shows a sheet listing every playlist, adding [trackId] to whichever one
/// is tapped.
Future<void> showAddToPlaylistSheet(
  BuildContext context,
  WidgetRef ref,
  String trackId,
) {
  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => _AddToPlaylistSheetContent(trackId: trackId),
  );
}

class _AddToPlaylistSheetContent extends ConsumerWidget {
  const _AddToPlaylistSheetContent({required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final playlists = ref.watch(playlistsProvider).value ?? const [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 6),
          child: Text(
            l10n.addToPlaylistLabel,
            style: AppTypography.section.copyWith(color: colors.textPrimary),
          ),
        ),
        if (playlists.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
            child: Text(
              l10n.playlistsEmptyMessage,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
          )
        else
          for (final playlist in playlists)
            AppSheetAction(
              icon: Icons.queue_music_rounded,
              label: playlist.name,
              onTap: () => unawaited(_add(context, ref, playlist.id)),
            ),
        const SizedBox(height: 6),
      ],
    );
  }

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    String playlistId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final repository = ref.read(playlistRepositoryProvider);
    final currentIds = await repository.watchPlaylistTrackIds(playlistId).first;

    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (currentIds.contains(trackId)) {
      AppToast.show(context, message: l10n.trackAlreadyInPlaylistMessage);
      return;
    }
    await repository.setPlaylistTracks(playlistId, [...currentIds, trackId]);
    if (!context.mounted) return;
    AppToast.show(
      context,
      message: l10n.addedToPlaylistMessage,
      variant: AppToastVariant.success,
    );
  }
}
