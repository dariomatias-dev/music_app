import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// The base dialog shell: a title, a message and a row of actions.
///
/// Used directly for custom cases, and by the confirmation, destructive and
/// information dialogs for the common ones.
class AppDialog extends StatelessWidget {
  /// Creates an [AppDialog].
  const AppDialog({
    required this.title,
    required this.message,
    required this.actions,
    super.key,
  });

  /// The dialog's title.
  final String title;

  /// The dialog's explanatory message.
  final String message;

  /// Action widgets, right-aligned at the bottom.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.section.copyWith(
                fontSize: 17,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: AppSpacing.sm,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
