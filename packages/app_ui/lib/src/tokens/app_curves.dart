import 'package:flutter/animation.dart';

/// Animation curves used across the app.
abstract final class AppCurves {
  /// Standard curve for most transitions.
  static const emphasized = Cubic(0.2, 0, 0, 1);

  /// Curve for elements settling into place.
  static const decelerate = Cubic(0.05, 0.7, 0.1, 1);

  /// Curve with a slight overshoot, for playful confirmations.
  static const spring = Cubic(0.34, 1.35, 0.64, 1);
}
