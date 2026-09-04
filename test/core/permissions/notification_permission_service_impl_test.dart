import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service_impl.dart';
import 'package:permission_handler/permission_handler.dart';

/// The channel `permission_handler` talks to.
const _channel = MethodChannel('flutter.baseflow.com/permissions/methods');

/// The wire value `permission_handler` encodes each status as.
const _statusValues = <PermissionStatus, int>{
  PermissionStatus.denied: 0,
  PermissionStatus.granted: 1,
  PermissionStatus.restricted: 2,
  PermissionStatus.limited: 3,
  PermissionStatus.permanentlyDenied: 4,
};

void main() {
  const service = NotificationPermissionServiceImpl(
    platform: TargetPlatform.android,
  );

  final calls = <MethodCall>[];

  /// Answers the plugin's channel with [status] for the current status and
  /// [requested] for the prompt's outcome.
  void stubPlatform(
    PermissionStatus status, {
    PermissionStatus? requested,
    bool settingsOpened = true,
  }) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          switch (call.method) {
            case 'checkPermissionStatus':
              return _statusValues[status];
            case 'requestPermissions':
              return {
                Permission.notification.value:
                    _statusValues[requested ?? status],
              };
            case 'openAppSettings':
              return settingsOpened;
            default:
              return null;
          }
        });
  }

  setUp(calls.clear);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group('check', () {
    test('asks the platform about the notification permission', () async {
      stubPlatform(PermissionStatus.granted);

      await service.check();

      expect(calls.single.method, 'checkPermissionStatus');
      expect(calls.single.arguments, Permission.notification.value);
    });

    test('reports a granted permission', () async {
      stubPlatform(PermissionStatus.granted);

      expect(await service.check(), NotificationPermissionStatus.granted);
    });

    test('reports a denied permission', () async {
      stubPlatform(PermissionStatus.denied);

      expect(await service.check(), NotificationPermissionStatus.denied);
    });

    test('reports a permanently denied permission', () async {
      stubPlatform(PermissionStatus.permanentlyDenied);

      expect(
        await service.check(),
        NotificationPermissionStatus.permanentlyDenied,
      );
    });

    test('folds an OS restriction into denied', () async {
      stubPlatform(PermissionStatus.restricted);

      expect(await service.check(), NotificationPermissionStatus.denied);
    });

    test('reports nothing to ask for off Android', () async {
      const iosService = NotificationPermissionServiceImpl(
        platform: TargetPlatform.iOS,
      );
      stubPlatform(PermissionStatus.denied);

      expect(
        await iosService.check(),
        NotificationPermissionStatus.notApplicable,
      );
      expect(calls, isEmpty);
    });
  });

  group('request', () {
    test("prompts while the answer is still the app's to ask for", () async {
      stubPlatform(
        PermissionStatus.denied,
        requested: PermissionStatus.granted,
      );

      expect(await service.request(), NotificationPermissionStatus.granted);
      expect(
        calls.map((call) => call.method),
        ['checkPermissionStatus', 'requestPermissions'],
      );
      expect(calls.last.arguments, [Permission.notification.value]);
    });

    test('reports a refused prompt', () async {
      stubPlatform(PermissionStatus.denied);

      expect(await service.request(), NotificationPermissionStatus.denied);
    });

    test('does not prompt again once granted', () async {
      stubPlatform(PermissionStatus.granted);

      expect(await service.request(), NotificationPermissionStatus.granted);
      expect(calls.single.method, 'checkPermissionStatus');
    });

    test('does not prompt again once permanently denied', () async {
      stubPlatform(PermissionStatus.permanentlyDenied);

      expect(
        await service.request(),
        NotificationPermissionStatus.permanentlyDenied,
      );
      expect(calls.single.method, 'checkPermissionStatus');
    });

    test('does not prompt at all off Android', () async {
      const iosService = NotificationPermissionServiceImpl(
        platform: TargetPlatform.iOS,
      );
      stubPlatform(PermissionStatus.denied);

      expect(
        await iosService.request(),
        NotificationPermissionStatus.notApplicable,
      );
      expect(calls, isEmpty);
    });
  });

  group('openSystemSettings', () {
    test('asks the platform to open the app settings', () async {
      stubPlatform(PermissionStatus.denied);

      await service.openSystemSettings();

      expect(calls.single.method, 'openAppSettings');
    });

    test('completes even when the platform could not open them', () async {
      stubPlatform(PermissionStatus.denied, settingsOpened: false);

      await expectLater(service.openSystemSettings(), completes);
    });
  });
}
