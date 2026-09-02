import 'package:flutter/widgets.dart';

/// Animation duration scale used across the app.
abstract final class AppDurations {
  /// 180 ms.
  static const fast = Duration(milliseconds: 180);

  /// 320 ms.
  static const base = Duration(milliseconds: 320);

  /// 520 ms.
  static const slow = Duration(milliseconds: 520);

  /// 420 ms. Used for page transitions.
  static const page = Duration(milliseconds: 420);

  /// Returns [duration], or [Duration.zero] when the system requests
  /// reduced motion.
  static Duration resolve(BuildContext context, Duration duration) {
    return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
  }
}
