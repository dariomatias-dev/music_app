import 'package:app_ui/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

/// Exposes [AppColors] through the [Theme], since [ColorScheme] cannot
/// represent every token (e.g. [AppColors.surfaceAlt], [AppColors.card]).
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  /// Creates an [AppColorsExtension] wrapping [colors].
  const AppColorsExtension(this.colors);

  /// The wrapped color tokens.
  final AppColors colors;

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(
    ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    // Tokens are discrete, not meant to be interpolated channel-by-channel;
    // snap at the midpoint of the theme-switch crossfade.
    return t < 0.5 ? this : other;
  }
}

/// Convenience access to the app's color tokens from a [BuildContext].
extension AppColorsContext on BuildContext {
  /// The color tokens of the current [Theme].
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.colors;
}
