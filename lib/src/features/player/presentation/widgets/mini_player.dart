import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Persistent transport docked above the bottom navigation.
///
/// A floating card that keeps the app's content gutter as its side margins,
/// so its edges line up with the rows and headers scrolling above it.
class MiniPlayer extends StatelessWidget {
  /// Creates a [MiniPlayer].
  const MiniPlayer({super.key});

  /// The card's height.
  static const height = 70.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppElevations.high(colors.shadow),
        ),
      ),
    );
  }
}
