/// Base type for exceptions thrown by the application.
///
/// Exceptions from third-party libraries must be converted to one of these
/// before reaching upper layers.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// Technical description of the failure, for logging and debugging.
  final String message;

  /// The underlying exception that caused this failure, if any.
  final Object? cause;

  @override
  String toString() => cause == null ? message : '$message (cause: $cause)';
}

/// Thrown when a required permission is denied.
final class PermissionException extends AppException {
  /// Creates a [PermissionException].
  const PermissionException(super.message, {super.cause});
}

/// Thrown when reading or writing a file fails.
final class FileException extends AppException {
  /// Creates a [FileException].
  const FileException(super.message, {super.cause});
}

/// Thrown when audio playback fails.
final class PlaybackException extends AppException {
  /// Creates a [PlaybackException].
  const PlaybackException(super.message, {super.cause});
}
