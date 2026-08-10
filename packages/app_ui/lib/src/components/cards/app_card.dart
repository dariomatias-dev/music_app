import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

/// A base card surface, optionally tappable.
class AppCard extends StatelessWidget {
  /// Creates an [AppCard].
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    super.key,
  });

  /// The card's content.
  final Widget child;

  /// Called when the card is tapped. When `null`, the card does not respond
  /// to taps.
  final VoidCallback? onTap;

  /// Padding around [child].
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Pressable(scale: 0.98, onTap: onTap, child: content);
  }
}
