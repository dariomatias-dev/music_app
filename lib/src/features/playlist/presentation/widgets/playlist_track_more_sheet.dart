import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/widgets/file_info_dialog.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/add_to_playlist_sheet.dart';

/// Shows a playlist track's contextual actions: add to another playlist,
/// remove from this one, and file information.
Future<void> showPlaylistTrackMoreSheet(
  BuildContext context,
  WidgetRef ref, {
  required String playlistId,
  required Track track,
  required String? artistName,
  required List<Track> playlistTracks,
}) {
  final l10n = AppLocalizations.of(context)!;

  void close(VoidCallback action) {
    Navigator.of(context).pop();
    action();
  }

  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSheetHeader(
          artworkSeed: track.id,
          title: track.title,
          subtitle: artistName ?? '',
        ),
        const SizedBox(height: 4),
        AppSheetAction(
          icon: Icons.playlist_add,
          label: l10n.addToPlaylistLabel,
          onTap: () => close(
            () => unawaited(showAddToPlaylistSheet(context, ref, track.id)),
          ),
        ),
        AppSheetAction(
          icon: Icons.remove_circle_outline,
          label: l10n.removeFromPlaylistLabel,
          destructive: true,
          onTap: () => close(
            () => unawaited(
              _confirmRemove(context, ref, playlistId, track, playlistTracks),
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.info_outline,
          label: l10n.fileInfoLabel,
          onTap: () => close(
            () => unawaited(showFileInfoDialog(context, ref, track.id)),
          ),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}

Future<void> _confirmRemove(
  BuildContext context,
  WidgetRef ref,
  String playlistId,
  Track track,
  List<Track> playlistTracks,
) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await AppDestructiveDialog.show(
    context,
    title: l10n.removeTrackConfirmTitle,
    message: l10n.removeTrackConfirmMessage,
    confirmLabel: l10n.deletePlaylistLabel,
    cancelLabel: l10n.cancelLabel,
  );
  if (!confirmed) return;
  final ids = playlistTracks.map((t) => t.id).toList()..remove(track.id);
  await ref.read(playlistRepositoryProvider).setPlaylistTracks(playlistId, ids);
}
