import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/widgets/track_tag_edit_sheet.dart';
import 'package:music_app/src/features/player/presentation/widgets/file_info_dialog.dart';

/// Shows a track's contextual actions: edit tags and file information.
Future<void> showTrackMoreSheet(
  BuildContext context,
  WidgetRef ref, {
  required Track track,
  required String? artistName,
  required String? albumName,
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
          icon: Icons.edit_outlined,
          label: l10n.editTagsLabel,
          onTap: () => close(
            () => unawaited(
              _editTags(context, ref, track, artistName, albumName),
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

Future<void> _editTags(
  BuildContext context,
  WidgetRef ref,
  Track track,
  String? artistName,
  String? albumName,
) async {
  final result = await showTrackTagEditSheet(
    context,
    initialTitle: track.title,
    initialArtist: artistName ?? '',
    initialAlbum: albumName ?? '',
  );
  if (result == null) return;
  await ref
      .read(libraryRepositoryProvider)
      .updateTrackTags(
        track.id,
        title: result.title,
        artist: result.artist,
        album: result.album,
      );
}
