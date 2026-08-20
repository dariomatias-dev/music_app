import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the onboarding and permission flow.
abstract final class OnboardingNavigator {
  /// Replaces the current route with the onboarding flow, from the start.
  static void goToOnboarding(BuildContext context) {
    const OnboardingRoute().go(context);
  }

  /// Replaces the current route with the media permission screen.
  static void goToPermissions(BuildContext context) {
    const PermissionsRoute().go(context);
  }
}
