import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// An outlined, pill-shaped button for a secondary action of a screen.
class AppSecondaryButton extends StatelessWidget {
  /// Creates an [AppSecondaryButton].
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 48,
    super.key,
  });

  /// The button's text.
  final String label;

  /// Called when tapped. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether to show a loading indicator instead of the content, and block
  /// taps.
  final bool isLoading;

  /// The button's height.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: isEnabled || isLoading ? 1 : 0.4,
      child: Pressable(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: colors.divider),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: AppSizes.iconSmall,
                    height: AppSizes.iconSmall,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textPrimary,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: AppSizes.iconSmall,
                          color: colors.textPrimary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        label,
                        style: AppTypography.rowTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
