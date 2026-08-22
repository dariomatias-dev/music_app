import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/media_permission_service_impl.dart';
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
  const service = MediaPermissionServiceImpl();

  final calls = <MethodCall>[];

  /// Answers the plugin's channel with [status] for both check and request.
  void stubPlatform(PermissionStatus status, {bool settingsOpened = true}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          switch (call.method) {
            case 'checkPermissionStatus':
              return _statusValues[status];
            case 'requestPermissions':
              return {Permission.audio.value: _statusValues[status]};
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
    test('asks the platform about the audio permission', () async {
      stubPlatform(PermissionStatus.granted);

      await service.check();

      expect(calls.single.method, 'checkPermissionStatus');
      expect(calls.single.arguments, Permission.audio.value);
    });

    test('reports a granted permission', () async {
      stubPlatform(PermissionStatus.granted);

      expect(await service.check(), MediaPermissionStatus.granted);
    });

    test('treats limited access as granted', () async {
      stubPlatform(PermissionStatus.limited);

      expect(await service.check(), MediaPermissionStatus.granted);
    });

    test('reports a permanently denied permission', () async {
      stubPlatform(PermissionStatus.permanentlyDenied);

      expect(
        await service.check(),
        MediaPermissionStatus.permanentlyDenied,
      );
    });

    test('reports a denied permission', () async {
      stubPlatform(PermissionStatus.denied);

      expect(await service.check(), MediaPermissionStatus.denied);
    });

    test('folds an OS restriction into denied', () async {
      stubPlatform(PermissionStatus.restricted);

      expect(await service.check(), MediaPermissionStatus.denied);
    });
  });

  group('request', () {
    test('asks the platform to request the audio permission', () async {
      stubPlatform(PermissionStatus.granted);

      await service.request();

      expect(calls.single.method, 'requestPermissions');
      expect(calls.single.arguments, [Permission.audio.value]);
    });

    test('maps the answer the same way check does', () async {
      stubPlatform(PermissionStatus.permanentlyDenied);

      expect(
        await service.request(),
        MediaPermissionStatus.permanentlyDenied,
      );
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
