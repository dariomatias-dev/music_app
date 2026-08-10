import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Progress of the library scan/indexing operation.
class AppIndexingProgress extends StatelessWidget {
  /// Creates an [AppIndexingProgress].
  const AppIndexingProgress({
    required this.processedCount,
    required this.totalCount,
    this.message,
    super.key,
  });

  /// Number of files processed so far.
  final int processedCount;

  /// Total number of files to process. When `null`, the total is not yet
  /// known and the bar is shown as indeterminate.
  final int? totalCount;

  /// Optional text shown above the progress bar.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = totalCount;
    final text = message;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null) ...[
          Text(
            text,
            style: AppTypography.rowSubtitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: total == null || total == 0
                ? null
                : (processedCount / total).clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: colors.surfaceAlt,
            color: colors.accent,
          ),
        ),
      ],
    );
  }
}
