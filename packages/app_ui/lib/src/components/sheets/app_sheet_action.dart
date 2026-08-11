import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A single contextual action row inside a bottom sheet (e.g. "Add to
/// playlist", "Remove from queue").
class AppSheetAction extends StatelessWidget {
  /// Creates an [AppSheetAction].
  const AppSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.destructive = false,
    super.key,
  });

  /// The action's icon.
  final IconData icon;

  /// The action's text.
  final String label;

  /// Called when tapped.
  final VoidCallback onTap;

  /// Optional trailing text (e.g. a value or shortcut hint).
  final String? trailing;

  /// Whether this is a de-emphasized, destructive action. The row stays
  /// monochrome; actual confirmation belongs in a follow-up dialog.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive ? colors.textSecondary : colors.textPrimary;
    final trailingText = trailing;

    return Pressable(
      scale: 0.98,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowTitle.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
