import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// The kind of feedback an [AppToast] conveys.
enum AppToastVariant {
  /// An action completed successfully.
  success,

  /// An action failed.
  error,

  /// Something the user should be aware of, short of a failure.
  warning,

  /// Neutral, informational feedback.
  information,
}

/// Brief, non-blocking feedback shown as a floating snack bar.
///
/// The surface stays monochrome; only the leading icon takes the variant's
/// semantic color, matching the app's textual-feedback-only use of color.
abstract final class AppToast {
  /// Shows a toast with [message], replacing any toast already visible.
  static void show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.information,
  }) {
    final colors = context.colors;
    final icon = switch (variant) {
      AppToastVariant.success => Icons.check_circle_outline,
      AppToastVariant.error => Icons.error_outline,
      AppToastVariant.warning => Icons.warning_amber_rounded,
      AppToastVariant.information => Icons.info_outline,
    };
    final iconColor = switch (variant) {
      AppToastVariant.success => colors.success,
      AppToastVariant.error => colors.error,
      AppToastVariant.warning => colors.warning,
      AppToastVariant.information => colors.onAccent,
    };

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.accent,
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          duration: const Duration(milliseconds: 1600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          content: Row(
            children: [
              Icon(icon, size: AppSizes.iconSmall, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.action.copyWith(color: colors.onAccent),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
