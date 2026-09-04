/// Status of the permission the OS playback notification needs.
enum NotificationPermissionStatus {
  /// Notifications are allowed.
  granted,

  /// Denied, and asking again still shows the system prompt.
  denied,

  /// Denied for good; only the system settings can change it.
  permanentlyDenied,

  /// The platform shows the media controls without a permission of its
  /// own, so there is nothing to ask for or to report.
  notApplicable,
}

/// Abstraction over the platform's notification permission.
///
/// Separate from the media permission: media access gates the whole
/// library and blocks onboarding until it is granted, while notifications
/// only decide whether the playback controls reach the notification shade
/// and the lock screen, and the app stays usable without them.
abstract interface class NotificationPermissionService {
  /// Returns the current status without prompting the user.
  Future<NotificationPermissionStatus> check();

  /// Prompts the user for the notification permission.
  ///
  /// Returns the current status untouched when there is nothing to ask:
  /// the platform has no such permission, the permission is already
  /// granted, or the answer is permanently denied and only the system
  /// settings can change it.
  Future<NotificationPermissionStatus> request();

  /// Opens the system settings screen for this app.
  Future<void> openSystemSettings();
}
