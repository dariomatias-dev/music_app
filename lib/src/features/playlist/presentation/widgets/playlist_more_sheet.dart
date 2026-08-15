import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_name_sheet.dart';

/// Shows a playlist's contextual actions: rename, duplicate and delete.
Future<void> showPlaylistMoreSheet(
  BuildContext context,
  WidgetRef ref,
  Playlist playlist,
) {
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
        _PlaylistSheetHeader(playlist: playlist),
        const SizedBox(height: 4),
        AppSheetAction(
          icon: Icons.edit_outlined,
          label: l10n.renamePlaylistLabel,
          onTap: () => close(() => _rename(context, ref, playlist)),
        ),
        AppSheetAction(
          icon: Icons.copy_outlined,
          label: l10n.duplicatePlaylistLabel,
          onTap: () => close(() => _duplicate(context, ref, playlist)),
        ),
        AppSheetAction(
          icon: Icons.delete_outline,
          label: l10n.deletePlaylistLabel,
          destructive: true,
          onTap: () => close(() => _confirmDelete(context, ref, playlist)),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}

Future<void> _rename(
  BuildContext context,
  WidgetRef ref,
  Playlist playlist,
) async {
  final l10n = AppLocalizations.of(context)!;
  final name = await showPlaylistNameSheet(
    context,
    title: l10n.renamePlaylistSheetTitle,
    confirmLabel: l10n.saveLabel,
    initialName: playlist.name,
  );
  if (name == null) return;
  await ref.read(playlistRepositoryProvider).renamePlaylist(playlist.id, name);
}

Future<void> _duplicate(
  BuildContext context,
  WidgetRef ref,
  Playlist playlist,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = ref.read(playlistRepositoryProvider);
  final trackIds = await repository.watchPlaylistTrackIds(playlist.id).first;
  final newId = await repository.createPlaylist(
    l10n.playlistCopyName(playlist.name),
  );
  if (trackIds.isNotEmpty) {
    await repository.setPlaylistTracks(newId, trackIds);
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Playlist playlist,
) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await AppDestructiveDialog.show(
    context,
    title: l10n.deletePlaylistConfirmTitle,
    message: l10n.deletePlaylistConfirmMessage,
    confirmLabel: l10n.deletePlaylistLabel,
    cancelLabel: l10n.cancelLabel,
  );
  if (!confirmed) return;
  await ref.read(playlistRepositoryProvider).deletePlaylist(playlist.id);
}

class _PlaylistSheetHeader extends ConsumerWidget {
  const _PlaylistSheetHeader({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trackIds = ref.watch(playlistTrackIdsProvider(playlist.id));

    return AppSheetHeader(
      artworkSeed: playlist.id,
      title: playlist.name,
      subtitle: l10n.trackCountLabel(trackIds.value?.length ?? 0),
    );
  }
}
