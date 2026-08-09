import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// [MediaPermissionService] implementation backed by `permission_handler`.
class MediaPermissionServiceImpl implements MediaPermissionService {
  /// Creates a [MediaPermissionServiceImpl].
  const MediaPermissionServiceImpl();

  @override
  Future<MediaPermissionStatus> check() async {
    return _map(await Permission.audio.status);
  }

  @override
  Future<MediaPermissionStatus> request() async {
    return _map(await Permission.audio.request());
  }

  @override
  Future<void> openSystemSettings() async {
    await openAppSettings();
  }

  MediaPermissionStatus _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return MediaPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return MediaPermissionStatus.permanentlyDenied;
    }
    return MediaPermissionStatus.denied;
  }
}
