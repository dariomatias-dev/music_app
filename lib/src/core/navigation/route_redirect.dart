import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/navigation/app_router.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';

/// Centralizes the onboarding and media permission redirects.
///
/// Does not perform slow operations, show feedback, or contain business
/// rules; it only decides where the router should send the user.
Future<String?> appRouteRedirect({
  required Ref ref,
  required GoRouterState state,
}) async {
  final location = state.matchedLocation;
  const splash = SplashRoute();
  const onboarding = OnboardingRoute();
  const permissions = PermissionsRoute();
  const home = HomeRoute();

  if (location == splash.location) {
    // The splash screen decides its own destination once ready.
    return null;
  }

  final onboardingCompleted =
      await ref
          .read(keyValueStorageProvider)
          .getBool(PreferenceKeys.onboardingCompleted) ??
      false;

  if (!onboardingCompleted) {
    return location == onboarding.location ? null : onboarding.location;
  }

  final permissionStatus = await ref
      .read(mediaPermissionServiceProvider)
      .check();

  if (permissionStatus != MediaPermissionStatus.granted) {
    return location == permissions.location ? null : permissions.location;
  }

  if (location == onboarding.location || location == permissions.location) {
    return home.location;
  }

  return null;
}
