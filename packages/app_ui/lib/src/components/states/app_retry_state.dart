import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Shown when the main available action is repeating an operation (e.g.
/// re-scanning the library), without necessarily being an error.
class AppRetryState extends StatelessWidget {
  /// Creates an [AppRetryState].
  const AppRetryState({
    required this.icon,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Explanatory message.
  final String message;

  /// Label of the retry action.
  final String retryLabel;

  /// Called when the retry action is tapped.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
            const SizedBox(height: 20),
            AppPrimaryButton(label: retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
