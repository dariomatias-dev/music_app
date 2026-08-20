import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the Home tab.
abstract final class HomeNavigator {
  /// Replaces the current route with Home, once onboarding, permissions
  /// and startup preparation are done.
  static void goToHome(BuildContext context) {
    const HomeRoute().go(context);
  }
}
