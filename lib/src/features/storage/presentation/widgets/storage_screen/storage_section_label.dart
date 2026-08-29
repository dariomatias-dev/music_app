import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A section header label used between groups of rows on the storage screen.
class StorageSectionLabel extends StatelessWidget {
  /// Creates a [StorageSectionLabel].
  const StorageSectionLabel({required this.label, super.key});

  /// The section title to display.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: AppTypography.section.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}
