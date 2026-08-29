import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A titled section on the statistics screen, optionally padded on the
/// sides (unpadded for full-bleed lists like the most-played rows).
class StatisticsSection extends StatelessWidget {
  /// Creates a [StatisticsSection].
  const StatisticsSection({
    required this.title,
    required this.child,
    this.padded = true,
    super.key,
  });

  /// The section's title.
  final String title;

  /// The section's content.
  final Widget child;

  /// Whether [child] gets horizontal page padding.
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              title,
              style: AppTypography.section.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (padded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: child,
            )
          else
            child,
        ],
      ),
    );
  }
}
