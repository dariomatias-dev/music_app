import 'package:flutter/painting.dart';

/// Shadow presets used across the app, parameterized by the theme's shadow
/// color since it differs between light and dark mode.
abstract final class AppElevations {
  /// No shadow.
  static const none = <BoxShadow>[];

  /// Subtle contact shadow, for small elements such as a switch thumb.
  static List<BoxShadow> low(Color shadow) => [
    BoxShadow(color: shadow, blurRadius: 4, offset: const Offset(0, 1)),
  ];

  /// Shadow for small floating elements, such as circular buttons.
  static List<BoxShadow> medium(Color shadow) => [
    BoxShadow(
      color: shadow,
      blurRadius: 12,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
  ];

  /// Two-layer shadow for large floating surfaces, such as the mini player:
  /// a tight contact shadow plus a wider ambient one.
  static List<BoxShadow> high(Color shadow) => [
    BoxShadow(
      color: shadow,
      blurRadius: 6,
      spreadRadius: -1,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: shadow,
      blurRadius: 28,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];
}
