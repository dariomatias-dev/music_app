import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/notification_permission_view_model.dart';

import '../../../../helpers/fake_app_lifecycle_service.dart';
import '../../../../helpers/fake_notification_permission_service.dart';

void main() {
  late FakeNotificationPermissionService permissionService;
  late FakeAppLifecycleService lifecycle;
  late ProviderContainer container;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        notificationPermissionServiceProvider.overrideWithValue(
          permissionService,
        ),
        appLifecycleServiceProvider.overrideWithValue(lifecycle),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(
      container.listen(appLifecycleStateProvider, (_, _) {}).close,
    );
    addTearDown(
      container
          .listen(notificationPermissionViewModelProvider, (_, _) {})
          .close,
    );
    return container;
  }

  setUp(() {
    permissionService = FakeNotificationPermissionService();
    lifecycle = FakeAppLifecycleService();
    addTearDown(lifecycle.dispose);
  });

  test('reports the status the platform starts on', () async {
    permissionService.status = NotificationPermissionStatus.denied;
    container = buildContainer();

    expect(
      await container.read(notificationPermissionViewModelProvider.future),
      NotificationPermissionStatus.denied,
    );
  });

  test('prompts and keeps the answer while it can still be asked', () async {
    permissionService
      ..status = NotificationPermissionStatus.denied
      ..requestedStatus = NotificationPermissionStatus.granted;
    container = buildContainer();
    await container.read(notificationPermissionViewModelProvider.future);

    await container
        .read(notificationPermissionViewModelProvider.notifier)
        .requestOrOpenSettings();

    expect(permissionService.requestCalls, 1);
    expect(permissionService.openSettingsCalls, 0);
    expect(
      container.read(notificationPermissionViewModelProvider).value,
      NotificationPermissionStatus.granted,
    );
  });

  test('opens the system settings once permanently denied', () async {
    permissionService.status = NotificationPermissionStatus.permanentlyDenied;
    container = buildContainer();
    await container.read(notificationPermissionViewModelProvider.future);

    await container
        .read(notificationPermissionViewModelProvider.notifier)
        .requestOrOpenSettings();

    expect(permissionService.openSettingsCalls, 1);
    expect(permissionService.requestCalls, 0);
  });

  test('re-reads the status when the app comes back', () async {
    permissionService.status = NotificationPermissionStatus.denied;
    container = buildContainer();
    await container.read(notificationPermissionViewModelProvider.future);

    permissionService.status = NotificationPermissionStatus.granted;
    lifecycle.emit(AppLifecycleState.resumed);
    await pumpEventQueue();

    expect(
      container.read(notificationPermissionViewModelProvider).value,
      NotificationPermissionStatus.granted,
    );
  });

  test('ignores lifecycle states other than coming back', () async {
    permissionService.status = NotificationPermissionStatus.denied;
    container = buildContainer();
    await container.read(notificationPermissionViewModelProvider.future);

    permissionService.status = NotificationPermissionStatus.granted;
    lifecycle.emit(AppLifecycleState.paused);
    await pumpEventQueue();

    expect(
      container.read(notificationPermissionViewModelProvider).value,
      NotificationPermissionStatus.denied,
    );
  });
}
