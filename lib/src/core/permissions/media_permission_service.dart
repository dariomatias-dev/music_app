/// Status of the media access permission.
enum MediaPermissionStatus {
  /// The permission is granted.
  granted,

  /// The permission was denied and may be requested again.
  denied,

  /// The permission was permanently denied; only the system settings can
  /// change it.
  permanentlyDenied,
}

/// Abstraction over the platform's media access permission.
abstract interface class MediaPermissionService {
  /// Returns the current permission status without prompting the user.
  Future<MediaPermissionStatus> check();

  /// Prompts the user for the media access permission.
  Future<MediaPermissionStatus> request();

  /// Opens the system settings screen for this app.
  Future<void> openSystemSettings();
}
