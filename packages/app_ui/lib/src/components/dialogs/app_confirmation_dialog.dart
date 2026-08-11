import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/components/buttons/app_text_button.dart';
import 'package:app_ui/src/components/dialogs/app_dialog.dart';
import 'package:flutter/material.dart';

/// A dialog asking the user to confirm a non-destructive action.
abstract final class AppConfirmationDialog {
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
      builder: (dialogContext) => AppDialog(
        title: title,
        message: message,
        actions: [
          AppTextButton(
            label: cancelLabel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppPrimaryButton(
            label: confirmLabel,
            height: 40,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
