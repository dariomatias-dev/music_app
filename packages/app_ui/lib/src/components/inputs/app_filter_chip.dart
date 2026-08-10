import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// A pill-shaped, selectable filter chip.
class AppFilterChip extends StatelessWidget {
  /// Creates an [AppFilterChip].
  const AppFilterChip({
    required this.label,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  /// The chip's text.
  final String label;

  /// Called when tapped.
  final VoidCallback onTap;

  /// Whether the chip is selected.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      button: true,
      selected: selected,
      child: Pressable(
        scale: 0.93,
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.resolve(context, AppDurations.fast),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? colors.accent : colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? colors.onAccent : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
