import 'package:flutter/widgets.dart';

/// Width thresholds for adapting layout to larger screens (tablets,
/// foldables unfolded, desktop), aligned with Material 3's window size
/// classes.
abstract final class AppBreakpoints {
  /// Below this width, the window is a phone in portrait: single-column
  /// layouts, bottom navigation.
  static const compact = 600.0;

  /// At and above this width (a tablet, an unfolded foldable, or a phone
  /// in landscape on a large device), there's room for a side navigation
  /// rail and multi-column content.
  static const medium = 840.0;

  /// Whether [context]'s width is at or above [medium].
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= medium;
}
