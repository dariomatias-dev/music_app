import 'package:music_app/src/core/errors/error_reporter.dart';

/// One call recorded by a [FakeErrorReporter].
class ReportedError {
  /// Creates a [ReportedError].
  const ReportedError(this.error, this.stackTrace, this.context);

  /// The reported error.
  final Object error;

  /// The stack trace reported alongside it.
  final StackTrace stackTrace;

  /// The context the error was reported with, if any.
  final String? context;
}

/// In-memory [ErrorReporter] for tests.
class FakeErrorReporter implements ErrorReporter {
  /// Every call made to [report], oldest first.
  final reports = <ReportedError>[];

  @override
  void report(Object error, StackTrace stackTrace, {String? context}) {
    reports.add(ReportedError(error, stackTrace, context));
  }
}
