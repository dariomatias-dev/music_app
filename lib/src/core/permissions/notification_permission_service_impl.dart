import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// [NotificationPermissionService] implementation backed by
/// `permission_handler`.
///
/// Only Android has a permission to ask for here: iOS draws the playback
/// controls from the now-playing info centre, which needs no authorization,
/// so prompting there would cost the user a dialog that buys nothing.
class NotificationPermissionServiceImpl
    implements NotificationPermissionService {
  /// Creates a [NotificationPermissionServiceImpl], optionally for a
  /// [platform] other than the one the app is running on (useful for
  /// tests).
  const NotificationPermissionServiceImpl({TargetPlatform? platform})
    : _platform = platform;

  final TargetPlatform? _platform;

  bool get _asksForPermission =>
      (_platform ?? defaultTargetPlatform) == TargetPlatform.android;

  @override
  Future<NotificationPermissionStatus> check() async {
    if (!_asksForPermission) return NotificationPermissionStatus.notApplicable;
    return _map(await Permission.notification.status);
  }

  @override
  Future<NotificationPermissionStatus> request() async {
    final current = await check();
    if (current != NotificationPermissionStatus.denied) return current;
    return _map(await Permission.notification.request());
  }

  @override
  Future<void> openSystemSettings() async {
    await openAppSettings();
  }

  NotificationPermissionStatus _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return NotificationPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    }
    return NotificationPermissionStatus.denied;
  }
}
