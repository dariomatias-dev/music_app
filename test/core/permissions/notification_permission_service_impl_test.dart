import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
  const service = NotificationPermissionServiceImpl();

  final calls = <MethodCall>[];

  /// Answers the plugin's channel with [status] for the current status and
  /// [requested] for the prompt's outcome.
  void stubPlatform(PermissionStatus status, {PermissionStatus? requested}) {
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

  test('prompts when the permission has not been decided yet', () async {
    stubPlatform(PermissionStatus.denied, requested: PermissionStatus.granted);

    expect(await service.request(), isTrue);
    expect(
      calls.map((call) => call.method),
      ['checkPermissionStatus', 'requestPermissions'],
    );
    expect(calls.last.arguments, [Permission.notification.value]);
  });

  test('reports a refused prompt', () async {
    stubPlatform(PermissionStatus.denied);

    expect(await service.request(), isFalse);
  });

  test('does not prompt again once granted', () async {
    stubPlatform(PermissionStatus.granted);

    expect(await service.request(), isTrue);
    expect(calls.single.method, 'checkPermissionStatus');
  });

  test('does not prompt again once permanently denied', () async {
    stubPlatform(PermissionStatus.permanentlyDenied);

    expect(await service.request(), isFalse);
    expect(calls.single.method, 'checkPermissionStatus');
  });
}
