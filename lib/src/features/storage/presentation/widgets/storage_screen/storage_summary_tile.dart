import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';

/// Shows total device space used by the library.
class StorageSummaryTile extends StatelessWidget {
  /// Creates a [StorageSummaryTile].
  const StorageSummaryTile({required this.totalUsed, super.key});

  /// Total size in bytes used across all indexed folders.
  final int totalUsed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.sd_storage_outlined,
            size: 20,
            color: colors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.storageTotalUsedLabel,
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          Text(
            formatFileSize(totalUsed),
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
