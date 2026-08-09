import 'package:flutter/painting.dart';

/// Semantic color tokens for a single theme mode.
///
/// All colors except [error], [success] and [warning] are pure neutrals
/// (equal red, green and blue channels), matching the monochrome visual
/// identity. The three semantic colors are the deliberate exception and
/// must only be used in textual feedback, never as UI accents.
class AppColors {
  /// Creates an [AppColors] palette.
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.onAccent,
    required this.divider,
    required this.shadow,
    required this.error,
    required this.success,
    required this.warning,
  });

  /// Light theme palette.
  static const light = AppColors(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF2F2F2),
    surfaceAlt: Color(0xFFE8E8E8),
    card: Color(0xFFF7F7F7),
    textPrimary: Color(0xFF0A0A0A),
    textSecondary: Color(0xFF757575),
    textTertiary: Color(0xFFA3A3A3),
    accent: Color(0xFF0A0A0A),
    onAccent: Color(0xFFFFFFFF),
    divider: Color(0xFFEAEAEA),
    shadow: Color(0x14000000),
    error: Color(0xFFB3261E),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFB26A00),
  );

  /// Dark theme palette.
  static const dark = AppColors(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF171717),
    surfaceAlt: Color(0xFF212121),
    card: Color(0xFF161616),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF9C9C9C),
    textTertiary: Color(0xFF6B6B6B),
    accent: Color(0xFFF5F5F5),
    onAccent: Color(0xFF0A0A0A),
    divider: Color(0xFF242424),
    shadow: Color(0x59000000),
    error: Color(0xFFF2B8B5),
    success: Color(0xFF81C995),
    warning: Color(0xFFF2C078),
  );

  /// Primary background of the screen.
  final Color background;

  /// Base surface color, above [background].
  final Color surface;

  /// Alternate surface color, for a subtle layer above [surface].
  final Color surfaceAlt;

  /// Surface color of cards.
  final Color card;

  /// Primary text color.
  final Color textPrimary;

  /// Secondary, de-emphasized text color.
  final Color textSecondary;

  /// Tertiary, most de-emphasized text color.
  final Color textTertiary;

  /// Accent color, used for the primary interactive elements.
  final Color accent;

  /// Color of content placed on top of [accent].
  final Color onAccent;

  /// Divider and hairline color.
  final Color divider;

  /// Shadow color.
  final Color shadow;

  /// Used only in textual feedback; never breaks the monochrome UI.
  final Color error;

  /// Used only in textual feedback; never breaks the monochrome UI.
  final Color success;

  /// Used only in textual feedback; never breaks the monochrome UI.
  final Color warning;
}
