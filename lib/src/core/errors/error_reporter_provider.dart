import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/errors/error_reporter.dart';

/// Provides the [ErrorReporter] used across the app.
final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const LogErrorReporter(),
);
