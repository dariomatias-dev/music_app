/// Abstraction over the platform's notification permission.
///
/// Separate from the media permission: media access gates the whole
/// library and blocks onboarding until it is granted, while notifications
/// only decide whether the playback controls reach the notification shade
/// and the lock screen, and the app stays usable without them.
abstract interface class NotificationPermissionService {
  /// Prompts the user for the notification permission, unless the platform
  /// has no such permission (Android 12 and below, iOS), where playback
  /// notifications need no consent and this does nothing.
  ///
  /// Returns whether notifications are allowed once the prompt is done.
  Future<bool> request();
}
