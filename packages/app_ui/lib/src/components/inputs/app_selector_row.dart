import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

/// A single-choice row, with a checkmark that scales in when selected.
///
/// Used for option lists such as language or sort-order pickers, typically
/// inside a bottom sheet.
class AppSelectorRow extends StatelessWidget {
  /// Creates an [AppSelectorRow].
  const AppSelectorRow({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// The option's text.
  final String label;

  /// Whether this option is the current selection.
  final bool selected;

  /// Called when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      button: true,
      selected: selected,
      child: Pressable(
        scale: 0.98,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              AnimatedScale(
                scale: selected ? 1 : 0,
                duration: AppDurations.resolve(context, AppDurations.base),
                curve: AppCurves.spring,
                child: Icon(
                  Icons.check_rounded,
                  size: 19,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
