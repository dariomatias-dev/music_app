import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// One track row nested under an expanded folder, with a delete action.
class StorageTrackTile extends StatelessWidget {
  /// Creates a [StorageTrackTile].
  const StorageTrackTile({
    required this.track,
    required this.enabled,
    required this.onDelete,
    super.key,
  });

  /// The track this row represents.
  final Track track;

  /// Whether the delete action responds to input.
  final bool enabled;

  /// Called when the delete action is pressed.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxs,
        AppSpacing.smMd,
        AppSpacing.xxs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            formatFileSize(track.fileSize),
            style: AppTypography.meta.copyWith(color: colors.textTertiary),
          ),
          AppIconButton(
            icon: Icons.delete_outline_rounded,
            semanticLabel: l10n.deleteFileSemanticLabel,
            size: 36,
            iconSize: AppSizes.iconSmall,
            onPressed: enabled ? onDelete : null,
          ),
        ],
      ),
    );
  }
}
