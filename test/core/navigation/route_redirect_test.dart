import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/navigation/route_redirect.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';

import '../../helpers/fake_key_value_storage.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _FakeMediaPermissionService implements MediaPermissionService {
  MediaPermissionStatus status = MediaPermissionStatus.denied;

  @override
  Future<MediaPermissionStatus> check() async => status;

  @override
  Future<MediaPermissionStatus> request() async => status;

  @override
  Future<void> openSystemSettings() async {}
}

void main() {
  late FakeKeyValueStorage storage;
  late _FakeMediaPermissionService permissionService;
  late ProviderContainer container;
  late Ref ref;

  GoRouterState stateAt(String location) {
    final state = _MockGoRouterState();
    when(() => state.matchedLocation).thenReturn(location);
    return state;
  }

  setUp(() {
    storage = FakeKeyValueStorage();
    permissionService = _FakeMediaPermissionService();
    container = ProviderContainer(
      overrides: [
        keyValueStorageProvider.overrideWithValue(storage),
        mediaPermissionServiceProvider.overrideWithValue(permissionService),
      ],
    );
    ref = container.read(Provider<Ref>((ref) => ref));
  });

  tearDown(() => container.dispose());

  test('never redirects away from the splash route', () async {
    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.splash),
    );

    expect(result, isNull);
  });

  test('redirects to onboarding when it has not been completed', () async {
    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.home),
    );

    expect(result, RoutePaths.onboarding);
  });

  test('stays on onboarding while it is incomplete', () async {
    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.onboarding),
    );

    expect(result, isNull);
  });

  test('redirects to permissions once onboarding completes', () async {
    await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);

    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.home),
    );

    expect(result, RoutePaths.permissions);
  });

  test('stays on the permission screen while it is not granted', () async {
    await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);

    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.permissions),
    );

    expect(result, isNull);
  });

  test('sends onboarding and permissions to home once granted', () async {
    await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);
    permissionService.status = MediaPermissionStatus.granted;

    expect(
      await appRouteRedirect(ref: ref, state: stateAt(RoutePaths.onboarding)),
      RoutePaths.home,
    );
    expect(
      await appRouteRedirect(
        ref: ref,
        state: stateAt(RoutePaths.permissions),
      ),
      RoutePaths.home,
    );
  });

  test('does not redirect once onboarded and granted', () async {
    await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);
    permissionService.status = MediaPermissionStatus.granted;

    final result = await appRouteRedirect(
      ref: ref,
      state: stateAt(RoutePaths.home),
    );

    expect(result, isNull);
  });
}
