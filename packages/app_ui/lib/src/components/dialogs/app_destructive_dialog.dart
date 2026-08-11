import 'package:app_ui/src/components/buttons/app_text_button.dart';
import 'package:app_ui/src/components/dialogs/app_dialog.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

/// A dialog asking the user to confirm a destructive action (e.g. deleting a
/// file from the device), which must always require explicit confirmation.
abstract final class AppDestructiveDialog {
  /// Shows the dialog and returns `true` when confirmed, `false` otherwise
  /// (including when dismissed).
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colors = dialogContext.colors;
        return AppDialog(
          title: title,
          message: message,
          actions: [
            AppTextButton(
              label: cancelLabel,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppTextButton(
              label: confirmLabel,
              color: colors.error,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}
