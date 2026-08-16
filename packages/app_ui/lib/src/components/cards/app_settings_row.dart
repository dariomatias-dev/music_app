import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/components/cards/app_section_container.dart';
import 'package:app_ui/src/components/inputs/app_switch.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A single, standardized row within a settings section: a leading icon, a
/// label, and either a trailing value with a chevron (when [onTap] is set)
/// or a custom trailing widget (e.g. a switch).
///
/// Meant to be stacked inside an [AppSectionContainer], one per setting.
class AppSettingsRow extends StatelessWidget {
  /// Creates an [AppSettingsRow].
  const AppSettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    super.key,
  });

  /// Leading icon.
  final IconData icon;

  /// The setting's name.
  final String label;

  /// Current value shown before the chevron, when [onTap] navigates to
  /// change it (e.g. the selected language). Ignored when [trailing] is
  /// set.
  final String? value;

  /// Custom trailing content (e.g. an [AppSwitch]), replacing the default
  /// value-and-chevron.
  final Widget? trailing;

  /// Called when the row is tapped. When `null`, the row does not respond
  /// to taps and no chevron is shown unless [trailing] is set.
  final VoidCallback? onTap;

  /// Whether this row represents a destructive action (e.g. "Delete"),
  /// tinting the icon and label with the error color.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = destructive ? colors.error : colors.textPrimary;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconSmall,
            color: destructive ? colors.error : colors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowTitle.copyWith(color: foreground),
            ),
          ),
          if (trailing != null)
            trailing!
          else ...[
            if (value != null) ...[
              Flexible(
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.rowSubtitle.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
          ],
        ],
      ),
    );

    if (onTap == null) return content;
    return Pressable(scale: 0.99, onTap: onTap, child: content);
  }
}
