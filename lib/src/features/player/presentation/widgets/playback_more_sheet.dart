import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/player/presentation/widgets/file_info_dialog.dart';
import 'package:music_app/src/features/player/presentation/widgets/sleep_timer_sheet.dart';

/// Shows the current track's contextual actions sheet.
Future<void> showPlaybackMoreSheet(
  BuildContext context,
  WidgetRef ref,
  QueueMediaItem item,
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
        AppSheetHeader(
          artworkSeed: item.id,
          title: item.title,
          subtitle: item.artist ?? '',
        ),
        const SizedBox(height: 4),
        AppSheetAction(
          icon: Icons.queue_music_rounded,
          label: l10n.viewQueueLabel,
          onTap: () => close(() => context.push(RoutePaths.queue)),
        ),
        AppSheetAction(
          icon: Icons.playlist_add,
          label: l10n.addToPlaylistLabel,
          onTap: () => close(
            () => AppToast.show(
              context,
              message: l10n.playlistsComingSoonMessage,
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.menu_book_outlined,
          label: l10n.openLyricsLabel,
          onTap: () => close(() => context.push(RoutePaths.lyrics)),
        ),
        AppSheetAction(
          icon: Icons.timer_outlined,
          label: l10n.sleepTimerLabel,
          onTap: () => close(() => showSleepTimerSheet(context)),
        ),
        AppSheetAction(
          icon: Icons.info_outline,
          label: l10n.fileInfoLabel,
          onTap: () => close(() => showFileInfoDialog(context, ref, item.id)),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
