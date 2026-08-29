import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:path/path.dart' as p;

/// One indexed folder row: name, track count/size, expand toggle and the
/// include-in-scan switch.
class StorageFolderHeader extends StatelessWidget {
  /// Creates a [StorageFolderHeader].
  const StorageFolderHeader({
    required this.folder,
    required this.expanded,
    required this.enabled,
    required this.onExpandToggle,
    required this.onToggleIncluded,
    super.key,
  });

  /// The folder this row represents.
  final FolderUsage folder;

  /// Whether the folder's tracks are currently listed below it.
  final bool expanded;

  /// Whether the expand toggle and include switch respond to input.
  final bool enabled;

  /// Called when the row is tapped to expand or collapse its tracks.
  final VoidCallback onExpandToggle;

  /// Called when the include-in-scan switch changes.
  final ValueChanged<bool> onToggleIncluded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Pressable(
      onTap: folder.trackCount == 0 ? null : onExpandToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AnimatedRotation(
              turns: expanded ? 0.25 : 0,
              duration: AppDurations.resolve(context, AppDurations.fast),
              child: Icon(
                Icons.chevron_right_rounded,
                color: folder.trackCount == 0
                    ? colors.textTertiary.withValues(alpha: 0.4)
                    : colors.textTertiary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.basename(folder.path),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${l10n.trackCountLabel(folder.trackCount)} · '
                    '${formatFileSize(folder.sizeBytes)}',
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppSwitch(
              value: folder.isIncluded,
              onChanged: enabled ? onToggleIncluded : null,
              semanticLabel: l10n.includeInScanSemanticLabel,
            ),
          ],
        ),
      ),
    );
  }
}
