import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the about screen.
abstract final class SettingsNavigator {
  /// Pushes the about screen.
  static Future<void> openAbout(BuildContext context) {
    return const AboutRoute().push(context);
  }
}
