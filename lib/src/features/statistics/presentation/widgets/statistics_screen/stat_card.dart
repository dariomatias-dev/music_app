import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A single labeled metric tile, used for the total-listened and streak
/// summary row.
class StatCard extends StatelessWidget {
  /// Creates a [StatCard].
  const StatCard({required this.label, required this.value, super.key});

  /// The metric's formatted value.
  final String value;

  /// The metric's label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smMd,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
