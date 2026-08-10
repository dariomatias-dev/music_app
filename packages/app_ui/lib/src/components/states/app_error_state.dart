import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
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
    final colors = context.colors;
    final retry = onRetry;
    final label = retryLabel;
    final details = technicalDetails;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: colors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
            if (kDebugMode && details != null) ...[
              const SizedBox(height: 12),
              Text(
                details,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: colors.error),
              ),
            ],
            if (retry != null && label != null) ...[
              const SizedBox(height: 20),
              AppPrimaryButton(label: label, onPressed: retry),
            ],
          ],
        ),
      ),
    );
  }
}
