import 'package:music_app/src/core/permissions/notification_permission_service.dart';

/// [NotificationPermissionService] for tests, answering with the status it
/// is given instead of reaching the platform.
class FakeNotificationPermissionService
    implements NotificationPermissionService {
  /// Creates a [FakeNotificationPermissionService] reporting [status], and
  /// answering a request with [requestedStatus] when given.
  FakeNotificationPermissionService({
    this.status = NotificationPermissionStatus.granted,
    NotificationPermissionStatus? requestedStatus,
  }) : requestedStatus = requestedStatus ?? status;

  /// What [check] reports.
  NotificationPermissionStatus status;

  /// What [request] answers with, and what [check] reports from then on.
  NotificationPermissionStatus requestedStatus;

  /// How many times [request] was called.
  int requestCalls = 0;

  /// How many times [openSystemSettings] was called.
  int openSettingsCalls = 0;

  @override
  Future<NotificationPermissionStatus> check() async => status;

  @override
  Future<NotificationPermissionStatus> request() async {
    requestCalls++;
    return status = requestedStatus;
  }

  @override
  Future<void> openSystemSettings() async {
    openSettingsCalls++;
  }
}
