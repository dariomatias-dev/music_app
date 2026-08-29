import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A section header above a group of settings rows.
class SettingsGroupLabel extends StatelessWidget {
  /// Creates a [SettingsGroupLabel].
  const SettingsGroupLabel(this.text, {super.key});

  /// The section title to display.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        text,
        style: AppTypography.section.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
