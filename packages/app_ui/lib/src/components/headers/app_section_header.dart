import 'package:app_ui/src/components/buttons/app_text_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A "Title ... See all" row, heading a section of a screen.
class AppSectionHeader extends StatelessWidget {
  /// Creates an [AppSectionHeader].
  const AppSectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 10),
    super.key,
  });

  /// The section's title.
  final String title;

  /// Label of the optional trailing action (e.g. "See all").
  final String? actionLabel;

  /// Called when the action is tapped. Required together with
  /// [actionLabel] to show the action.
  final VoidCallback? onAction;

  /// Padding around the row.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = actionLabel;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.section.copyWith(color: colors.textPrimary),
            ),
          ),
          if (label != null) AppTextButton(label: label, onPressed: onAction),
        ],
      ),
    );
  }
}
