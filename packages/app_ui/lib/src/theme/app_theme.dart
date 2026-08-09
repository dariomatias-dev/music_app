import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_colors.dart';
import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Builds the [ThemeData] for [brightness] from the design tokens.
ThemeData _buildThemeData(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? AppColors.dark
      : AppColors.light;
  final base = brightness == Brightness.dark
      ? ThemeData.dark()
      : ThemeData.light();

  final textTheme = base.textTheme.apply(
    bodyColor: colors.textPrimary,
    displayColor: colors.textPrimary,
    fontFamily: AppTypography.fontFamily,
  );

  return base.copyWith(
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    textTheme: textTheme,
    colorScheme: base.colorScheme.copyWith(
      surface: colors.background,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      secondary: colors.textSecondary,
      error: colors.error,
    ),
    iconTheme: IconThemeData(
      color: colors.textPrimary,
      size: AppSizes.iconMedium,
    ),
    dividerColor: colors.divider,
    splashFactory: InkSparkle.splashFactory,
    highlightColor: colors.textPrimary.withValues(alpha: 0.04),
    splashColor: colors.textPrimary.withValues(alpha: 0.06),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.appBar.copyWith(color: colors.textPrimary),
    ),
    extensions: [AppColorsExtension(colors)],
  );
}

/// Design System theme for the app.
abstract final class AppTheme {
  /// Light theme.
  static final ThemeData light = _buildThemeData(Brightness.light);

  /// Dark theme.
  static final ThemeData dark = _buildThemeData(Brightness.dark);
}

/// Wraps [child] in an animated crossfade whenever [data] changes, so theme
/// switches are never an abrupt cut.
class AppThemeSwitcher extends StatelessWidget {
  /// Creates an [AppThemeSwitcher].
  const AppThemeSwitcher({required this.data, required this.child, super.key});

  /// The theme to animate towards.
  final ThemeData data;

  /// The subtree themed by [data].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: data,
      duration: AppDurations.base,
      curve: AppCurves.emphasized,
      child: child,
    );
  }
}
