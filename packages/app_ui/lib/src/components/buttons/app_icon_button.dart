import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:flutter/material.dart';

/// A circular icon-only button.
class AppIconButton extends StatelessWidget {
  /// Creates an [AppIconButton].
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = 44,
    this.iconSize = AppSizes.iconMedium,
    this.background,
    this.color,
    super.key,
  });

  /// The icon to display.
  final IconData icon;

  /// Called when tapped. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Spoken by screen readers; icon-only buttons are meaningless without it.
  final String semanticLabel;

  /// The button's overall size.
  final double size;

  /// The icon's size.
  final double iconSize;

  /// Background color. Defaults to transparent.
  final Color? background;

  /// Icon color. Defaults to the theme's primary text color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = onPressed != null;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.4,
        child: Pressable(
          scale: 0.88,
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: background ?? Colors.transparent,
            ),
            child: AnimatedSwitcher(
              duration: AppDurations.fast,
              switchInCurve: AppCurves.spring,
              switchOutCurve: AppCurves.emphasized,
              child: Icon(
                icon,
                key: ValueKey(Object.hash(icon, color)),
                size: iconSize,
                color: color ?? colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
