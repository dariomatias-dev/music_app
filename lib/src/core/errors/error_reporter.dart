import 'dart:developer' as developer;

/// Records a failure that reached the app's outermost boundary, where no
/// other code was left to handle it.
abstract interface class ErrorReporter {
  /// Records [error] and its [stackTrace], with an optional [context]
  /// naming what the app was doing when it failed.
  void report(Object error, StackTrace stackTrace, {String? context});
}

/// [ErrorReporter] implementation that writes to the platform log.
///
/// The app deliberately ships without a crash reporting backend, since
/// nothing about a local player's usage should leave the device: the
/// device log is where an otherwise invisible release failure can still be
/// read back from.
class LogErrorReporter implements ErrorReporter {
  /// Creates a [LogErrorReporter].
  const LogErrorReporter();

  @override
  void report(Object error, StackTrace stackTrace, {String? context}) {
    developer.log(
      context ?? 'Unhandled error',
      name: 'music_app',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
