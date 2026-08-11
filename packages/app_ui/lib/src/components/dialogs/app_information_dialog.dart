import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/components/dialogs/app_dialog.dart';
import 'package:flutter/material.dart';

/// A dialog presenting information, dismissed with a single action.
abstract final class AppInformationDialog {
  /// Shows the dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String dismissLabel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: title,
        message: message,
        actions: [
          AppPrimaryButton(
            label: dismissLabel,
            height: 40,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }
}
