import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A centered loading spinner, with an optional message below it.
class AppLoadingIndicator extends StatelessWidget {
  /// Creates an [AppLoadingIndicator].
  const AppLoadingIndicator({this.message, this.size = 28, super.key});

  /// Optional text shown below the spinner.
  final String? message;

  /// The spinner's diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = message;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colors.textPrimary,
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              text,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
