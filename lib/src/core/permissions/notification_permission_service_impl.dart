import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// [NotificationPermissionService] implementation backed by
/// `permission_handler`.
class NotificationPermissionServiceImpl
    implements NotificationPermissionService {
  /// Creates a [NotificationPermissionServiceImpl].
  const NotificationPermissionServiceImpl();

  /// Reads the status before prompting: once the answer is granted or
  /// permanently denied, a request shows nothing and returns that same
  /// answer.
  @override
  Future<bool> request() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) return false;
    return (await Permission.notification.request()).isGranted;
  }
}
