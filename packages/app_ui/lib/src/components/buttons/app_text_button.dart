import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A plain text button, for secondary or low-emphasis actions (e.g. "See
/// all" next to a section title).
class AppTextButton extends StatelessWidget {
  /// Creates an [AppTextButton].
  const AppTextButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  /// The button's text.
  final String label;

  /// Called when tapped. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show a loading indicator instead of the label, and block
  /// taps.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: isEnabled || isLoading ? 1 : 0.4,
      child: Pressable(
        scale: 0.94,
        onTap: isEnabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: isLoading
              ? SizedBox(
                  width: AppSizes.iconExtraSmall,
                  height: AppSizes.iconExtraSmall,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.textSecondary,
                  ),
                )
              : Text(
                  label,
                  style: AppTypography.action.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }
}
