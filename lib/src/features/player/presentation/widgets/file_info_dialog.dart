import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Looks up the track with [trackId] and shows its technical file
/// information in a dialog.
Future<void> showFileInfoDialog(
  BuildContext context,
  WidgetRef ref,
  String trackId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final tracks = await ref.read(libraryRepositoryProvider).watchTracks().first;
  Track? track;
  for (final candidate in tracks) {
    if (candidate.id == trackId) {
      track = candidate;
      break;
    }
  }
  if (track == null || !context.mounted) return;

  final lines = [
    '${l10n.fileInfoFormatLabel}: ${track.format.toUpperCase()}',
    '${l10n.fileInfoSizeLabel}: ${formatFileSize(track.fileSize)}',
    if (track.bitrate != null)
      '${l10n.fileInfoBitrateLabel}: ${(track.bitrate! / 1000).round()} kbps',
    if (track.sampleRate != null)
      '${l10n.fileInfoSampleRateLabel}: ${track.sampleRate} Hz',
    '${l10n.fileInfoPathLabel}: ${track.filePath}',
  ];

  await AppInformationDialog.show(
    context,
    title: l10n.fileInfoDialogTitle,
    message: lines.join('\n'),
    dismissLabel: l10n.dialogDismissLabel,
  );
}
