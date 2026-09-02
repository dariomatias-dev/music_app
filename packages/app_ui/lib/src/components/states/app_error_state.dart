import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/components/states/app_state_layout.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Shown when an operation fails.
class AppErrorState extends StatelessWidget {
  /// Creates an [AppErrorState].
  const AppErrorState({
    required this.icon,
    required this.title,
    required this.message,
    this.retryLabel,
    this.onRetry,
    this.technicalDetails,
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Localized, user-facing explanation of the failure.
  final String message;

  /// Label of the retry action. Required together with [onRetry] to show
  /// the action.
  final String? retryLabel;

  /// Called when the retry action is tapped. When `null`, no retry action
  /// is shown.
  final VoidCallback? onRetry;

  /// Technical failure details, shown only in debug builds.
  final String? technicalDetails;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    final label = retryLabel;
    final details = technicalDetails;

    return AppStateLayout(
      icon: icon,
      title: title,
      message: message,
      children: [
        if (kDebugMode && details != null) ...[
          const SizedBox(height: AppSpacing.smMd),
          Text(
            details,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: context.colors.error),
          ),
        ],
        if (retry != null && label != null) ...[
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(label: label, onPressed: retry),
        ],
      ],
    );
  }
}
